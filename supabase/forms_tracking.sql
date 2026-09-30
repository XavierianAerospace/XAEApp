-- ============================================================================
-- Seguimiento de envíos de formularios: periodos, reset (manual + pg_cron) y
-- bloqueo de reenvío en el periodo actual.
-- Ejecutar en Supabase → SQL Editor (es idempotente: se puede correr varias veces).
-- REQUISITO PREVIO: activar la extensión pg_cron en Database → Extensions.
--
-- NOTA DE ACOPLAMIENTO: las 4 claves de sección de Gestión Documental
-- ('presidencia', 'lider_proyecto', 'grupo_proyecto', 'individual') se repiten
-- en la app (document_management_form_screen.dart). Deben coincidir con las
-- semillas de abajo; si no, el trigger no encuentra periodo y no bloquea esa sección.
-- ============================================================================

-- 0) Predicado superuser reutilizable (misma condición que ya se usa en el proyecto).
--    security definer para no depender de la RLS de `users` ni arriesgar recursión.
create or replace function public.is_superuser()
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1 from public.users u
    where u.auth_id = auth.uid() and u.role = 'superuser'
  );
$$;

-- 1) Periodos por formulario dinámico y por sección de Gestión Documental.
create table if not exists public.form_periods (
  form_type   text not null,
  section_key text not null default '',
  frecuencia  text not null default 'ninguna'
    check (frecuencia in ('semanal', 'mensual', 'semestral', 'ninguna')),
  reset_at    timestamptz not null default now(),
  constraint form_periods_pkey primary key (form_type, section_key)
);

-- 2) Columnas nuevas (defensivo con if not exists).
alter table public.form_text_submissions
  add column if not exists submitted_at timestamptz not null default now();
-- envio_id agrupa varios archivos de un mismo envío. SIN default: la app envía uno por
-- envío; un default daría un id distinto por fila y las haría bloquearse entre sí.
alter table public.form_file_submissions
  add column if not exists envio_id uuid;

-- 3) Semillas.
-- 3a) Las 4 secciones fijas de Gestión Documental (frecuencias no editables desde la UI).
insert into public.form_periods (form_type, section_key, frecuencia) values
  ('document_management', 'presidencia',    'semestral'),
  ('document_management', 'lider_proyecto', 'semanal'),
  ('document_management', 'grupo_proyecto', 'mensual'),
  ('document_management', 'individual',     'semanal')
on conflict (form_type, section_key) do nothing;
-- 3b) Un periodo por cada formulario dinámico existente (arranca en 'ninguna').
insert into public.form_periods (form_type, section_key, frecuencia)
  select key, '', 'ninguna' from public.forms
on conflict (form_type, section_key) do nothing;

-- 4) Al crear un formulario, crear su periodo; si cambia la clave, sincronizarlo.
create or replace function public.forms_sync_period()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if tg_op = 'INSERT' then
    insert into public.form_periods (form_type, section_key, frecuencia)
    values (new.key, '', 'ninguna')
    on conflict (form_type, section_key) do nothing;
  elsif tg_op = 'UPDATE' and new.key is distinct from old.key then
    -- Renombrar el periodo del formulario; tolerar choque de clave existente.
    begin
      update public.form_periods
      set form_type = new.key
      where form_type = old.key and section_key = '';
    exception when unique_violation then
      null;
    end;
  end if;
  return new;
end;
$$;

drop trigger if exists forms_sync_period_trg on public.forms;
create trigger forms_sync_period_trg
  after insert or update of key on public.forms
  for each row execute function public.forms_sync_period();

-- 5) Bloqueo de reenvío en el periodo actual (BEFORE INSERT en ambas tablas).
--    Un envío pertenece al periodo actual si su fecha es >= reset_at.
--    La frecuencia NO afecta este bloqueo (solo define el reset automático):
--    'ninguna' => queda bloqueado hasta un reset manual del superuser.
create or replace function public.forms_block_duplicate()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_section text := coalesce(to_jsonb(new) ->> 'section_key', '');  -- la tabla de texto no tiene section_key
  v_reset   timestamptz;
begin
  if new.user_auth_id is null then
    raise exception using errcode = 'P0001',
      message = 'DUPLICADO: no se pudo identificar al usuario.';
  end if;

  select reset_at into v_reset
  from public.form_periods
  where form_type = new.form_type and section_key = v_section;

  -- Sin periodo configurado: no se restringe (formulario no rastreado).
  if v_reset is null then
    return new;
  end if;

  -- Serializa por (usuario, formulario, sección) para evitar carreras concurrentes.
  perform pg_advisory_xact_lock(
    hashtextextended(new.user_auth_id::text || '|' || new.form_type || '|' || v_section, 0));

  if tg_table_name = 'form_file_submissions' then
    if new.envio_id is null then
      raise exception using errcode = 'P0001',
        message = 'DUPLICADO: falta el identificador de envío.';
    end if;
    if exists (
      select 1 from public.form_file_submissions s
      where s.user_auth_id = new.user_auth_id
        and s.form_type    = new.form_type
        and coalesce(s.section_key, '') = v_section
        and s.uploaded_at >= v_reset
        and s.envio_id is distinct from new.envio_id
    ) then
      raise exception using errcode = 'P0001',
        message = 'DUPLICADO: ya enviaste esta sección en el periodo actual.';
    end if;
  else
    if exists (
      select 1 from public.form_text_submissions s
      where s.user_auth_id = new.user_auth_id
        and s.form_type    = new.form_type
        and s.submitted_at >= v_reset
    ) then
      raise exception using errcode = 'P0001',
        message = 'DUPLICADO: ya enviaste este formulario en el periodo actual.';
    end if;
  end if;

  return new;
end;
$$;

drop trigger if exists form_text_block_dup_trg on public.form_text_submissions;
create trigger form_text_block_dup_trg
  before insert on public.form_text_submissions
  for each row execute function public.forms_block_duplicate();

drop trigger if exists form_files_block_dup_trg on public.form_file_submissions;
create trigger form_files_block_dup_trg
  before insert on public.form_file_submissions
  for each row execute function public.forms_block_duplicate();

-- 6) Reset manual (solo superuser). p_section_key null => todas las secciones del form_type.
create or replace function public.reset_form_period(
  p_form_type   text,
  p_section_key text default null
)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if not public.is_superuser() then
    raise exception using errcode = '42501',
      message = 'NO_AUTORIZADO: solo un superuser puede resetear.';
  end if;
  update public.form_periods
  set reset_at = now()
  where form_type = p_form_type
    and (p_section_key is null or section_key = p_section_key);
end;
$$;

revoke execute on function public.reset_form_period(text, text) from public;
grant  execute on function public.reset_form_period(text, text) to authenticated;

-- 7) Reset por frecuencia (solo lo invoca pg_cron; no expuesto a usuarios).
create or replace function public.reset_forms_by_frequency(p_frecuencia text)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  update public.form_periods set reset_at = now() where frecuencia = p_frecuencia;
end;
$$;

-- Supabase concede EXECUTE a anon/authenticated de forma explícita en `public`;
-- revocar solo a PUBLIC no basta. pg_cron corre como postgres y no se ve afectado.
revoke execute on function public.reset_forms_by_frequency(text) from public, anon, authenticated;

-- 8) RLS.
-- 8a) form_periods: todos los autenticados leen, solo superuser modifica.
alter table public.form_periods enable row level security;
drop policy if exists form_periods_select_auth on public.form_periods;
create policy form_periods_select_auth on public.form_periods
  for select to authenticated using (true);
drop policy if exists form_periods_write_superuser on public.form_periods;
create policy form_periods_write_superuser on public.form_periods
  for all to authenticated
  using (public.is_superuser()) with check (public.is_superuser());

-- 8b) El superuser lee TODOS los envíos (se combina con OR con las políticas propias
--     existentes; NO se tocan las existentes).
alter table public.form_text_submissions enable row level security;
drop policy if exists form_text_superuser_read on public.form_text_submissions;
create policy form_text_superuser_read on public.form_text_submissions
  for select to authenticated using (public.is_superuser());

alter table public.form_file_submissions enable row level security;
drop policy if exists form_files_superuser_read on public.form_file_submissions;
create policy form_files_superuser_read on public.form_file_submissions
  for select to authenticated using (public.is_superuser());

-- 8c) Storage: el superuser puede firmar (leer) cualquier archivo del bucket form-files.
--     (Las rutas se guardan por email, no por uid, así que la política propia no cubre
--      la lectura cruzada del superuser.)
drop policy if exists form_files_storage_superuser_read on storage.objects;
create policy form_files_storage_superuser_read on storage.objects
  for select to authenticated
  using (bucket_id = 'form-files' and public.is_superuser());

-- 9) pg_cron: reset automático en hora de Bogotá (UTC-5, sin horario de verano).
--    semanal -> lunes 00:00 COT = 05:00 UTC (0 5 * * 1)
--    mensual -> día 1 00:00 COT = 05:00 UTC (0 5 1 * *)
--    semestral y ninguna: solo reset manual (no se programan).
-- Desprogramar antes de volver a crear (idempotente; no falla si el job no existe).
select cron.unschedule(jobid) from cron.job where jobname = 'forms_reset_semanal';
select cron.unschedule(jobid) from cron.job where jobname = 'forms_reset_mensual';
select cron.schedule('forms_reset_semanal', '0 5 * * 1',
  $$select public.reset_forms_by_frequency('semanal')$$);
select cron.schedule('forms_reset_mensual', '0 5 1 * *',
  $$select public.reset_forms_by_frequency('mensual')$$);

-- Verificación:
--   select jobname, schedule, command from cron.job;   -- deben salir los 2 jobs
--   select * from public.form_periods;                 -- semillas + formularios

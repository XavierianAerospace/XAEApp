import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/widgets.dart';
import '../../domain/entities/form_definition.dart';
import '../../domain/repositories/forms_repository.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_state.dart';
import 'dynamic_form_screen.dart';
import 'forms_admin_screen.dart';
import 'forms_status.dart';

/// Lista de formularios disponibles. La "Gestión Documental" es una tarjeta
/// especial (flujo de archivos por secciones); el resto se cargan desde la BD.
class FormsScreen extends StatefulWidget {
  const FormsScreen({super.key});

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final FormsRepository _repo = GetIt.I<FormsRepository>();

  List<FormDefinition>? _forms;
  MyFormsStatus? _status;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _forms = null;
      _error = null;
    });
    try {
      final forms = await _repo.getForms();
      // El estado (marcas "Enviado") es opcional: si falla, no bloquea la lista.
      MyFormsStatus? status;
      try {
        status = await loadMyFormsStatus(_repo);
      } catch (_) {
        status = null;
      }
      if (!mounted) return;
      setState(() {
        _forms = forms.where((f) => f.activo).toList();
        _status = status;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  bool get _isSuperuser {
    final state = context.read<AuthBloc>().state;
    final user = state is AuthAuthenticated
        ? state.user
        : state is AuthAuthenticatedAwaitingBiometricChoice
            ? state.user
            : null;
    return user?.isSuperuser ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'FORMULARIOS',
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryAccent),
        onPressed: () => context.pop(),
      ),
      actions: [
        if (_isSuperuser)
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.primaryAccent),
            tooltip: 'Administrar formularios',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const FormsAdminScreen()),
              );
              _load();
            },
          ),
      ],
      body: RefreshIndicator(
        color: AppColors.primaryAccent,
        onRefresh: _load,
        child: ListView(
          children: [
            const SizedBox(height: 8),
            _FormCard(
              title: 'Sistema de Gestión Documental',
              description: 'Sube los documentos del semillero (metas, reportes, '
                  'fichas e informes).',
              icon: Icons.folder_copy_outlined,
              onTap: () async {
                await context.pushNamed('documentManagementForm');
                _load();
              },
            ).fadeInUp(),
            const SizedBox(height: 16),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text('// $_error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.error)),
              )
            else if (_forms == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              for (var i = 0; i < _forms!.length; i++) ...[
                _FormCard(
                  title: _forms![i].title,
                  description: _forms![i].description,
                  icon: Icons.assignment_outlined,
                  submitted:
                      _status?.isDynamicSubmitted(_forms![i].key) ?? false,
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DynamicFormScreen(form: _forms![i]),
                      ),
                    );
                    _load();
                  },
                ).fadeInUp(delay: Duration(milliseconds: 60 * (i + 1))),
                const SizedBox(height: 16),
              ],
          ],
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
    this.submitted = false,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;
  final bool submitted;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: onTap,
      glow: true,
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryAccent, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (submitted) const _SubmittedChip(),
                  ],
                ),
                const SizedBox(height: 6),
                Text(description, style: textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.primaryAccent),
        ],
      ),
    );
  }
}

/// Etiqueta "ENVIADO" para formularios ya enviados en el periodo actual.
class _SubmittedChip extends StatelessWidget {
  const _SubmittedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.success),
      ),
      child: const Text(
        'ENVIADO',
        style: TextStyle(
          color: AppColors.success,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

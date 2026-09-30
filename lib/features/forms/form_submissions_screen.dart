import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/widgets.dart';
import '../../domain/entities/form_file_submission.dart';
import '../../domain/entities/form_text_submission.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/forms_repository.dart';
import '../../domain/repositories/user_repository.dart';
import 'forms_status.dart';

/// Etiquetas legibles de las secciones fijas de Gestión Documental.
const Map<String, String> _docSectionLabels = {
  'presidencia': 'Presidencia',
  'lider_proyecto': 'Líder de proyecto',
  'grupo_proyecto': 'Grupo por proyecto',
  'individual': 'Individual por sesión',
};

/// Orden en que se muestran las secciones de Gestión Documental.
const List<String> _docSectionOrder = [
  'presidencia',
  'lider_proyecto',
  'grupo_proyecto',
  'individual',
];

/// Detalle de un formulario (solo superuser): quién lo ha enviado en el periodo
/// actual, con opción de ver respuestas/archivos y de resetear el periodo.
class FormSubmissionsScreen extends StatefulWidget {
  const FormSubmissionsScreen({
    super.key,
    required this.formType,
    required this.title,
    required this.isDocManagement,
    this.formId,
  });

  final String formType;
  final String title;
  final bool isDocManagement;

  /// Id del formulario dinámico (para etiquetar las respuestas). Null en Gestión
  /// Documental.
  final int? formId;

  @override
  State<FormSubmissionsScreen> createState() => _FormSubmissionsScreenState();
}

class _FormSubmissionsScreenState extends State<FormSubmissionsScreen> {
  final FormsRepository _repo = GetIt.I<FormsRepository>();
  final UserRepository _userRepo = GetIt.I<UserRepository>();

  bool _loading = true;
  String? _error;

  List<FormTextSubmission> _textSubs = [];
  List<FormFileSubmission> _fileSubs = [];
  Map<String, String> _fieldLabels = {}; // key -> label (dinámico)

  // Estado calculado.
  List<UserSubmissionStatus> _dynamicStatuses = [];
  List<UserDocStatus> _docStatuses = [];
  DateTime? _dynamicReset;
  Map<String, DateTime> _resetBySection = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final users = await _userRepo.getUsers();
      final periods = await _repo.getFormPeriods();

      if (widget.isDocManagement) {
        final files = await _repo.getSubmissions(widget.formType);
        final resetBySection = <String, DateTime>{};
        for (final p in periods) {
          if (p.formType == widget.formType && p.sectionKey.isNotEmpty) {
            resetBySection[p.sectionKey] = p.resetAt;
          }
        }
        final docStatuses = buildDocStatuses(users, files, resetBySection);
        if (!mounted) return;
        setState(() {
          _fileSubs = files;
          _resetBySection = resetBySection;
          _docStatuses = docStatuses;
          _loading = false;
        });
      } else {
        final subs = await _repo.getTextSubmissions(widget.formType);
        DateTime? reset;
        for (final p in periods) {
          if (p.formType == widget.formType && p.sectionKey.isEmpty) {
            reset = p.resetAt;
          }
        }
        var labels = <String, String>{};
        if (widget.formId != null) {
          try {
            final fields = await _repo.getFormFields(widget.formId!);
            labels = {for (final f in fields) f.key: f.label};
          } catch (_) {
            labels = {};
          }
        }
        // Si no hay periodo configurado, se asume "época 0" (todo cuenta).
        final resetAt = reset ?? DateTime.fromMillisecondsSinceEpoch(0).toUtc();
        final statuses = buildDynamicStatuses(users, subs, resetAt);
        if (!mounted) return;
        setState(() {
          _textSubs = subs;
          _fieldLabels = labels;
          _dynamicReset = reset;
          _dynamicStatuses = statuses;
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _snack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppColors.error : AppColors.success,
    ));
  }

  Future<void> _openFile(String storagePath) async {
    try {
      final url = await _repo.signedFileUrl(storagePath);
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _snack('No se pudo abrir el archivo.', error: true);
      }
    } catch (e) {
      _snack('No se pudo abrir el archivo: $e', error: true);
    }
  }

  // ============ Reset ============

  Future<void> _confirmReset({String? sectionKey, required String label}) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Reiniciar periodo',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        content: Text(
          'Se reiniciará el periodo de "$label". Los envíos anteriores no se '
          'borran, pero los usuarios podrán volver a enviar. ¿Continuar?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          AppButton(
            label: 'Cancelar',
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.pop(ctx, false),
          ),
          AppButton(
            label: 'Reiniciar',
            variant: AppButtonVariant.danger,
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await _repo.resetFormPeriod(
          formType: widget.formType, sectionKey: sectionKey);
      _snack('Periodo reiniciado.');
      _load();
    } catch (e) {
      _snack('No se pudo reiniciar: $e', error: true);
    }
  }

  Future<void> _resetDynamic() =>
      _confirmReset(sectionKey: null, label: widget.title);

  Future<void> _resetDocMenu() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text('¿Qué sección quieres reiniciar?',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
            ),
            for (final key in _docSectionOrder)
              ListTile(
                leading: const Icon(Icons.refresh,
                    color: AppColors.primaryAccent),
                title: Text(_docSectionLabels[key] ?? key,
                    style: const TextStyle(color: AppColors.textPrimary)),
                onTap: () => Navigator.pop(ctx, key),
              ),
            ListTile(
              leading:
                  const Icon(Icons.refresh, color: AppColors.secondaryAccent),
              title: const Text('Todas las secciones',
                  style: TextStyle(color: AppColors.secondaryAccent)),
              onTap: () => Navigator.pop(ctx, '__all__'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (choice == null) return;
    if (choice == '__all__') {
      await _confirmReset(sectionKey: null, label: 'todas las secciones');
    } else {
      await _confirmReset(
          sectionKey: choice, label: _docSectionLabels[choice] ?? choice);
    }
  }

  // ============ Ver respuestas / archivos ============

  void _showDynamicAnswers(User user, FormTextSubmission sub) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (ctx, scroll) => ListView(
            controller: scroll,
            padding: const EdgeInsets.all(20),
            children: [
              Text('${user.nombre} ${user.apellidos}'.trim(),
                  style: Theme.of(ctx)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppColors.primaryAccent)),
              if (sub.submittedAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('Enviado el ${formatDateTime(sub.submittedAt!)}',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ),
              const SizedBox(height: 16),
              if (sub.answers.isEmpty)
                const Text('// Sin respuestas.',
                    style: TextStyle(color: AppColors.textSecondary))
              else
                for (final entry in sub.answers.entries)
                  _AnswerTile(
                    label: _fieldLabels[entry.key] ?? entry.key,
                    value: entry.value,
                    onOpenFile: _openFile,
                  ),
            ],
          ),
        );
      },
    );
  }

  void _showDocFiles(User user, String sectionKey) {
    final files = _fileSubs
        .where((f) =>
            f.userAuthId == user.authId && f.sectionKey == sectionKey)
        .toList()
      ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    // Solo los del periodo actual.
    final reset = _resetBySection[sectionKey];
    final current = reset == null
        ? files
        : files.where((f) {
            final at = DateTime.tryParse(f.uploadedAt)?.toUtc();
            return at != null && isInCurrentPeriod(at, reset);
          }).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_docSectionLabels[sectionKey] ?? sectionKey} · '
                  '${user.nombre}'.trim(),
                  style: Theme.of(ctx)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppColors.primaryAccent)),
              const SizedBox(height: 12),
              if (current.isEmpty)
                const Text('// Sin archivos en el periodo actual.',
                    style: TextStyle(color: AppColors.textSecondary))
              else
                for (final f in current)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.insert_drive_file_outlined,
                        color: AppColors.success),
                    title: Text(f.fileName,
                        style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 13)),
                    trailing: const Icon(Icons.open_in_new,
                        color: AppColors.primaryAccent, size: 18),
                    onTap: () => _openFile(f.storagePath),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.title.toUpperCase(),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryAccent),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.restart_alt, color: AppColors.error),
          tooltip: 'Reiniciar periodo',
          onPressed: _loading
              ? null
              : (widget.isDocManagement ? _resetDocMenu : _resetDynamic),
        ),
      ],
      body: _error != null
          ? Center(
              child: Text('// $_error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error)))
          : _loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  color: AppColors.primaryAccent,
                  onRefresh: _load,
                  child: widget.isDocManagement
                      ? _buildDocBody()
                      : _buildDynamicBody(),
                ),
    );
  }

  Widget _buildDynamicBody() {
    final withAccount = _dynamicStatuses.where((s) => s.hasAccount).toList();
    final submitted = withAccount.where((s) => s.submitted).length;
    return ListView(
      children: [
        const SizedBox(height: 8),
        _CounterCard(
          submitted: submitted,
          total: withAccount.length,
          resetAt: _dynamicReset,
        ),
        const SizedBox(height: 12),
        for (final s in _dynamicStatuses)
          _UserRow(
            user: s.user,
            submittedAt: s.submittedAt,
            onTap: s.submitted
                ? () {
                    final sub = _latestTextSub(s.user);
                    if (sub != null) _showDynamicAnswers(s.user, sub);
                  }
                : null,
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  FormTextSubmission? _latestTextSub(User user) {
    FormTextSubmission? latest;
    for (final sub in _textSubs) {
      if (sub.userAuthId != user.authId) continue;
      final at = sub.submittedAt;
      if (at == null) continue;
      if (_dynamicReset != null && !isInCurrentPeriod(at, _dynamicReset!)) {
        continue;
      }
      if (latest == null ||
          (latest.submittedAt != null && at.isAfter(latest.submittedAt!))) {
        latest = sub;
      }
    }
    return latest;
  }

  Widget _buildDocBody() {
    final withAccount = _docStatuses.where((s) => s.hasAccount).toList();
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      children: [
        const SizedBox(height: 8),
        // Contador por sección.
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('RESUMEN POR SECCIÓN',
                  style: textTheme.titleLarge
                      ?.copyWith(color: AppColors.primaryAccent)),
              const SizedBox(height: 8),
              for (final key in _docSectionOrder)
                if (_resetBySection.containsKey(key))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(_docSectionLabels[key] ?? key,
                              style: textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textPrimary)),
                        ),
                        Text(
                          '${withAccount.where((s) => s.sectionSubmitted(key)).length}'
                          ' de ${withAccount.length}',
                          style: const TextStyle(
                              color: AppColors.secondaryAccent,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (final s in _docStatuses)
          _DocUserRow(
            status: s,
            onTapSection: (key) => _showDocFiles(s.user, key),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _CounterCard extends StatelessWidget {
  const _CounterCard({
    required this.submitted,
    required this.total,
    this.resetAt,
  });

  final int submitted;
  final int total;
  final DateTime? resetAt;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppCard(
      glow: true,
      child: Row(
        children: [
          const Icon(Icons.people_alt_outlined,
              color: AppColors.primaryAccent, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$submitted de $total han enviado',
                    style: textTheme.titleLarge
                        ?.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(
                  resetAt == null
                      ? 'Sin periodo configurado (frecuencia: ninguna).'
                      : 'Periodo desde ${formatDateTime(resetAt!)}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserRow extends StatelessWidget {
  const _UserRow({required this.user, this.submittedAt, this.onTap});

  final User user;
  final DateTime? submittedAt;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasAccount = user.authId.isNotEmpty;
    final submitted = submittedAt != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              submitted
                  ? Icons.check_circle
                  : (hasAccount
                      ? Icons.radio_button_unchecked
                      : Icons.person_off_outlined),
              color: submitted
                  ? AppColors.success
                  : (hasAccount
                      ? AppColors.textSecondary
                      : AppColors.warning),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${user.nombre} ${user.apellidos}'.trim(),
                      style: textTheme.bodyMedium
                          ?.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(
                    !hasAccount
                        ? 'Sin cuenta'
                        : submitted
                            ? 'Enviado el ${formatDateTime(submittedAt!)}'
                            : 'Pendiente',
                    style: TextStyle(
                      fontSize: 12,
                      color: !hasAccount
                          ? AppColors.warning
                          : submitted
                              ? AppColors.success
                              : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.chevron_right,
                  color: AppColors.primaryAccent, size: 20),
          ],
        ),
      ),
    );
  }
}

class _DocUserRow extends StatelessWidget {
  const _DocUserRow({required this.status, required this.onTapSection});

  final UserDocStatus status;
  final void Function(String sectionKey) onTapSection;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = status.user;
    final hasAccount = status.hasAccount;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('${user.nombre} ${user.apellidos}'.trim(),
                      style: textTheme.bodyMedium
                          ?.copyWith(color: AppColors.textPrimary)),
                ),
                if (!hasAccount)
                  const Text('Sin cuenta',
                      style:
                          TextStyle(color: AppColors.warning, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final key in _docSectionOrder)
                  if (status.sectionSubmittedAt.containsKey(key))
                    _SectionChip(
                      label: _docSectionLabels[key] ?? key,
                      submittedAt: status.sectionSubmittedAt[key],
                      onTap: status.sectionSubmitted(key)
                          ? () => onTapSection(key)
                          : null,
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionChip extends StatelessWidget {
  const _SectionChip({required this.label, this.submittedAt, this.onTap});

  final String label;
  final DateTime? submittedAt;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final submitted = submittedAt != null;
    final color = submitted ? AppColors.success : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(submitted ? Icons.check : Icons.remove,
                size: 14, color: color),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    color: color, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

/// Muestra una respuesta: texto plano o, si es una referencia a archivo
/// (`{file_name, storage_path}`), un botón para abrirlo.
class _AnswerTile extends StatelessWidget {
  const _AnswerTile({
    required this.label,
    required this.value,
    required this.onOpenFile,
  });

  final String label;
  final dynamic value;
  final void Function(String storagePath) onOpenFile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isFile = value is Map && (value as Map)['storage_path'] != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          if (isFile)
            OutlinedButton.icon(
              onPressed: () =>
                  onOpenFile((value as Map)['storage_path'].toString()),
              icon: const Icon(Icons.open_in_new, size: 16),
              label: Text(
                (value as Map)['file_name']?.toString() ?? 'Abrir archivo',
              ),
            )
          else
            Text(value?.toString() ?? '—',
                style: textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

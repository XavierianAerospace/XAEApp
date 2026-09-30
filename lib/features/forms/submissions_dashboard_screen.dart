import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/widgets.dart';
import '../../domain/entities/form_definition.dart';
import '../../domain/repositories/forms_repository.dart';
import 'form_submissions_screen.dart';
import 'forms_status.dart';

/// Dashboard (solo superuser): elige un formulario para ver quién lo ha enviado
/// en el periodo actual. Incluye la Gestión Documental además de los dinámicos.
class SubmissionsDashboardScreen extends StatefulWidget {
  const SubmissionsDashboardScreen({super.key});

  @override
  State<SubmissionsDashboardScreen> createState() =>
      _SubmissionsDashboardScreenState();
}

class _SubmissionsDashboardScreenState
    extends State<SubmissionsDashboardScreen> {
  final FormsRepository _repo = GetIt.I<FormsRepository>();

  List<FormDefinition>? _forms;
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
      if (!mounted) return;
      setState(() => _forms = forms);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  Future<void> _open({
    required String formType,
    required String title,
    required bool isDoc,
    int? formId,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FormSubmissionsScreen(
          formType: formType,
          title: title,
          isDocManagement: isDoc,
          formId: formId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppScaffold(
      title: 'SEGUIMIENTO DE ENVÍOS',
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryAccent),
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: RefreshIndicator(
        color: AppColors.primaryAccent,
        onRefresh: _load,
        child: ListView(
          children: [
            const SizedBox(height: 8),
            _DashCard(
              title: 'Sistema de Gestión Documental',
              subtitle: 'Estado por sección de cada usuario.',
              icon: Icons.folder_copy_outlined,
              onTap: () => _open(
                formType: kDocFormType,
                title: 'Gestión Documental',
                isDoc: true,
              ),
            ),
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
            else if (_forms!.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text('// Sin formularios dinámicos.',
                    textAlign: TextAlign.center, style: textTheme.labelMedium),
              )
            else
              for (final f in _forms!) ...[
                _DashCard(
                  title: f.title,
                  subtitle: 'Quién lo ha enviado en el periodo actual.',
                  icon: Icons.assignment_outlined,
                  onTap: () => _open(
                    formType: f.key,
                    title: f.title,
                    isDoc: false,
                    formId: f.id,
                  ),
                ),
                const SizedBox(height: 16),
              ],
          ],
        ),
      ),
    );
  }
}

class _DashCard extends StatelessWidget {
  const _DashCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

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
                Text(title,
                    style: textTheme.titleLarge
                        ?.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                Text(subtitle, style: textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.primaryAccent),
        ],
      ),
    );
  }
}

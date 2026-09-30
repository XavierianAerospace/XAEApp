import '../../domain/entities/form_file_submission.dart';
import '../../domain/entities/form_period.dart';
import '../../domain/entities/form_text_submission.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/forms_repository.dart';

/// Tipo de formulario fijo de Gestión Documental (coincide con las semillas de
/// `supabase/forms_tracking.sql` y con document_management_form_screen.dart).
const String kDocFormType = 'document_management';

/// Un envío pertenece al periodo actual si su fecha es `>= resetAt`.
/// Ambos instantes se comparan en UTC.
bool isInCurrentPeriod(DateTime submittedAt, DateTime resetAt) =>
    !submittedAt.toUtc().isBefore(resetAt.toUtc());

/// Estado de los formularios para el usuario actual (sus propios envíos), usado
/// para bloquear reenvíos y marcar "Enviado" en la lista.
class MyFormsStatus {
  final List<FormPeriod> periods;
  final List<FormTextSubmission> textSubs;
  final List<FormFileSubmission> fileSubs;

  const MyFormsStatus({
    required this.periods,
    required this.textSubs,
    required this.fileSubs,
  });

  DateTime? _resetFor(String formType, String sectionKey) {
    for (final p in periods) {
      if (p.formType == formType && p.sectionKey == sectionKey) return p.resetAt;
    }
    return null;
  }

  /// Fecha del último envío del formulario dinámico [formType] en el periodo
  /// actual, o null si no ha enviado (o el formulario no está rastreado).
  DateTime? dynamicSubmittedAt(String formType) {
    final reset = _resetFor(formType, '');
    if (reset == null) return null;
    DateTime? latest;
    for (final s in textSubs) {
      final at = s.submittedAt;
      if (s.formType == formType && at != null && isInCurrentPeriod(at, reset)) {
        if (latest == null || at.isAfter(latest)) latest = at;
      }
    }
    return latest;
  }

  bool isDynamicSubmitted(String formType) =>
      dynamicSubmittedAt(formType) != null;

  /// Fecha del último archivo enviado por el usuario en la sección [sectionKey]
  /// de Gestión Documental en el periodo actual, o null.
  DateTime? docSectionSubmittedAt(String sectionKey) {
    final reset = _resetFor(kDocFormType, sectionKey);
    if (reset == null) return null;
    DateTime? latest;
    for (final s in fileSubs) {
      if (s.formType == kDocFormType && s.sectionKey == sectionKey) {
        final at = DateTime.tryParse(s.uploadedAt)?.toUtc();
        if (at != null && isInCurrentPeriod(at, reset)) {
          if (latest == null || at.isAfter(latest)) latest = at;
        }
      }
    }
    return latest;
  }

  bool isDocSectionSubmitted(String sectionKey) =>
      docSectionSubmittedAt(sectionKey) != null;
}

/// Carga el estado propio del usuario (periodos + sus envíos de texto y archivos).
Future<MyFormsStatus> loadMyFormsStatus(FormsRepository repo) async {
  final periods = await repo.getFormPeriods();
  final textSubs = await repo.getMyTextSubmissions();
  final fileSubs = await repo.getMyFileSubmissions();
  return MyFormsStatus(
    periods: periods,
    textSubs: textSubs,
    fileSubs: fileSubs,
  );
}

/// Estado de un usuario frente a un formulario dinámico (dashboard superuser).
class UserSubmissionStatus {
  final User user;
  final DateTime? submittedAt;

  const UserSubmissionStatus({required this.user, this.submittedAt});

  /// Los usuarios sin cuenta de Auth no cuentan para "X de Y".
  bool get hasAccount => user.authId.isNotEmpty;
  bool get submitted => submittedAt != null;
}

/// Estado de un usuario frente a Gestión Documental (una fecha por sección).
class UserDocStatus {
  final User user;
  final Map<String, DateTime?> sectionSubmittedAt;

  const UserDocStatus({required this.user, required this.sectionSubmittedAt});

  bool get hasAccount => user.authId.isNotEmpty;
  bool sectionSubmitted(String sectionKey) =>
      sectionSubmittedAt[sectionKey] != null;
}

/// Cruza usuarios y envíos de texto (todos, no solo los míos) para el dashboard.
List<UserSubmissionStatus> buildDynamicStatuses(
  List<User> users,
  List<FormTextSubmission> subs,
  DateTime resetAt,
) {
  return users.map((u) {
    DateTime? latest;
    if (u.authId.isNotEmpty) {
      for (final s in subs) {
        final at = s.submittedAt;
        if (s.userAuthId == u.authId &&
            at != null &&
            isInCurrentPeriod(at, resetAt)) {
          if (latest == null || at.isAfter(latest)) latest = at;
        }
      }
    }
    return UserSubmissionStatus(user: u, submittedAt: latest);
  }).toList();
}

/// Cruza usuarios y archivos por sección para el dashboard de Gestión Documental.
/// [resetBySection] mapea cada sección a su `reset_at`.
List<UserDocStatus> buildDocStatuses(
  List<User> users,
  List<FormFileSubmission> files,
  Map<String, DateTime> resetBySection,
) {
  return users.map((u) {
    final perSection = <String, DateTime?>{};
    for (final entry in resetBySection.entries) {
      DateTime? latest;
      if (u.authId.isNotEmpty) {
        for (final s in files) {
          if (s.userAuthId == u.authId && s.sectionKey == entry.key) {
            final at = DateTime.tryParse(s.uploadedAt)?.toUtc();
            if (at != null && isInCurrentPeriod(at, entry.value)) {
              if (latest == null || at.isAfter(latest)) latest = at;
            }
          }
        }
      }
      perSection[entry.key] = latest;
    }
    return UserDocStatus(user: u, sectionSubmittedAt: perSection);
  }).toList();
}

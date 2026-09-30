import 'package:flutter_test/flutter_test.dart';
import 'package:xae_app/domain/entities/form_file_submission.dart';
import 'package:xae_app/domain/entities/form_period.dart';
import 'package:xae_app/domain/entities/form_text_submission.dart';
import 'package:xae_app/domain/entities/user.dart';
import 'package:xae_app/features/forms/forms_status.dart';

User _user({required int id, required String authId, String nombre = 'N'}) {
  return User(
    id: id,
    email: 'u$id@x.com',
    nombre: nombre,
    apellidos: 'A',
    fechaUnion: '',
    rango: '',
    tareasCompletadas: 0,
    tareasCreadas: 0,
    horasTrabajadas: 0,
    subsistemas: const [],
    liderSubsistema: '',
    tareasCompletadasPorSubsistema: const {},
    authId: authId,
  );
}

FormTextSubmission _text({
  required String uid,
  required String type,
  required DateTime at,
}) {
  return FormTextSubmission(
    id: 0,
    userAuthId: uid,
    formType: type,
    answers: const {},
    submittedAt: at,
  );
}

FormFileSubmission _file({
  required String uid,
  required String section,
  required DateTime at,
}) {
  return FormFileSubmission(
    id: 0,
    userAuthId: uid,
    formType: kDocFormType,
    sectionKey: section,
    fileName: 'f.docx',
    storagePath: 'p/f.docx',
    uploadedAt: at.toUtc().toIso8601String(),
  );
}

void main() {
  final reset = DateTime.utc(2026, 3, 1, 5);

  group('isInCurrentPeriod', () {
    test('fecha posterior al reset cuenta', () {
      expect(isInCurrentPeriod(reset.add(const Duration(days: 1)), reset),
          isTrue);
    });
    test('fecha igual al reset cuenta (>=)', () {
      expect(isInCurrentPeriod(reset, reset), isTrue);
    });
    test('fecha anterior al reset no cuenta', () {
      expect(isInCurrentPeriod(reset.subtract(const Duration(seconds: 1)), reset),
          isFalse);
    });
    test('compara en UTC aunque venga en local', () {
      final localAfter = reset.add(const Duration(hours: 1)).toLocal();
      expect(isInCurrentPeriod(localAfter, reset), isTrue);
    });
  });

  group('MyFormsStatus (dinámico)', () {
    final periods = [
      FormPeriod(
          formType: 'reporte',
          sectionKey: '',
          frecuencia: 'semanal',
          resetAt: reset),
    ];

    test('marca enviado con la fecha del envío en el periodo', () {
      final at = reset.add(const Duration(hours: 2));
      final status = MyFormsStatus(
        periods: periods,
        textSubs: [_text(uid: 'me', type: 'reporte', at: at)],
        fileSubs: const [],
      );
      expect(status.isDynamicSubmitted('reporte'), isTrue);
      expect(status.dynamicSubmittedAt('reporte'), at);
    });

    test('ignora envíos anteriores al reset', () {
      final status = MyFormsStatus(
        periods: periods,
        textSubs: [
          _text(
              uid: 'me',
              type: 'reporte',
              at: reset.subtract(const Duration(days: 1))),
        ],
        fileSubs: const [],
      );
      expect(status.isDynamicSubmitted('reporte'), isFalse);
    });

    test('sin periodo configurado devuelve no enviado', () {
      final status = MyFormsStatus(
          periods: const [], textSubs: const [], fileSubs: const []);
      expect(status.isDynamicSubmitted('reporte'), isFalse);
    });
  });

  group('MyFormsStatus (Gestión Documental)', () {
    final periods = [
      FormPeriod(
          formType: kDocFormType,
          sectionKey: 'lider_proyecto',
          frecuencia: 'semanal',
          resetAt: reset),
    ];

    test('sección enviada en el periodo', () {
      final at = reset.add(const Duration(hours: 5));
      final status = MyFormsStatus(
        periods: periods,
        textSubs: const [],
        fileSubs: [_file(uid: 'me', section: 'lider_proyecto', at: at)],
      );
      expect(status.isDocSectionSubmitted('lider_proyecto'), isTrue);
      expect(status.docSectionSubmittedAt('lider_proyecto'), at);
    });

    test('otra sección sigue pendiente', () {
      final status = MyFormsStatus(
        periods: periods,
        textSubs: const [],
        fileSubs: [
          _file(
              uid: 'me',
              section: 'lider_proyecto',
              at: reset.add(const Duration(hours: 1)))
        ],
      );
      expect(status.isDocSectionSubmitted('individual'), isFalse);
    });
  });

  group('buildDynamicStatuses', () {
    test('enviado vs pendiente y exclusión de sin cuenta', () {
      final users = [
        _user(id: 1, authId: 'a'),
        _user(id: 2, authId: 'b'),
        _user(id: 3, authId: ''), // sin cuenta
      ];
      final subs = [
        _text(uid: 'a', type: 'reporte', at: reset.add(const Duration(hours: 1)))
      ];
      final statuses = buildDynamicStatuses(users, subs, reset);
      final byId = {for (final s in statuses) s.user.id: s};

      expect(byId[1]!.submitted, isTrue);
      expect(byId[1]!.hasAccount, isTrue);
      expect(byId[2]!.submitted, isFalse);
      expect(byId[3]!.hasAccount, isFalse);

      final withAccount = statuses.where((s) => s.hasAccount).length;
      final submitted =
          statuses.where((s) => s.hasAccount && s.submitted).length;
      expect(withAccount, 2);
      expect(submitted, 1);
    });
  });

  group('buildDocStatuses', () {
    test('estado por sección para cada usuario', () {
      final users = [
        _user(id: 1, authId: 'a'),
        _user(id: 2, authId: ''),
      ];
      final files = [
        _file(
            uid: 'a',
            section: 'individual',
            at: reset.add(const Duration(hours: 2))),
      ];
      final statuses = buildDocStatuses(
        users,
        files,
        {'individual': reset, 'presidencia': reset},
      );
      final byId = {for (final s in statuses) s.user.id: s};

      expect(byId[1]!.sectionSubmitted('individual'), isTrue);
      expect(byId[1]!.sectionSubmitted('presidencia'), isFalse);
      expect(byId[2]!.hasAccount, isFalse);
      expect(byId[2]!.sectionSubmitted('individual'), isFalse);
    });
  });
}

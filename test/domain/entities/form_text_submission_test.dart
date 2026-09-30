import 'package:flutter_test/flutter_test.dart';
import 'package:xae_app/domain/entities/form_text_submission.dart';

void main() {
  group('FormTextSubmission.fromJson', () {
    test('parsea id, usuario, tipo, respuestas y fecha en UTC', () {
      final s = FormTextSubmission.fromJson({
        'id': 7,
        'user_auth_id': 'uid-1',
        'form_type': 'reporte',
        'answers': {'p1': 'hola', 'p2': 3},
        'submitted_at': '2026-02-10T12:30:00+00:00',
      });
      expect(s.id, 7);
      expect(s.userAuthId, 'uid-1');
      expect(s.formType, 'reporte');
      expect(s.answers['p1'], 'hola');
      expect(s.answers['p2'], 3);
      expect(s.submittedAt, DateTime.utc(2026, 2, 10, 12, 30));
      expect(s.submittedAt!.isUtc, isTrue);
    });

    test('id como string y answers null se manejan con defaults', () {
      final s = FormTextSubmission.fromJson({
        'id': '12',
        'answers': null,
      });
      expect(s.id, 12);
      expect(s.userAuthId, '');
      expect(s.answers, isEmpty);
      expect(s.submittedAt, isNull);
    });
  });
}

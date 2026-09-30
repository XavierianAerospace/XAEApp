import 'package:flutter_test/flutter_test.dart';
import 'package:xae_app/domain/entities/form_period.dart';

void main() {
  group('FormPeriod.fromJson', () {
    test('parsea todos los campos y normaliza reset_at a UTC', () {
      final p = FormPeriod.fromJson({
        'form_type': 'document_management',
        'section_key': 'lider_proyecto',
        'frecuencia': 'semanal',
        'reset_at': '2026-01-05T05:00:00+00:00',
      });
      expect(p.formType, 'document_management');
      expect(p.sectionKey, 'lider_proyecto');
      expect(p.frecuencia, 'semanal');
      expect(p.resetAt.isUtc, isTrue);
      expect(p.resetAt, DateTime.utc(2026, 1, 5, 5));
    });

    test('usa valores por defecto cuando faltan campos', () {
      final p = FormPeriod.fromJson({});
      expect(p.formType, '');
      expect(p.sectionKey, '');
      expect(p.frecuencia, 'ninguna');
      expect(p.resetAt, DateTime.fromMillisecondsSinceEpoch(0, isUtc: true));
    });

    test('reset_at inválido cae al epoch UTC', () {
      final p = FormPeriod.fromJson({'reset_at': 'no-es-fecha'});
      expect(p.resetAt, DateTime.fromMillisecondsSinceEpoch(0, isUtc: true));
    });
  });
}

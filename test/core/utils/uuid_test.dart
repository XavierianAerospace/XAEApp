import 'package:flutter_test/flutter_test.dart';
import 'package:xae_app/core/utils/uuid.dart';

void main() {
  group('generateUuidV4', () {
    final re = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');

    test('tiene el formato 8-4-4-4-12, versión 4 y variante RFC 4122', () {
      for (var i = 0; i < 200; i++) {
        expect(re.hasMatch(generateUuidV4()), isTrue,
            reason: 'UUID inválido en la iteración $i');
      }
    });

    test('genera identificadores distintos', () {
      final set = <String>{};
      for (var i = 0; i < 1000; i++) {
        set.add(generateUuidV4());
      }
      expect(set.length, 1000);
    });
  });
}

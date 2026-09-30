import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xae_app/data/api_service.dart';
import 'package:xae_app/data/repositories/forms_repository_impl.dart';
import 'package:xae_app/domain/repositories/forms_repository.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService api;
  late FormsRepositoryImpl repo;

  setUp(() {
    api = MockApiService();
    repo = FormsRepositoryImpl(api);
  });

  group('submitFileBatch', () {
    final files = [
      FileToUpload(fileName: 'a.docx', bytes: Uint8List.fromList([1, 2])),
      FileToUpload(fileName: 'b.docx', bytes: Uint8List.fromList([3, 4])),
    ];

    test('sube archivos y registra las filas atómicamente', () async {
      when(() => api.currentAuthEmail()).thenReturn('user@x.com');
      when(() => api.uploadFormFile(any(), any()))
          .thenAnswer((i) async => i.positionalArguments[0] as String);
      when(() => api.createFormFileSubmissions(any())).thenAnswer((_) async => [
            {
              'id': 1,
              'form_type': 'document_management',
              'section_key': 'lider_proyecto',
              'file_name': 'a.docx',
              'storage_path': 'p/a',
              'envio_id': 'env-1',
            },
          ]);

      final result = await repo.submitFileBatch(
        formType: 'document_management',
        sectionKey: 'lider_proyecto',
        envioId: 'env-1',
        files: files,
      );

      expect(result, hasLength(1));
      verify(() => api.uploadFormFile(any(), any())).called(2);
      verifyNever(() => api.removeFormFiles(any()));

      final captured =
          verify(() => api.createFormFileSubmissions(captureAny())).captured;
      final rows = captured.single as List<Map<String, dynamic>>;
      expect(rows, hasLength(2));
      expect(rows.every((r) => r['envio_id'] == 'env-1'), isTrue);
    });

    test('limpia los archivos subidos y relanza si el registro falla', () async {
      when(() => api.currentAuthEmail()).thenReturn('user@x.com');
      when(() => api.uploadFormFile(any(), any()))
          .thenAnswer((i) async => i.positionalArguments[0] as String);
      when(() => api.createFormFileSubmissions(any()))
          .thenThrow(const FormAlreadySubmittedException('ya enviado'));
      when(() => api.removeFormFiles(any())).thenAnswer((_) async {});

      await expectLater(
        repo.submitFileBatch(
          formType: 'document_management',
          sectionKey: 'lider_proyecto',
          envioId: 'env-1',
          files: files,
        ),
        throwsA(isA<FormAlreadySubmittedException>()),
      );

      final captured =
          verify(() => api.removeFormFiles(captureAny())).captured;
      final removed = captured.single as List<String>;
      expect(removed, hasLength(2)); // se subieron 2 antes de fallar
    });

    test('lanza si no hay sesión activa', () async {
      when(() => api.currentAuthEmail()).thenReturn(null);
      await expectLater(
        repo.submitFileBatch(
          formType: 'document_management',
          sectionKey: 'lider_proyecto',
          envioId: 'env-1',
          files: files,
        ),
        throwsA(isA<StateError>()),
      );
      verifyNever(() => api.uploadFormFile(any(), any()));
    });
  });

  group('getFormFrequency', () {
    test('devuelve la frecuencia del periodo (formType, "")', () async {
      when(() => api.getFormPeriods()).thenAnswer((_) async => [
            {
              'form_type': 'reporte',
              'section_key': '',
              'frecuencia': 'mensual',
              'reset_at': '2026-01-01T00:00:00Z',
            },
          ]);
      expect(await repo.getFormFrequency('reporte'), 'mensual');
    });

    test('default "ninguna" si no hay periodo', () async {
      when(() => api.getFormPeriods()).thenAnswer((_) async => []);
      expect(await repo.getFormFrequency('reporte'), 'ninguna');
    });
  });
}

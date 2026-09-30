import 'dart:typed_data';

import '../../domain/entities/form_definition.dart';
import '../../domain/entities/form_field_def.dart';
import '../../domain/entities/form_file_submission.dart';
import '../../domain/entities/form_period.dart';
import '../../domain/entities/form_text_submission.dart';
import '../../domain/repositories/forms_repository.dart';
import '../api_service.dart';

class FormsRepositoryImpl implements FormsRepository {
  final ApiService _apiService;

  FormsRepositoryImpl(this._apiService);

  @override
  Future<List<FormFileSubmission>> submitFileBatch({
    required String formType,
    required String sectionKey,
    required String envioId,
    required List<FileToUpload> files,
  }) async {
    final email = _apiService.currentAuthEmail();
    if (email == null) {
      throw StateError('No hay sesión activa para subir archivos');
    }

    // Ruta: {email}/{form_type}/{section_key}/{timestamp}_{i}_{file_name}
    // El prefijo con el email identifica de forma legible la carpeta de cada
    // usuario; las políticas de Storage lo validan contra el email del JWT.
    final uploadedPaths = <String>[];
    try {
      final rows = <Map<String, dynamic>>[];
      for (var i = 0; i < files.length; i++) {
        final f = files[i];
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final safeName = f.fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
        final storagePath =
            '$email/$formType/$sectionKey/${timestamp}_${i}_$safeName';
        await _apiService.uploadFormFile(storagePath, f.bytes);
        uploadedPaths.add(storagePath);
        rows.add({
          'form_type': formType,
          'section_key': sectionKey,
          'file_name': f.fileName,
          'storage_path': storagePath,
          'envio_id': envioId,
        });
      }
      // Inserción atómica: si el trigger rechaza el envío, no queda fila parcial.
      final result = await _apiService.createFormFileSubmissions(rows);
      return result.map((json) => FormFileSubmission.fromJson(json)).toList();
    } catch (e) {
      // Limpieza best-effort de los archivos ya subidos si el registro falla.
      await _apiService.removeFormFiles(uploadedPaths);
      rethrow;
    }
  }

  @override
  Future<List<FormFileSubmission>> getSubmissions(String formType) async {
    final result = await _apiService.getFormFileSubmissions(formType);
    return result.map((json) => FormFileSubmission.fromJson(json)).toList();
  }

  @override
  Future<void> submitText({
    required String formType,
    required Map<String, dynamic> answers,
  }) async {
    await _apiService.createFormTextSubmission({
      'form_type': formType,
      'answers': answers,
    });
  }

  @override
  Future<Map<String, String>> uploadFieldFile({
    required String formKey,
    required String fieldKey,
    required String fileName,
    required Uint8List bytes,
  }) async {
    final email = _apiService.currentAuthEmail() ?? 'anon';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final safeName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final storagePath = '$email/$formKey/$fieldKey/${timestamp}_$safeName';
    await _apiService.uploadFormFile(storagePath, bytes);
    return {'file_name': fileName, 'storage_path': storagePath};
  }

  @override
  Future<String> signedFileUrl(String storagePath) =>
      _apiService.createSignedFormFileUrl(storagePath);

  @override
  Future<void> removeFiles(List<String> storagePaths) =>
      _apiService.removeFormFiles(storagePaths);

  // ============ Periodos y estado de envíos ============

  @override
  Future<List<FormPeriod>> getFormPeriods() async {
    final result = await _apiService.getFormPeriods();
    return result.map((json) => FormPeriod.fromJson(json)).toList();
  }

  @override
  Future<String> getFormFrequency(String formType) async {
    final periods = await getFormPeriods();
    for (final p in periods) {
      if (p.formType == formType && p.sectionKey.isEmpty) return p.frecuencia;
    }
    return 'ninguna';
  }

  @override
  Future<void> setFormFrequency({
    required String formType,
    String sectionKey = '',
    required String frecuencia,
  }) {
    return _apiService.upsertFormPeriod({
      'form_type': formType,
      'section_key': sectionKey,
      'frecuencia': frecuencia,
    });
  }

  @override
  Future<void> resetFormPeriod({
    required String formType,
    String? sectionKey,
  }) {
    return _apiService.resetFormPeriod(formType, sectionKey);
  }

  @override
  Future<List<FormTextSubmission>> getTextSubmissions(String formType) async {
    final result = await _apiService.getFormTextSubmissions(formType);
    return result.map((json) => FormTextSubmission.fromJson(json)).toList();
  }

  @override
  Future<List<FormTextSubmission>> getMyTextSubmissions() async {
    final result = await _apiService.getMyFormTextSubmissions();
    return result.map((json) => FormTextSubmission.fromJson(json)).toList();
  }

  @override
  Future<List<FormFileSubmission>> getMyFileSubmissions() async {
    final result = await _apiService.getMyFormFileSubmissions();
    return result.map((json) => FormFileSubmission.fromJson(json)).toList();
  }

  // ============ Definiciones (formularios modulares) ============

  @override
  Future<List<FormDefinition>> getForms() async {
    final result = await _apiService.getForms();
    return result.map((json) => FormDefinition.fromJson(json)).toList();
  }

  @override
  Future<List<FormFieldDef>> getFormFields(int formId) async {
    final result = await _apiService.getFormFields(formId);
    return result.map((json) => FormFieldDef.fromJson(json)).toList();
  }

  @override
  Future<FormDefinition> createForm(FormDefinition form) async {
    final result = await _apiService.createForm(form.toPayload());
    return FormDefinition.fromJson(result);
  }

  @override
  Future<FormDefinition> updateForm(int id, Map<String, dynamic> data) async {
    final result = await _apiService.updateForm(id, data);
    return FormDefinition.fromJson(result);
  }

  @override
  Future<void> deleteForm(int id) => _apiService.deleteForm(id);

  @override
  Future<FormFieldDef> createField(FormFieldDef field) async {
    final result = await _apiService.createField(field.toPayload());
    return FormFieldDef.fromJson(result);
  }

  @override
  Future<FormFieldDef> updateField(int id, Map<String, dynamic> data) async {
    final result = await _apiService.updateField(id, data);
    return FormFieldDef.fromJson(result);
  }

  @override
  Future<void> deleteField(int id) => _apiService.deleteField(id);
}

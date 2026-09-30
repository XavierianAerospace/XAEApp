import 'dart:typed_data';

import '../entities/form_definition.dart';
import '../entities/form_field_def.dart';
import '../entities/form_file_submission.dart';
import '../entities/form_period.dart';
import '../entities/form_text_submission.dart';

/// Se lanza cuando la BD rechaza un envío porque el usuario ya envió ese
/// formulario/sección en el periodo actual. Su [message] es apto para mostrar.
class FormAlreadySubmittedException implements Exception {
  final String message;
  const FormAlreadySubmittedException(this.message);

  @override
  String toString() => message;
}

/// Un archivo listo para subir dentro de un envío por lotes.
class FileToUpload {
  final String fileName;
  final Uint8List bytes;
  const FileToUpload({required this.fileName, required this.bytes});
}

abstract class FormsRepository {
  /// Sube todos los archivos de una sección y los registra en una sola
  /// operación atómica compartiendo [envioId]. Si el registro falla (p. ej. el
  /// trigger detecta reenvío), borra los archivos subidos y relanza el error.
  Future<List<FormFileSubmission>> submitFileBatch({
    required String formType,
    required String sectionKey,
    required String envioId,
    required List<FileToUpload> files,
  });

  /// Lista los archivos de un formulario (alcance según RLS: propios o todos).
  Future<List<FormFileSubmission>> getSubmissions(String formType);

  /// Registra las respuestas de un formulario de texto, referenciadas al
  /// usuario autenticado. `answers` es un mapa pregunta → respuesta.
  Future<void> submitText({
    required String formType,
    required Map<String, dynamic> answers,
  });

  /// Sube un archivo (campo de tipo `archivo` en un formulario modular) y
  /// devuelve la referencia `{file_name, storage_path}` para guardarla en las
  /// respuestas.
  Future<Map<String, String>> uploadFieldFile({
    required String formKey,
    required String fieldKey,
    required String fileName,
    required Uint8List bytes,
  });

  /// Genera una URL firmada temporal para ver/descargar un archivo por su path.
  Future<String> signedFileUrl(String storagePath);

  /// Borra archivos del storage (limpieza best-effort de huérfanos).
  Future<void> removeFiles(List<String> storagePaths);

  // ============ Periodos y estado de envíos ============

  /// Lista todos los periodos configurados.
  Future<List<FormPeriod>> getFormPeriods();

  /// Frecuencia del formulario dinámico [formType] (default 'ninguna').
  Future<String> getFormFrequency(String formType);

  /// Crea/actualiza la frecuencia de un periodo (formulario o sección).
  Future<void> setFormFrequency({
    required String formType,
    String sectionKey,
    required String frecuencia,
  });

  /// Resetea el periodo de un formulario. [sectionKey] null = todas las secciones.
  Future<void> resetFormPeriod({
    required String formType,
    String? sectionKey,
  });

  /// Envíos de texto de un formulario (dashboard; alcance por RLS).
  Future<List<FormTextSubmission>> getTextSubmissions(String formType);

  /// Envíos de texto del usuario autenticado (estado propio).
  Future<List<FormTextSubmission>> getMyTextSubmissions();

  /// Envíos de archivos del usuario autenticado (estado propio).
  Future<List<FormFileSubmission>> getMyFileSubmissions();

  // ============ Definiciones (formularios modulares) ============

  Future<List<FormDefinition>> getForms();
  Future<List<FormFieldDef>> getFormFields(int formId);
  Future<FormDefinition> createForm(FormDefinition form);
  Future<FormDefinition> updateForm(int id, Map<String, dynamic> data);
  Future<void> deleteForm(int id);
  Future<FormFieldDef> createField(FormFieldDef field);
  Future<FormFieldDef> updateField(int id, Map<String, dynamic> data);
  Future<void> deleteField(int id);
}

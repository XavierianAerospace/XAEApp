import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/uuid.dart';
import '../../../domain/repositories/forms_repository.dart';
import '../forms_status.dart';
import 'forms_event.dart';
import 'forms_state.dart';

class FormsBloc extends Bloc<FormsEvent, FormsState> {
  final FormsRepository formsRepository;

  FormsBloc({required this.formsRepository}) : super(const FormsInitial()) {
    on<SubmitFormFilesRequested>(_onSubmitFormFilesRequested);
    on<SubmitFormTextRequested>(_onSubmitFormTextRequested);
    on<SubmitDynamicFormRequested>(_onSubmitDynamicFormRequested);
  }

  Future<void> _onSubmitDynamicFormRequested(
    SubmitDynamicFormRequested event,
    Emitter<FormsState> emit,
  ) async {
    emit(const FormsUploading());
    final uploadedPaths = <String>[];
    try {
      // Verifica el estado ANTES de subir para no dejar archivos huérfanos.
      final status = await loadMyFormsStatus(formsRepository);
      if (status.isDynamicSubmitted(event.formKey)) {
        emit(const FormsError(
            message: 'Ya enviaste este formulario en el periodo actual.'));
        return;
      }

      final answers = Map<String, dynamic>.from(event.answers);
      for (final f in event.files) {
        final ref = await formsRepository.uploadFieldFile(
          formKey: event.formKey,
          fieldKey: f.fieldKey,
          fileName: f.fileName,
          bytes: f.bytes,
        );
        final path = ref['storage_path'];
        if (path != null) uploadedPaths.add(path);
        answers[f.fieldKey] = ref;
      }
      await formsRepository.submitText(
        formType: event.formKey,
        answers: answers,
      );
      emit(const FormsSuccess(message: 'Formulario enviado correctamente.'));
    } on FormAlreadySubmittedException catch (e) {
      await formsRepository.removeFiles(uploadedPaths);
      emit(FormsError(message: e.message));
    } catch (e) {
      await formsRepository.removeFiles(uploadedPaths);
      emit(FormsError(message: 'Error al enviar el formulario: ${e.toString()}'));
    }
  }

  Future<void> _onSubmitFormFilesRequested(
    SubmitFormFilesRequested event,
    Emitter<FormsState> emit,
  ) async {
    if (event.files.isEmpty) {
      emit(const FormsError(message: 'No hay archivos seleccionados'));
      return;
    }

    emit(const FormsUploading());

    try {
      final status = await loadMyFormsStatus(formsRepository);

      // Agrupa los archivos por sección; cada sección es un envío (envio_id).
      final bySection = <String, List<FileToUpload>>{};
      for (final f in event.files) {
        bySection
            .putIfAbsent(f.sectionKey, () => <FileToUpload>[])
            .add(FileToUpload(fileName: f.fileName, bytes: f.bytes));
      }

      var uploaded = 0;
      var skipped = 0;
      for (final entry in bySection.entries) {
        if (status.isDocSectionSubmitted(entry.key)) {
          skipped++;
          continue;
        }
        await formsRepository.submitFileBatch(
          formType: event.formType,
          sectionKey: entry.key,
          envioId: generateUuidV4(),
          files: entry.value,
        );
        uploaded += entry.value.length;
      }

      if (uploaded == 0) {
        emit(const FormsError(
            message: 'Esas secciones ya fueron enviadas en el periodo actual.'));
        return;
      }
      final note = skipped > 0
          ? ' ($skipped sección(es) ya enviada(s) se omitieron).'
          : '';
      emit(FormsSuccess(message: 'Se subieron $uploaded archivo(s).$note'));
    } on FormAlreadySubmittedException catch (e) {
      emit(FormsError(message: e.message));
    } catch (e) {
      emit(FormsError(message: 'Error al subir archivos: ${e.toString()}'));
    }
  }

  Future<void> _onSubmitFormTextRequested(
    SubmitFormTextRequested event,
    Emitter<FormsState> emit,
  ) async {
    emit(const FormsUploading());

    try {
      await formsRepository.submitText(
        formType: event.formType,
        answers: event.answers,
      );
      emit(const FormsSuccess(message: 'Reporte enviado correctamente.'));
    } on FormAlreadySubmittedException catch (e) {
      emit(FormsError(message: e.message));
    } catch (e) {
      emit(FormsError(message: 'Error al enviar el reporte: ${e.toString()}'));
    }
  }
}

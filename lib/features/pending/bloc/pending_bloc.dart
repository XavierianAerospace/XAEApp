import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api_service.dart';
import 'pending_event.dart';
import 'pending_state.dart';

class PendingBloc extends Bloc<PendingEvent, PendingState> {
  final ApiService apiService;

  PendingBloc({required this.apiService}) : super(const PendingInitial()) {
    on<LoadPendingRequested>(_onLoadPendingRequested);
    on<CreateTaskRequested>(_onCreateTaskRequested);
    on<DeleteTaskRequested>(_onDeleteTaskRequested);
  }

  Future<void> _onLoadPendingRequested(
    LoadPendingRequested event,
    Emitter<PendingState> emit,
  ) async {
    emit(const PendingLoading());

    try {
      final tasks = await apiService.getTasks();

      final Map<String, List<Map<String, dynamic>>> organized = {};
      for (final task in tasks) {
        final subsistema = task['subsistema'] as String;
        organized.putIfAbsent(subsistema, () => []);
        organized[subsistema]!.add(task);
      }

      emit(PendingLoaded(tasksBySubsistema: organized));
    } catch (e) {
      emit(PendingError(message: 'Error cargando pendientes: ${e.toString()}'));
    }
  }

  Future<void> _onCreateTaskRequested(
    CreateTaskRequested event,
    Emitter<PendingState> emit,
  ) async {
    try {
      await apiService.createTask(event.task);
    } catch (e) {
      emit(PendingError(message: 'Error creando tarea: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteTaskRequested(
    DeleteTaskRequested event,
    Emitter<PendingState> emit,
  ) async {
    try {
      await apiService.deleteTask(event.taskId);
    } catch (e) {
      emit(PendingError(message: 'Error eliminando tarea: ${e.toString()}'));
    }
  }
}

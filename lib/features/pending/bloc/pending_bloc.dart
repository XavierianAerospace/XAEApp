import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/repositories/task_repository.dart';
import 'pending_event.dart';
import 'pending_state.dart';

class PendingBloc extends Bloc<PendingEvent, PendingState> {
  final TaskRepository taskRepository;

  PendingBloc({required this.taskRepository}) : super(const PendingInitial()) {
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
      final tasks = await taskRepository.getTasks();

      final Map<String, List<Task>> organized = {};
      for (final task in tasks) {
        organized.putIfAbsent(task.subsistema, () => []);
        organized[task.subsistema]!.add(task);
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
      await taskRepository.createTask(event.task);
    } catch (e) {
      emit(PendingError(message: 'Error creando tarea: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteTaskRequested(
    DeleteTaskRequested event,
    Emitter<PendingState> emit,
  ) async {
    try {
      await taskRepository.deleteTask(event.taskId);
    } catch (e) {
      emit(PendingError(message: 'Error eliminando tarea: ${e.toString()}'));
    }
  }
}

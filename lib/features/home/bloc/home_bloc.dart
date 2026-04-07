import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TaskRepository taskRepository;
  final UserRepository userRepository;

  HomeBloc({
    required this.taskRepository,
    required this.userRepository,
  }) : super(const HomeInitial()) {
    on<LoadHomeDataRequested>(_onLoadHomeDataRequested);
  }

  Future<void> _onLoadHomeDataRequested(
    LoadHomeDataRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    try {
      final tasks = await taskRepository.getTasks();
      final members = await userRepository.getMembers();

      final activeMembers = members.where((m) => m.activo).toList();

      emit(HomeLoaded(tasks: tasks, activeMembers: activeMembers));
    } catch (e) {
      emit(HomeError(message: 'Error cargando home: ${e.toString()}'));
    }
  }
}

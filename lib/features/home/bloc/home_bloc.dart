import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiService apiService;

  HomeBloc({required this.apiService}) : super(const HomeInitial()) {
    on<LoadHomeDataRequested>(_onLoadHomeDataRequested);
  }

  Future<void> _onLoadHomeDataRequested(
    LoadHomeDataRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    try {
      final tasks = await apiService.getTasks();
      final members = await apiService.getMembers();

      final activeMembers = members
          .where((m) => m['activo'] == true)
          .map<String>((m) => m['nombre'] as String)
          .toList();

      emit(HomeLoaded(tasks: tasks, activeMembers: activeMembers));
    } catch (e) {
      emit(HomeError(message: 'Error cargando home: ${e.toString()}'));
    }
  }
}

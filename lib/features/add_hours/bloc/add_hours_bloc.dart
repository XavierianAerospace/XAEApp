import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api_service.dart';
import 'add_hours_event.dart';
import 'add_hours_state.dart';

class AddHoursBloc extends Bloc<AddHoursEvent, AddHoursState> {
  final ApiService apiService;

  AddHoursBloc({required this.apiService}) : super(const AddHoursInitial()) {
    on<AddHoursRequested>(_onAddHoursRequested);
  }

  Future<void> _onAddHoursRequested(
    AddHoursRequested event,
    Emitter<AddHoursState> emit,
  ) async {
    emit(const AddHoursLoading());

    try {
      // Por ahora solo emite success
      // En el futuro se conectaría a un endpoint real
      emit(const AddHoursSuccess());
    } catch (e) {
      emit(AddHoursError(message: 'Error agregando horas: ${e.toString()}'));
    }
  }
}

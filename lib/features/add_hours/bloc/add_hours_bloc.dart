import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_hours_event.dart';
import 'add_hours_state.dart';

class AddHoursBloc extends Bloc<AddHoursEvent, AddHoursState> {
  AddHoursBloc() : super(const AddHoursInitial()) {
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

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api_service.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final ApiService apiService;

  MenuBloc({required this.apiService}) : super(const MenuInitial()) {
    on<MenuInitRequested>(_onMenuInitRequested);
  }

  Future<void> _onMenuInitRequested(
    MenuInitRequested event,
    Emitter<MenuState> emit,
  ) async {
    emit(const MenuLoaded());
  }
}

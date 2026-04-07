import 'package:flutter_bloc/flutter_bloc.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(const MenuInitial()) {
    on<MenuInitRequested>(_onMenuInitRequested);
  }

  Future<void> _onMenuInitRequested(
    MenuInitRequested event,
    Emitter<MenuState> emit,
  ) async {
    emit(const MenuLoaded());
  }
}

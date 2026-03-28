import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api_service.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final ApiService apiService;

  InventoryBloc({required this.apiService}) : super(const InventoryInitial()) {
    on<LoadInventoryRequested>(_onLoadInventoryRequested);
  }

  Future<void> _onLoadInventoryRequested(
    LoadInventoryRequested event,
    Emitter<InventoryState> emit,
  ) async {
    emit(const InventoryLoading());

    try {
      final items = await apiService.getItems();
      final registered = await apiService.getRegisteredItems();

      emit(InventoryLoaded(scannedItems: items, registeredItems: registered));
    } catch (e) {
      emit(InventoryError(
          message: 'Error cargando inventario: ${e.toString()}'));
    }
  }
}

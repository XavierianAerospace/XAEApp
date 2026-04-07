import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/inventory_repository.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryRepository inventoryRepository;

  InventoryBloc({required this.inventoryRepository})
      : super(const InventoryInitial()) {
    on<LoadInventoryRequested>(_onLoadInventoryRequested);
  }

  Future<void> _onLoadInventoryRequested(
    LoadInventoryRequested event,
    Emitter<InventoryState> emit,
  ) async {
    emit(const InventoryLoading());

    try {
      final items = await inventoryRepository.getItems();
      final registered = await inventoryRepository.getRegisteredItems();

      emit(InventoryLoaded(scannedItems: items, registeredItems: registered));
    } catch (e) {
      emit(InventoryError(
          message: 'Error cargando inventario: ${e.toString()}'));
    }
  }
}

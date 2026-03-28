import 'package:equatable/equatable.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object?> get props => [];
}

class InventoryInitial extends InventoryState {
  const InventoryInitial();
}

class InventoryLoading extends InventoryState {
  const InventoryLoading();
}

class InventoryLoaded extends InventoryState {
  final List<Map<String, dynamic>> scannedItems;
  final List<Map<String, dynamic>> registeredItems;

  const InventoryLoaded({
    required this.scannedItems,
    required this.registeredItems,
  });

  @override
  List<Object?> get props => [scannedItems, registeredItems];
}

class InventoryError extends InventoryState {
  final String message;

  const InventoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

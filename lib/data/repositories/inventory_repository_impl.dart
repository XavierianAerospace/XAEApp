import '../../domain/entities/item.dart';
import '../../domain/entities/subsistema.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../api_service.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final ApiService _apiService;

  InventoryRepositoryImpl(this._apiService);

  @override
  Future<List<Item>> getItems() async {
    final result = await _apiService.getItems();
    return result.map((json) => Item.fromJson(json)).toList();
  }

  @override
  Future<List<RegisteredItem>> getRegisteredItems() async {
    final result = await _apiService.getRegisteredItems();
    return result.map((json) => RegisteredItem.fromJson(json)).toList();
  }

  @override
  Future<List<Subsistema>> getSubsistemas() async {
    final result = await _apiService.getSubsistemas();
    return result.map((json) => Subsistema.fromJson(json)).toList();
  }
}

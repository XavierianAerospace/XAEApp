import '../entities/item.dart';
import '../entities/subsistema.dart';

abstract class InventoryRepository {
  Future<List<Item>> getItems();
  Future<List<RegisteredItem>> getRegisteredItems();
  Future<List<Subsistema>> getSubsistemas();
}

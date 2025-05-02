import '../entities/inventory_item.dart';

abstract class JsonStorageService<T extends InventoryItem> {
  Future<void> addItem(T item);
  Future<List<T>> getAllItems();
  Future<String> deleteItem(String id);
  Future<void> updateItem(String id, T item);
}
import 'package:flutter/material.dart';
import 'package:prepster/model/entities/inventory_item.dart';
import 'package:prepster/model/repositories/inventory_repository.dart';

abstract class InventoryViewModel<T extends InventoryItem> extends ChangeNotifier {
  final InventoryRepository repository;
  List<T> _items = [];

  InventoryViewModel(this.repository) {
    loadItems();
  }

  List<T> getAllItems() => _items;

  Future<void> loadItems() async {
    _items = await repository.getAllItems() as List<T>;
    notifyListeners();
  }

  Future<void> deleteItem(String itemId) async {
    await repository.deleteItem(itemId);
    await loadItems();
  }
}


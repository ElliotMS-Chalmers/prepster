import 'package:flutter/material.dart';
import 'package:prepster/model/entities/inventory_item.dart';
import 'package:prepster/model/repositories/inventory_repository.dart';

import '../../model/entities/pantry_item.dart';
import '../../model/repositories/pantry_repository.dart';

class PantryViewModel extends ChangeNotifier {
  final InventoryRepository _repository;
  List<PantryItem> _items = [];

  PantryViewModel(this._repository) {
    _loadItems();
  }

  List<InventoryItem> getAllItems() => _items;

  Future<void> _loadItems() async {
    _items = await _repository.getAllItems() as List<PantryItem>;
    notifyListeners();
  }

  Future<void> addItem({
    required String name,
    DateTime? expirationDate,
    double? calories100g,
    Map<FoodCategory, double>? categories,
    bool? excludeFromDateTracker,
    bool? excludeFromCaloriesTracker,
    double? weightKg,
  }) async {
    await _repository.addItem(
      itemType: ItemType.pantryItem,
      name: name,
      expirationDate: expirationDate,
      calories100g: calories100g,
      categories: categories,
      excludeFromDateTracker: excludeFromDateTracker,
      excludeFromCaloriesTracker: excludeFromCaloriesTracker,
      weightKg: weightKg,
    );
    await _loadItems();
  }
  Future<void> deleteItem(String itemId) async {
    await _repository.deleteItem(itemId);
    //_items.removeAt(itemId);
    //notifyListeners();
    await _loadItems();
  }
}


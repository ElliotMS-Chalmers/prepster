import 'package:flutter/material.dart';
import 'package:prepster/model/entities/pantry_item.dart';
import 'package:prepster/model/services/json_storage_service.dart';
import 'package:uuid/uuid.dart';

class PantryRepository {

  /// The [newItem] parameter is a [PantryItem] object containing
  /// all the details of the item to be added.
  /// Only 'name' is required, and order does not matter.
  ///
  /// Example of how to create a PantryItem:
  /// ```dart
  /// final apple = PantryItem(name: 'Apple', expirationDate: DateTime.now().add(Duration(days: 7)));
  /// repository.addItem(apple);
  /// ```


  final JsonStorageService _storageService = JsonStorageService();
  final _uuid = const Uuid();
  List<PantryItem> pantryItems = [];


  Future<void> addItem({
    required String name,
    DateTime? expirationDate,
    double? calories100g,
    List<FoodCategory>? categories,
    bool? excludeFromDateTracker,
    bool? excludeFromCaloriesTracker,
    double? weightKg,
  }) async {

    final itemId = _uuid.v4();

    PantryItem newItem = PantryItem(
      id: itemId,
      name: name,
      expirationDate: expirationDate,
      calories100g: calories100g,
      categories: categories,
      excludeFromDateTracker: excludeFromDateTracker,
      excludeFromCaloriesTracker: excludeFromCaloriesTracker,
      weightKg: weightKg,
    );
    //TODO: Use this instead of temporary
    await _storageService.addItem(newItem); // Proper service-call
    //TODO: Temporary until service is fully implemented
    pantryItems.add(newItem);
    print('Successfully added $newItem');
  }

  /// Returns a list of all pantry items.
  Future<List<PantryItem>> getAllItems() async {
    final List<PantryItem> pantryList = await _storageService.getAllItems();
    print('Successfully called the getAllItems-method and returned a map.');
    return pantryList;
  }


  /// Returns a specific pantry item.
  Future<PantryItem> getItem(int index) async {
    print('Successfully called the getItem-method for index: $index');
    return pantryItems[index];
  }


  /// Required: name: [name], followed by propertyToUpdate: [newValue]
  /// Order doesn't matter.
  ///
  /// Example:
  /// ```dart
  /// updateItem(name: 'rice', excludeFromDateTracker: true, calories100g: 200);
  /// ```
  Future<void> updateItem({
      required String name,
      DateTime? expirationDate,
      double? calories100g,
      List<FoodCategory>? categories,
      bool? excludeFromDateTracker,
      bool? excludeFromCaloriesTracker}) async {
    print('Successfully called the updateItem-method for name: $name');
  }

  Future<void> deleteItem<T>(T itemToDelete) async {
    if (itemToDelete is String) {
      final result = await _storageService.deleteItem(itemToDelete);
      print(result);
      pantryItems.removeWhere((item) => item.id == itemToDelete);
    }
    if (itemToDelete is int){
      print('Successfully called the deleteItem-method and parsed\n the index: $itemToDelete');
      pantryItems.removeAt(itemToDelete);
    }
  }
}
import 'package:flutter/material.dart';
import 'package:prepster/model/entities/pantry_item.dart';
import 'package:prepster/model/services/json_storage_service.dart';

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
  List<PantryItem> pantryItems = [];

  Future<void> addItem(PantryItem newItem) async {
    await _storageService.addItem(newItem); // Call the service to add
    print('Successfully added $newItem');
    pantryItems.add(newItem);
  }


  /// Returns a list of all pantry items.
  Future<List<PantryItem>> getAllItems() async {
    pantryItems = await _storageService.getAllItems();
    print('Successfully called the updateItem-method and returned an empty list.');
    return pantryItems;
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


  /// Deletes a specific pantry item identified by index.
  Future<void> deleteItem(int index) async {
    print('Successfully called the deleteItem-method and parsed\n the index: $index');
    pantryItems.removeAt(index);
  }

}
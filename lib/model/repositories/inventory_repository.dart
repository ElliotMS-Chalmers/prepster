import 'package:prepster/model/entities/pantry_item.dart';
import 'package:uuid/uuid.dart';
import 'package:prepster/utils/logger.dart';

import '../../utils/default_settings.dart';
import '../entities/equipment_item.dart';
import '../entities/inventory_item.dart';
import '../entities/medical_item.dart';
import '../services/json_storage_service.dart';

class InventoryRepository<T extends InventoryItem> {

  /// The [newItem] parameter is a [PantryItem] object containing
  /// all the details of the item to be added.
  /// Only 'name' is required, and order does not matter.
  ///
  /// Example of how to create a PantryItem:
  /// ```dart
  /// pantry_repository.addItem(name: 'Apple', expirationDate: DateTime.now().add(Duration(days: 7)));
  /// ```


  final JsonStorageService _storageService;
  //Maybe need more services for saving

  List<T> items = [];

  InventoryRepository(this._storageService);

  Future<void> addItem({
    required ItemType itemType,
    required String name,
    DateTime? expirationDate,
    int? amount,
    double? calories100g,
    double? weightKg,
    Map<FoodCategory, double>? categories,
    bool? excludeFromDateTracker,
    bool? excludeFromCaloriesTracker
  }) async {

    InventoryItem newItem;

    final itemId = Uuid().v4();

    if (name.length > MAXIMUM_ALLOWED_NAME_LENGTH){
      throw ArgumentError('Name cannot be longer than $MAXIMUM_ALLOWED_NAME_LENGTH characters');
    }

    amount ??= 1;

    if (expirationDate == null){
      excludeFromDateTracker = true;
    }

    if (calories100g == null){
      excludeFromCaloriesTracker = true;
    }

    // The ??= replaces if-statements to check for null-values
    // If the value isn't null then the value won't be changed
    if (weightKg != null && weightKg.isNegative){
      throw ArgumentError('Weight cannot be negative');
    }

    categories ??= <FoodCategory, double>{};
    for (var category in FoodCategory.values) {
      categories.putIfAbsent(category, () => 0.0);
    }

    excludeFromDateTracker ??= false;
    excludeFromCaloriesTracker ??= false;

    switch (itemType) {
      case ItemType.pantryItem:
        newItem = PantryItem(
            id: itemId,
            name: name,
            amount: amount,
            expirationDate: expirationDate,
            calories100g: calories100g,
            weightKg: weightKg,
            categories: categories,
            excludeFromDateTracker: excludeFromDateTracker,
            excludeFromCaloriesTracker: excludeFromCaloriesTracker
        );
      case ItemType.medicalItem:
        newItem = MedicalItem(
          id: itemId,
          name: name,
          amount: amount,
          expirationDate: expirationDate,
          excludeFromDateTracker: excludeFromDateTracker,
        );
      case ItemType.equipmentItem:
        newItem = EquipmentItem(
          id: itemId,
          name: name,
          amount: amount,
          expirationDate: expirationDate,
          excludeFromDateTracker: excludeFromDateTracker,
        );
    }
    //TODO: Error handling
    await _storageService.addItem(newItem);
  }

  /// Returns a list of all pantry items.
  Future<List<T>> getAllItems() async {
    final List<T> list = await _storageService.getAllItems() as List<T>;
    logger.i('Successfully called the getAllItems-method and returned a map');
    return list;
  }


  /// Returns a specific pantry item.
  Future<T> getItem(int index) async {
    logger.i('Successfully called the getItem-method for index: $index');
    return items[index];
  }


  /// Required: name: [name], followed by propertyToUpdate: [newValue]
  /// Order doesn't matter.
  ///
  /// Example:
  /// ```dart
  /// updateItem(name: 'rice', excludeFromDateTracker: true, calories100g: 200);
  /// ```
  Future<void> updateItem({
    required String id, //Identifier that will be used for service
    required ItemType itemType,
    required String name,
    int? amount,
    DateTime? expirationDate,
    double? calories100g,
    double? weightKg,
    Map<FoodCategory, double>? categories,
    bool? excludeFromDateTracker,
    bool? excludeFromCaloriesTracker}) async {

      InventoryItem updatedItem;

      if (name.length > 50){
        throw ArgumentError('Name cannot be longer than 50 characters');
      }

      amount ??= 1;

      if (expirationDate == null){
        excludeFromDateTracker = true;
      }

      if (calories100g == null){
        excludeFromCaloriesTracker = true;
      }

      // The ??= replaces if-statements to check for null-values
      // If the value isn't null then the value won't be changed
      if (weightKg != null && weightKg.isNegative){
        throw ArgumentError('Weight cannot be negative');
      }

      categories ??= <FoodCategory, double>{};
      for (var category in FoodCategory.values) {
        categories.putIfAbsent(category, () => 0.0);
      }

      excludeFromDateTracker ??= false;
      excludeFromCaloriesTracker ??= false;

      switch (itemType) {
        case ItemType.pantryItem:
          updatedItem = PantryItem(
              id: id,
              name: name,
              amount: amount,
              expirationDate: expirationDate,
              calories100g: calories100g,
              weightKg: weightKg,
              categories: categories,
              excludeFromDateTracker: excludeFromDateTracker,
              excludeFromCaloriesTracker: excludeFromCaloriesTracker
          );
        case ItemType.medicalItem:
          updatedItem = MedicalItem(
            id: id,
            name: name,
            amount: amount,
            expirationDate: expirationDate,
            excludeFromDateTracker: excludeFromDateTracker,
          );
        case ItemType.equipmentItem:
          updatedItem = EquipmentItem(
            id: id,
            name: name,
            amount: amount,
            expirationDate: expirationDate,
            excludeFromDateTracker: excludeFromDateTracker,
          );
      }

      await _storageService.updateItem(id, updatedItem);
  }

  Future<void> deleteItem(String itemToDelete) async {
    final result = await _storageService.deleteItem(itemToDelete);
    logger.i(result);
    items.removeWhere((item) => item.id == itemToDelete);
  }
}

enum ItemType {
  pantryItem,
  medicalItem,
  equipmentItem
}
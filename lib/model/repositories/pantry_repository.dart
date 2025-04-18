import 'package:prepster/model/entities/pantry_item.dart';
import 'package:prepster/model/services/json_storage_service.dart';
import 'package:uuid/uuid.dart';
import 'package:prepster/utils/logger.dart';

class PantryRepository {

  /// The [newItem] parameter is a [PantryItem] object containing
  /// all the details of the item to be added.
  /// Only 'name' is required, and order does not matter.
  ///
  /// Example of how to create a PantryItem:
  /// ```dart
  /// pantry_repository.addItem(name: 'Apple', expirationDate: DateTime.now().add(Duration(days: 7)));
  /// ```


  final JsonStorageService _storageService = JsonStorageService();
  List<PantryItem> pantryItems = [];


  Future<void> addItem({
    required String name,
    DateTime? expirationDate,
    int? amount,
    double? calories100g,
    double? weightKg,
    List<FoodCategory>? categories,
    bool? excludeFromDateTracker,
    bool? excludeFromCaloriesTracker
  }) async {

    final itemId = Uuid().v4();

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

    categories ??= <FoodCategory>[];
    excludeFromDateTracker ??= false;
    excludeFromCaloriesTracker ??= false;


    PantryItem newItem = PantryItem(
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
    //TODO: Error handling
    await _storageService.addItem(newItem);
  }

  /// Returns a list of all pantry items.
  Future<List<PantryItem>> getAllItems() async {
    final List<PantryItem> pantryList = await _storageService.getAllItems();
    logger.i('Successfully called the getAllItems-method and returned a map');
    return pantryList;
  }


  /// Returns a specific pantry item.
  Future<PantryItem> getItem(int index) async {
    logger.i('Successfully called the getItem-method for index: $index');
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
    logger.i('Successfully called the updateItem-method for name: $name');
  }

  Future<void> deleteItem<T>(T itemToDelete) async {
    if (itemToDelete is String) {
      final result = await _storageService.deleteItem(itemToDelete);
      logger.i(result);
      pantryItems.removeWhere((item) => item.id == itemToDelete);
    }
    if (itemToDelete is int){
      logger.i('Successfully called the deleteItem-method and parsed\n the index: $itemToDelete');
      pantryItems.removeAt(itemToDelete);
    }
  }
}
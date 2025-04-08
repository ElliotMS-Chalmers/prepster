import 'package:prepster/model/entities/pantry_item.dart';

class PantryRepository{

  /// The [newItem] parameter is a [PantryItem] object containing
  /// all the details of the item to be added.
  /// Only 'name' is required, and order does not matter.
  ///
  /// Example of how to create a PantryItem:
  /// ```dart
  /// final apple = PantryItem(name: 'Apple', expirationDate: DateTime.now().add(Duration(days: 7)));
  /// repository.addItem(apple);
  /// ```
  Future<void> addItem(PantryItem newItem) async {
    print('Successfully added $newItem');
  }


  /// Returns a list of all pantry items.
  Future<List<PantryItem>> getAllItems() async {
    print('Successfully called the updateItem-method and returned an empty list.');
    return [];
  }


  /// Returns a specific pantry item.
  Future<PantryItem> getItem(String name) async {
    print('Successfully called the getItem-method for name: $name');
    return PantryItem(name: name, expirationDate: DateTime.now());
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


  /// Deletes a specific pantry item identified by [name].
  Future<void> deleteItem(String name) async {
    print('Successfully called the deleteItem-method and parsed\n the name: $name');
  }

}
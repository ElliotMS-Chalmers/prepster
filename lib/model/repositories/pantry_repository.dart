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
    print('Successfully added $newItem')
  }


  /// Returns a list of all pantry items.
  Future<List<PantryItem>> getAllItems() async {
    return [];
  }


  /// Returns a specific pantry item.
  Future<PantryItem> getItem(String name) async {
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

enum FoodCategory {
  fat,
  carbohydrate,
  protein,
}


/// This class represents an item in the pantry.
///
/// The [categories] property uses the [FoodCategory] enum
/// to define the different types of food.
class PantryItem {

  /// Required: Name of the pantry item.
  String name;

  /// Optional: Expiration date.
  DateTime? expirationDate;

  /// Optional: How many calories does 100g of an item contain.
  double? calories100g;

  /// Optional:
  /// A list of categories this item belongs to, using the [FoodCategory] enum.
  /// Possible values are:
  /// [FoodCategory.fat], [FoodCategory.carbohydrate], [FoodCategory.protein].
  List<FoodCategory>? categories;

  /// Optional: Exclude this item from the expiration-date-tracker.
  /// This means no notifications etc. will be sent for this item.
  bool? excludeFromDateTracker;

  /// Optional: Exclude this item from the calorie-tracker.
  /// Use this for items you don't want to be counted for the...
  /// ..."How many days will my food last me?"-tracker.
  bool? excludeFromCaloriesTracker;

  PantryItem({
    required this.name,
    this.expirationDate,
    this.calories100g,
    this.categories,
    this.excludeFromDateTracker,
    this.excludeFromCaloriesTracker
  });

}
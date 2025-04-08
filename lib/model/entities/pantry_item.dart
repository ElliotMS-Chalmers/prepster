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

enum FoodCategory {
  fat,
  carbohydrate,
  protein,
}

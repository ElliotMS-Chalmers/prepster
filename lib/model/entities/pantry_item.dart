import 'package:json_annotation/json_annotation.dart';

/// This class represents an item in the pantry.
///
/// The [categories] property uses the [FoodCategory] enum
/// to define the different types of food.

part 'pantry_item.g.dart';

// ##### IMPORTANT #####
// ##### IMPORTANT #####
// ##### IMPORTANT #####

// If you add any properties or change existing,
// you must run this terminal-command to regenerate the json-handler:
// "dart run build_runner build"

// ##### IMPORTANT #####
// ##### IMPORTANT #####
// ##### IMPORTANT #####

@JsonSerializable()
class PantryItem {

  // id will be generated at creation using Uuid().
  String id;

  /// Required: Name of the pantry item.
  String name;

  int? amount;

  /// Optional: Expiration date.
  DateTime? expirationDate;

  /// Optional: How many calories does 100g of an item contain.
  double? calories100g;

  /// Optional: How much does the item weigh in kilograms.
  double? weightKg;

  /// Optional:
  /// A list of categories this item belongs to, using the [FoodCategory] enum.
  /// Possible values are:
  /// [FoodCategory.fat], [FoodCategory.carbohydrate], [FoodCategory.protein].
  Map<FoodCategory, double>? categories;

  /// Optional: Exclude this item from the expiration-date-tracker.
  /// This means no notifications etc. will be sent for this item.
  bool? excludeFromDateTracker;

  /// Optional: Exclude this item from the calorie-tracker.
  /// Use this for items you don't want to be counted for the...
  /// ..."How many days will my food last me?"-tracker.
  bool? excludeFromCaloriesTracker;

  PantryItem({
    required this.id,
    required this.name,
    this.amount,
    this.expirationDate,
    this.calories100g,
    this.categories,
    this.excludeFromDateTracker,
    this.excludeFromCaloriesTracker,
    this.weightKg
  });

  factory PantryItem.fromJson(Map<String, dynamic> json) => _$PantryItemFromJson(json);

  Map<String, dynamic> toJson() => _$PantryItemToJson(this);

  // This toString() is for debugging purposes only.
  // Otherwise methods like getAllItems() will only print a list like this:
  // [Instance of 'PantryItem', Instance of 'PantryItem']
  // With this, it instead prints:
  // [PantryItem(name: Apple, calories100g: 50.0, expirationDate: null),
  // PantryItem(name: Banana, calories100g: 96.0, expirationDate: null)]
  @override
  String toString() {
    return 'PantryItem(name: $name, calories100g: $calories100g, expirationDate: $expirationDate)';
  }

}

enum FoodCategory {
  fat,
  carbohydrate,
  protein,
}

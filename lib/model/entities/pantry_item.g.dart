// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantry_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PantryItem _$PantryItemFromJson(Map<String, dynamic> json) => PantryItem(
  id: json['id'] as String,
  name: json['name'] as String,
  amount: (json['amount'] as num?)?.toInt(),
  expirationDate:
      json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
  calories100g: (json['calories100g'] as num?)?.toDouble(),
  categories: (json['categories'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry($enumDecode(_$FoodCategoryEnumMap, k), (e as num).toDouble()),
  ),
  excludeFromDateTracker: json['excludeFromDateTracker'] as bool?,
  excludeFromCaloriesTracker: json['excludeFromCaloriesTracker'] as bool?,
  weightKg: (json['weightKg'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PantryItemToJson(PantryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'calories100g': instance.calories100g,
      'weightKg': instance.weightKg,
      'categories': instance.categories?.map(
        (k, e) => MapEntry(_$FoodCategoryEnumMap[k]!, e),
      ),
      'excludeFromDateTracker': instance.excludeFromDateTracker,
      'excludeFromCaloriesTracker': instance.excludeFromCaloriesTracker,
    };

const _$FoodCategoryEnumMap = {
  FoodCategory.fat: 'fat',
  FoodCategory.carbohydrate: 'carbohydrate',
  FoodCategory.protein: 'protein',
};

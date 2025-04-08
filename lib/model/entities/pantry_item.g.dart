// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantry_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PantryItem _$PantryItemFromJson(Map<String, dynamic> json) => PantryItem(
  name: json['name'] as String,
  expirationDate:
      json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
  calories100g: (json['calories100g'] as num?)?.toDouble(),
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$FoodCategoryEnumMap, e))
          .toList(),
  excludeFromDateTracker: json['excludeFromDateTracker'] as bool?,
  excludeFromCaloriesTracker: json['excludeFromCaloriesTracker'] as bool?,
);

Map<String, dynamic> _$PantryItemToJson(PantryItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'calories100g': instance.calories100g,
      'categories':
          instance.categories?.map((e) => _$FoodCategoryEnumMap[e]!).toList(),
      'excludeFromDateTracker': instance.excludeFromDateTracker,
      'excludeFromCaloriesTracker': instance.excludeFromCaloriesTracker,
    };

const _$FoodCategoryEnumMap = {
  FoodCategory.fat: 'fat',
  FoodCategory.carbohydrate: 'carbohydrate',
  FoodCategory.protein: 'protein',
};

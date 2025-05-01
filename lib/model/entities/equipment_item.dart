import 'package:json_annotation/json_annotation.dart';
import 'package:prepster/model/entities/inventory_item.dart';

/// This class represents an item in the pantry.
///
/// The [categories] property uses the [FoodCategory] enum
/// to define the different types of food.

part 'equipment_item.g.dart';

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
class EquipmentItem extends InventoryItem {

  // id will be generated at creation using Uuid().
  @override
  String id;

  /// Required: Name of the pantry item.
  @override
  String name;

  @override
  int? amount;

  /// Optional: Expiration date.
  DateTime? expirationDate;

  /// Optional: Exclude this item from the expiration-date-tracker.
  /// This means no notifications etc. will be sent for this item.
  bool? excludeFromDateTracker;

  EquipmentItem({
    required this.id,
    required this.name,
    this.amount,
    this.expirationDate,
    this.excludeFromDateTracker,
  });

  factory EquipmentItem.fromJson(Map<String, dynamic> json) => _$EquipmentItemFromJson(json);

  Map<String, dynamic> toJson() => _$EquipmentItemToJson(this);

}

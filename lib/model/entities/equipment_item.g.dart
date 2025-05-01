// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EquipmentItem _$EquipmentItemFromJson(Map<String, dynamic> json) =>
    EquipmentItem(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num?)?.toInt(),
      expirationDate:
          json['expirationDate'] == null
              ? null
              : DateTime.parse(json['expirationDate'] as String),
      excludeFromDateTracker: json['excludeFromDateTracker'] as bool?,
    );

Map<String, dynamic> _$EquipmentItemToJson(EquipmentItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'excludeFromDateTracker': instance.excludeFromDateTracker,
    };

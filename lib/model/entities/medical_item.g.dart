// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalItem _$MedicalItemFromJson(Map<String, dynamic> json) => MedicalItem(
  id: json['id'] as String,
  name: json['name'] as String,
  amount: (json['amount'] as num?)?.toInt(),
  expirationDate:
      json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
  excludeFromDateTracker: json['excludeFromDateTracker'] as bool?,
);

Map<String, dynamic> _$MedicalItemToJson(MedicalItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'excludeFromDateTracker': instance.excludeFromDateTracker,
    };

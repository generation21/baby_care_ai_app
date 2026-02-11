// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeding_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedingRecord _$FeedingRecordFromJson(Map<String, dynamic> json) =>
    FeedingRecord(
      id: (json['id'] as num).toInt(),
      babyId: (json['baby_id'] as num).toInt(),
      feedingType: $enumDecode(_$FeedingTypeEnumMap, json['feeding_type']),
      amount: (json['amount'] as num?)?.toInt(),
      unit: json['unit'] as String?,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      side: json['side'] as String?,
      notes: json['notes'] as String?,
      recordedAt: json['recorded_at'] as String,
      userId: json['user_id'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$FeedingRecordToJson(FeedingRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'baby_id': instance.babyId,
      'feeding_type': _$FeedingTypeEnumMap[instance.feedingType]!,
      'amount': instance.amount,
      'unit': instance.unit,
      'duration_minutes': instance.durationMinutes,
      'side': instance.side,
      'notes': instance.notes,
      'recorded_at': instance.recordedAt,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

const _$FeedingTypeEnumMap = {
  FeedingType.breastMilk: 'breast_milk',
  FeedingType.formula: 'formula',
  FeedingType.pumping: 'pumping',
  FeedingType.solidFood: 'solid_food',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CareRecord _$CareRecordFromJson(Map<String, dynamic> json) => CareRecord(
  id: (json['id'] as num).toInt(),
  babyId: (json['baby_id'] as num).toInt(),
  recordType: $enumDecode(_$CareRecordTypeEnumMap, json['record_type']),
  diaperType: $enumDecodeNullable(_$DiaperTypeEnumMap, json['diaper_type']),
  sleepStart: json['sleep_start'] as String?,
  sleepEnd: json['sleep_end'] as String?,
  temperature: (json['temperature'] as num?)?.toDouble(),
  temperatureUnit: json['temperature_unit'] as String?,
  medicineName: json['medicine_name'] as String?,
  medicineDosage: json['medicine_dosage'] as String?,
  notes: json['notes'] as String?,
  recordedAt: json['recorded_at'] as String,
  userId: json['user_id'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$CareRecordToJson(CareRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'baby_id': instance.babyId,
      'record_type': _$CareRecordTypeEnumMap[instance.recordType]!,
      'diaper_type': _$DiaperTypeEnumMap[instance.diaperType],
      'sleep_start': instance.sleepStart,
      'sleep_end': instance.sleepEnd,
      'temperature': instance.temperature,
      'temperature_unit': instance.temperatureUnit,
      'medicine_name': instance.medicineName,
      'medicine_dosage': instance.medicineDosage,
      'notes': instance.notes,
      'recorded_at': instance.recordedAt,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

const _$CareRecordTypeEnumMap = {
  CareRecordType.diaper: 'diaper',
  CareRecordType.sleep: 'sleep',
  CareRecordType.bath: 'bath',
  CareRecordType.medicine: 'medicine',
  CareRecordType.temperature: 'temperature',
  CareRecordType.other: 'other',
};

const _$DiaperTypeEnumMap = {
  DiaperType.wet: 'wet',
  DiaperType.dirty: 'dirty',
  DiaperType.both: 'both',
};

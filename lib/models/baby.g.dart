// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baby.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Baby _$BabyFromJson(Map<String, dynamic> json) => Baby(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  birthDate: json['birth_date'] as String,
  gender: json['gender'] as String?,
  photo: json['photo'] as String?,
  bloodType: json['blood_type'] as String?,
  notes: json['notes'] as Map<String, dynamic>?,
  isActive: json['is_active'] as bool,
  userId: json['user_id'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$BabyToJson(Baby instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'birth_date': instance.birthDate,
  'gender': instance.gender,
  'photo': instance.photo,
  'blood_type': instance.bloodType,
  'notes': instance.notes,
  'is_active': instance.isActive,
  'user_id': instance.userId,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

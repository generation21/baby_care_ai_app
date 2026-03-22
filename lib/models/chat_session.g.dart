// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatSession _$ChatSessionFromJson(Map<String, dynamic> json) => ChatSession(
  id: (json['id'] as num).toInt(),
  babyId: (json['baby_id'] as num).toInt(),
  userId: json['user_id'] as String,
  title: json['title'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$ChatSessionToJson(ChatSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'baby_id': instance.babyId,
      'user_id': instance.userId,
      'title': instance.title,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

ChatSessionDetail _$ChatSessionDetailFromJson(Map<String, dynamic> json) =>
    ChatSessionDetail(
      id: (json['id'] as num).toInt(),
      babyId: (json['baby_id'] as num).toInt(),
      userId: json['user_id'] as String,
      title: json['title'] as String?,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ChatSessionDetailToJson(ChatSessionDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'baby_id': instance.babyId,
      'user_id': instance.userId,
      'title': instance.title,
      'messages': instance.messages,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

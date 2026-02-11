// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gpt_conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GPTConversation _$GPTConversationFromJson(Map<String, dynamic> json) =>
    GPTConversation(
      id: (json['id'] as num).toInt(),
      babyId: (json['baby_id'] as num).toInt(),
      question: json['question'] as String,
      answer: json['answer'] as String,
      contextData: json['context_data'] as Map<String, dynamic>?,
      userId: json['user_id'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$GPTConversationToJson(GPTConversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'baby_id': instance.babyId,
      'question': instance.question,
      'answer': instance.answer,
      'context_data': instance.contextData,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
    };

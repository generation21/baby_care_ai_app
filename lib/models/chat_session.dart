import 'package:json_annotation/json_annotation.dart';
import 'chat_message.dart';

part 'chat_session.g.dart';

@JsonSerializable()
class ChatSession {
  final int id;
  @JsonKey(name: 'baby_id')
  final int babyId;
  @JsonKey(name: 'user_id')
  final String userId;
  final String? title;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  ChatSession({
    required this.id,
    required this.babyId,
    required this.userId,
    this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  String get displayTitle => title ?? '새 대화';

  DateTime get createdAtDateTime => DateTime.parse(createdAt);
  DateTime get updatedAtDateTime => DateTime.parse(updatedAt);

  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionFromJson(json);
  Map<String, dynamic> toJson() => _$ChatSessionToJson(this);
}

@JsonSerializable()
class ChatSessionDetail {
  final int id;
  @JsonKey(name: 'baby_id')
  final int babyId;
  @JsonKey(name: 'user_id')
  final String userId;
  final String? title;
  final List<ChatMessage> messages;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  ChatSessionDetail({
    required this.id,
    required this.babyId,
    required this.userId,
    this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  String get displayTitle => title ?? '새 대화';

  factory ChatSessionDetail.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionDetailFromJson(json);
  Map<String, dynamic> toJson() => _$ChatSessionDetailToJson(this);
}

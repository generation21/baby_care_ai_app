import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

@JsonSerializable()
class ChatMessage {
  final int id;
  @JsonKey(name: 'session_id')
  final int sessionId;
  final String role;
  final String content;
  @JsonKey(name: 'created_at')
  final String createdAt;

  ChatMessage({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';

  DateTime get createdAtDateTime => DateTime.parse(createdAt);

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

@JsonSerializable()
class SendMessageResponse {
  @JsonKey(name: 'user_message')
  final ChatMessage userMessage;
  @JsonKey(name: 'assistant_message')
  final ChatMessage assistantMessage;

  SendMessageResponse({
    required this.userMessage,
    required this.assistantMessage,
  });

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SendMessageResponseToJson(this);
}

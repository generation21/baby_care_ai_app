import 'package:json_annotation/json_annotation.dart';

part 'gpt_conversation.g.dart';

/// GPT 대화 모델
@JsonSerializable()
class GPTConversation {
  final int id;
  @JsonKey(name: 'baby_id')
  final int babyId;
  final String question;
  final String answer;
  @JsonKey(name: 'context_data')
  final Map<String, dynamic>? contextData;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'created_at')
  final String createdAt;

  GPTConversation({
    required this.id,
    required this.babyId,
    required this.question,
    required this.answer,
    this.contextData,
    required this.userId,
    required this.createdAt,
  });

  factory GPTConversation.fromJson(Map<String, dynamic> json) =>
      _$GPTConversationFromJson(json);
  Map<String, dynamic> toJson() => _$GPTConversationToJson(this);

  /// 생성 시간 DateTime 객체로 반환
  DateTime get createdAtDateTime => DateTime.parse(createdAt);

  /// copyWith 메서드
  GPTConversation copyWith({
    int? id,
    int? babyId,
    String? question,
    String? answer,
    Map<String, dynamic>? contextData,
    String? userId,
    String? createdAt,
  }) {
    return GPTConversation(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      contextData: contextData ?? this.contextData,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

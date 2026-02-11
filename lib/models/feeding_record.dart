import 'package:json_annotation/json_annotation.dart';

part 'feeding_record.g.dart';

/// 수유 타입 Enum
enum FeedingType {
  @JsonValue('breast_milk')
  breastMilk,
  @JsonValue('formula')
  formula,
  @JsonValue('pumping')
  pumping,
  @JsonValue('solid_food')
  solidFood,
}

/// 수유 기록 모델
@JsonSerializable()
class FeedingRecord {
  final int id;
  @JsonKey(name: 'baby_id')
  final int babyId;
  @JsonKey(name: 'feeding_type')
  final FeedingType feedingType;
  final int? amount;
  final String? unit;
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;
  final String? side;
  final String? notes;
  @JsonKey(name: 'recorded_at')
  final String recordedAt;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  FeedingRecord({
    required this.id,
    required this.babyId,
    required this.feedingType,
    this.amount,
    this.unit,
    this.durationMinutes,
    this.side,
    this.notes,
    required this.recordedAt,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeedingRecord.fromJson(Map<String, dynamic> json) =>
      _$FeedingRecordFromJson(json);
  Map<String, dynamic> toJson() => _$FeedingRecordToJson(this);

  /// 기록 시간 DateTime 객체로 반환
  DateTime get recordedAtDateTime => DateTime.parse(recordedAt);

  /// copyWith 메서드
  FeedingRecord copyWith({
    int? id,
    int? babyId,
    FeedingType? feedingType,
    int? amount,
    String? unit,
    int? durationMinutes,
    String? side,
    String? notes,
    String? recordedAt,
    String? userId,
    String? createdAt,
    String? updatedAt,
  }) {
    return FeedingRecord(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      feedingType: feedingType ?? this.feedingType,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      side: side ?? this.side,
      notes: notes ?? this.notes,
      recordedAt: recordedAt ?? this.recordedAt,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// FeedingType 확장 메서드
extension FeedingTypeExtension on FeedingType {
  /// 수유 타입의 한글 표시명
  String get displayName {
    switch (this) {
      case FeedingType.breastMilk:
        return '모유';
      case FeedingType.formula:
        return '분유';
      case FeedingType.pumping:
        return '유축';
      case FeedingType.solidFood:
        return '이유식';
    }
  }
}

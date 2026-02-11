import 'package:json_annotation/json_annotation.dart';

part 'care_record.g.dart';

/// 육아 기록 타입 Enum
enum CareRecordType {
  @JsonValue('diaper')
  diaper,
  @JsonValue('sleep')
  sleep,
  @JsonValue('bath')
  bath,
  @JsonValue('medicine')
  medicine,
  @JsonValue('temperature')
  temperature,
  @JsonValue('other')
  other,
}

/// 기저귀 타입 Enum
enum DiaperType {
  @JsonValue('wet')
  wet,
  @JsonValue('dirty')
  dirty,
  @JsonValue('both')
  both,
}

/// 육아 기록 모델
@JsonSerializable()
class CareRecord {
  final int id;
  @JsonKey(name: 'baby_id')
  final int babyId;
  @JsonKey(name: 'record_type')
  final CareRecordType recordType;
  @JsonKey(name: 'diaper_type')
  final DiaperType? diaperType;
  @JsonKey(name: 'sleep_start')
  final String? sleepStart;
  @JsonKey(name: 'sleep_end')
  final String? sleepEnd;
  final double? temperature;
  @JsonKey(name: 'temperature_unit')
  final String? temperatureUnit;
  @JsonKey(name: 'medicine_name')
  final String? medicineName;
  @JsonKey(name: 'medicine_dosage')
  final String? medicineDosage;
  final String? notes;
  @JsonKey(name: 'recorded_at')
  final String recordedAt;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  CareRecord({
    required this.id,
    required this.babyId,
    required this.recordType,
    this.diaperType,
    this.sleepStart,
    this.sleepEnd,
    this.temperature,
    this.temperatureUnit,
    this.medicineName,
    this.medicineDosage,
    this.notes,
    required this.recordedAt,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CareRecord.fromJson(Map<String, dynamic> json) =>
      _$CareRecordFromJson(json);
  Map<String, dynamic> toJson() => _$CareRecordToJson(this);

  /// 기록 시간 DateTime 객체로 반환
  DateTime get recordedAtDateTime => DateTime.parse(recordedAt);

  /// 수면 시간 계산 (분)
  int? get sleepDurationMinutes {
    if (sleepStart == null || sleepEnd == null) return null;
    final start = DateTime.parse(sleepStart!);
    final end = DateTime.parse(sleepEnd!);
    return end.difference(start).inMinutes;
  }

  /// 수면 시간 계산 (시간)
  double? get sleepDurationHours {
    final minutes = sleepDurationMinutes;
    if (minutes == null) return null;
    return minutes / 60.0;
  }

  /// copyWith 메서드
  CareRecord copyWith({
    int? id,
    int? babyId,
    CareRecordType? recordType,
    DiaperType? diaperType,
    String? sleepStart,
    String? sleepEnd,
    double? temperature,
    String? temperatureUnit,
    String? medicineName,
    String? medicineDosage,
    String? notes,
    String? recordedAt,
    String? userId,
    String? createdAt,
    String? updatedAt,
  }) {
    return CareRecord(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      recordType: recordType ?? this.recordType,
      diaperType: diaperType ?? this.diaperType,
      sleepStart: sleepStart ?? this.sleepStart,
      sleepEnd: sleepEnd ?? this.sleepEnd,
      temperature: temperature ?? this.temperature,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      medicineName: medicineName ?? this.medicineName,
      medicineDosage: medicineDosage ?? this.medicineDosage,
      notes: notes ?? this.notes,
      recordedAt: recordedAt ?? this.recordedAt,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// CareRecordType 확장 메서드
extension CareRecordTypeExtension on CareRecordType {
  /// 육아 기록 타입의 한글 표시명
  String get displayName {
    switch (this) {
      case CareRecordType.diaper:
        return '기저귀';
      case CareRecordType.sleep:
        return '수면';
      case CareRecordType.bath:
        return '목욕';
      case CareRecordType.medicine:
        return '약';
      case CareRecordType.temperature:
        return '체온';
      case CareRecordType.other:
        return '기타';
    }
  }
}

/// DiaperType 확장 메서드
extension DiaperTypeExtension on DiaperType {
  /// 기저귀 타입의 한글 표시명
  String get displayName {
    switch (this) {
      case DiaperType.wet:
        return '소변';
      case DiaperType.dirty:
        return '대변';
      case DiaperType.both:
        return '소변+대변';
    }
  }
}

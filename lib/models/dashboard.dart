import 'package:json_annotation/json_annotation.dart';

part 'dashboard.g.dart';

/// 대시보드 메인 모델
@JsonSerializable()
class Dashboard {
  final BabyInfo baby;
  @JsonKey(name: 'last_records')
  final LastRecords lastRecords;
  @JsonKey(name: 'active_feeding_timer')
  final ActiveFeedingTimerData activeFeedingTimer;
  @JsonKey(name: 'daily_summary')
  final DailySummary dailySummary;

  Dashboard({
    required this.baby,
    required this.lastRecords,
    required this.activeFeedingTimer,
    required this.dailySummary,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) =>
      _$DashboardFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardToJson(this);

  /// 하위 호환성을 위한 getter
  BabyInfo get babyInfo => baby;
  
  /// 하위 호환성을 위한 getter (최근 수유 기록)
  LastRecord? get latestFeeding => lastRecords.breastMilk ?? lastRecords.formula;
  
  /// 하위 호환성을 위한 getter (최근 기저귀 기록)
  LastRecord? get latestDiaper => lastRecords.diaper;
  
  /// 하위 호환성을 위한 getter (최근 수면 기록)
  LastRecord? get latestSleep => lastRecords.sleep;
  
  /// 하위 호환성을 위한 getter
  TodaySummary get todaySummary => TodaySummary(
    feedingCount: dailySummary.feedingCount,
    diaperCount: dailySummary.diaperCount,
    sleepHours: dailySummary.totalSleepDurationMinutes / 60.0,
  );
}

/// 최근 기록 모델
@JsonSerializable()
class LastRecords {
  @JsonKey(name: 'breast_milk')
  final LastRecord? breastMilk;
  final LastRecord? formula;
  final LastRecord? solid;
  final LastRecord? pumping;
  final LastRecord? sleep;
  final LastRecord? diaper;
  final LastRecord? temperature;
  final LastRecord? medicine;
  final LastRecord? activity;

  LastRecords({
    this.breastMilk,
    this.formula,
    this.solid,
    this.pumping,
    this.sleep,
    this.diaper,
    this.temperature,
    this.medicine,
    this.activity,
  });

  factory LastRecords.fromJson(Map<String, dynamic> json) =>
      _$LastRecordsFromJson(json);
  Map<String, dynamic> toJson() => _$LastRecordsToJson(this);
}

/// 개별 최근 기록 모델
@JsonSerializable()
class LastRecord {
  final String? time;
  @JsonKey(name: 'relative_time')
  final String relativeTime;
  final Map<String, dynamic>? details;

  LastRecord({
    this.time,
    required this.relativeTime,
    this.details,
  });

  factory LastRecord.fromJson(Map<String, dynamic> json) =>
      _$LastRecordFromJson(json);
  Map<String, dynamic> toJson() => _$LastRecordToJson(this);
}

/// 진행 중인 수유 타이머 데이터 모델
@JsonSerializable()
class ActiveFeedingTimerData {
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'start_time')
  final String? startTime;
  @JsonKey(name: 'current_side')
  final String? currentSide;
  @JsonKey(name: 'left_duration_seconds')
  final int? leftDurationSeconds;
  @JsonKey(name: 'right_duration_seconds')
  final int? rightDurationSeconds;

  ActiveFeedingTimerData({
    required this.isActive,
    this.startTime,
    this.currentSide,
    this.leftDurationSeconds,
    this.rightDurationSeconds,
  });

  factory ActiveFeedingTimerData.fromJson(Map<String, dynamic> json) =>
      _$ActiveFeedingTimerDataFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveFeedingTimerDataToJson(this);
}

/// 일일 요약 통계 모델
@JsonSerializable()
class DailySummary {
  final String date;
  @JsonKey(name: 'total_feeding_amount', defaultValue: '0.0')
  final String totalFeedingAmount;
  @JsonKey(name: 'total_feeding_duration_minutes', defaultValue: 0)
  final int totalFeedingDurationMinutes;
  @JsonKey(name: 'feeding_count', defaultValue: 0)
  final int feedingCount;
  @JsonKey(name: 'breast_milk_count', defaultValue: 0)
  final int breastMilkCount;
  @JsonKey(name: 'formula_count', defaultValue: 0)
  final int formulaCount;
  @JsonKey(name: 'solid_count', defaultValue: 0)
  final int solidCount;
  @JsonKey(name: 'pumping_count', defaultValue: 0)
  final int pumpingCount;
  @JsonKey(name: 'total_sleep_duration_minutes', defaultValue: 0)
  final int totalSleepDurationMinutes;
  @JsonKey(name: 'sleep_count', defaultValue: 0)
  final int sleepCount;
  @JsonKey(name: 'diaper_count', defaultValue: 0)
  final int diaperCount;
  @JsonKey(name: 'temperature_count', defaultValue: 0)
  final int temperatureCount;
  @JsonKey(name: 'medicine_count', defaultValue: 0)
  final int medicineCount;
  @JsonKey(name: 'activity_count', defaultValue: 0)
  final int activityCount;

  DailySummary({
    required this.date,
    required this.totalFeedingAmount,
    required this.totalFeedingDurationMinutes,
    required this.feedingCount,
    required this.breastMilkCount,
    required this.formulaCount,
    required this.solidCount,
    required this.pumpingCount,
    required this.totalSleepDurationMinutes,
    required this.sleepCount,
    required this.diaperCount,
    required this.temperatureCount,
    required this.medicineCount,
    required this.activityCount,
  });

  factory DailySummary.fromJson(Map<String, dynamic> json) =>
      _$DailySummaryFromJson(json);
  Map<String, dynamic> toJson() => _$DailySummaryToJson(this);
  
  /// 총 수유량 (ml)
  double get totalFeedingAmountValue => double.tryParse(totalFeedingAmount) ?? 0.0;
}

/// 아이 기본 정보 모델 (대시보드용)
@JsonSerializable()
class BabyInfo {
  final int id;
  final String name;
  @JsonKey(name: 'birth_date')
  final String birthDate;
  @JsonKey(name: 'age_in_days')
  final int ageInDays;

  BabyInfo({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.ageInDays,
  });

  factory BabyInfo.fromJson(Map<String, dynamic> json) =>
      _$BabyInfoFromJson(json);
  Map<String, dynamic> toJson() => _$BabyInfoToJson(this);

  /// 나이 계산 (개월 수)
  int get ageInMonths => (ageInDays / 30).floor();

  /// 나이 표시 문자열
  String get ageString {
    final days = ageInDays;
    if (days < 30) {
      return '$days일';
    } else if (days < 365) {
      final months = (days / 30).floor();
      return '$months개월';
    } else {
      final years = (days / 365).floor();
      final remainingMonths = ((days % 365) / 30).floor();
      if (remainingMonths == 0) {
        return '$years세';
      }
      return '$years세 $remainingMonths개월';
    }
  }

  /// copyWith 메서드
  BabyInfo copyWith({
    int? id,
    String? name,
    String? birthDate,
    int? ageInDays,
  }) {
    return BabyInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      ageInDays: ageInDays ?? this.ageInDays,
    );
  }
}

/// 오늘의 요약 통계 모델 (하위 호환성)
@JsonSerializable()
class TodaySummary {
  @JsonKey(name: 'feeding_count', defaultValue: 0)
  final int feedingCount;
  @JsonKey(name: 'diaper_count', defaultValue: 0)
  final int diaperCount;
  @JsonKey(name: 'sleep_hours', defaultValue: 0.0)
  final double sleepHours;

  TodaySummary({
    required this.feedingCount,
    required this.diaperCount,
    required this.sleepHours,
  });

  factory TodaySummary.fromJson(Map<String, dynamic> json) =>
      _$TodaySummaryFromJson(json);
  Map<String, dynamic> toJson() => _$TodaySummaryToJson(this);

  /// 수면 시간 문자열 (시간:분)
  String get sleepHoursFormatted {
    final hours = sleepHours.floor();
    final minutes = ((sleepHours - hours) * 60).round();
    return '$hours시간 $minutes분';
  }

  /// copyWith 메서드
  TodaySummary copyWith({
    int? feedingCount,
    int? diaperCount,
    double? sleepHours,
  }) {
    return TodaySummary(
      feedingCount: feedingCount ?? this.feedingCount,
      diaperCount: diaperCount ?? this.diaperCount,
      sleepHours: sleepHours ?? this.sleepHours,
    );
  }
}

/// 주간 평균 통계 모델
@JsonSerializable()
class WeeklySummary {
  @JsonKey(name: 'avg_feeding_per_day')
  final double avgFeedingPerDay;
  @JsonKey(name: 'avg_diaper_per_day')
  final double avgDiaperPerDay;
  @JsonKey(name: 'avg_sleep_hours_per_day')
  final double avgSleepHoursPerDay;

  WeeklySummary({
    required this.avgFeedingPerDay,
    required this.avgDiaperPerDay,
    required this.avgSleepHoursPerDay,
  });

  factory WeeklySummary.fromJson(Map<String, dynamic> json) =>
      _$WeeklySummaryFromJson(json);
  Map<String, dynamic> toJson() => _$WeeklySummaryToJson(this);

  /// 평균 수면 시간 문자열 (시간:분)
  String get avgSleepHoursFormatted {
    final hours = avgSleepHoursPerDay.floor();
    final minutes = ((avgSleepHoursPerDay - hours) * 60).round();
    return '$hours시간 $minutes분';
  }

  /// copyWith 메서드
  WeeklySummary copyWith({
    double? avgFeedingPerDay,
    double? avgDiaperPerDay,
    double? avgSleepHoursPerDay,
  }) {
    return WeeklySummary(
      avgFeedingPerDay: avgFeedingPerDay ?? this.avgFeedingPerDay,
      avgDiaperPerDay: avgDiaperPerDay ?? this.avgDiaperPerDay,
      avgSleepHoursPerDay: avgSleepHoursPerDay ?? this.avgSleepHoursPerDay,
    );
  }
}

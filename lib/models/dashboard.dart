import 'package:json_annotation/json_annotation.dart';
import 'feeding_record.dart';
import 'care_record.dart';

part 'dashboard.g.dart';

/// 대시보드 메인 모델
@JsonSerializable()
class Dashboard {
  @JsonKey(name: 'baby_info')
  final BabyInfo babyInfo;
  @JsonKey(name: 'latest_feeding')
  final FeedingRecord? latestFeeding;
  @JsonKey(name: 'latest_diaper')
  final CareRecord? latestDiaper;
  @JsonKey(name: 'latest_sleep')
  final CareRecord? latestSleep;
  @JsonKey(name: 'today_summary')
  final TodaySummary todaySummary;
  @JsonKey(name: 'weekly_summary')
  final WeeklySummary weeklySummary;

  Dashboard({
    required this.babyInfo,
    this.latestFeeding,
    this.latestDiaper,
    this.latestSleep,
    required this.todaySummary,
    required this.weeklySummary,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) =>
      _$DashboardFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardToJson(this);

  /// copyWith 메서드
  Dashboard copyWith({
    BabyInfo? babyInfo,
    FeedingRecord? latestFeeding,
    CareRecord? latestDiaper,
    CareRecord? latestSleep,
    TodaySummary? todaySummary,
    WeeklySummary? weeklySummary,
  }) {
    return Dashboard(
      babyInfo: babyInfo ?? this.babyInfo,
      latestFeeding: latestFeeding ?? this.latestFeeding,
      latestDiaper: latestDiaper ?? this.latestDiaper,
      latestSleep: latestSleep ?? this.latestSleep,
      todaySummary: todaySummary ?? this.todaySummary,
      weeklySummary: weeklySummary ?? this.weeklySummary,
    );
  }
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

/// 오늘의 요약 통계 모델
@JsonSerializable()
class TodaySummary {
  @JsonKey(name: 'feeding_count')
  final int feedingCount;
  @JsonKey(name: 'diaper_count')
  final int diaperCount;
  @JsonKey(name: 'sleep_hours')
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

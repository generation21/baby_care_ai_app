// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dashboard _$DashboardFromJson(Map<String, dynamic> json) => Dashboard(
  babyInfo: BabyInfo.fromJson(json['baby_info'] as Map<String, dynamic>),
  latestFeeding: json['latest_feeding'] == null
      ? null
      : FeedingRecord.fromJson(json['latest_feeding'] as Map<String, dynamic>),
  latestDiaper: json['latest_diaper'] == null
      ? null
      : CareRecord.fromJson(json['latest_diaper'] as Map<String, dynamic>),
  latestSleep: json['latest_sleep'] == null
      ? null
      : CareRecord.fromJson(json['latest_sleep'] as Map<String, dynamic>),
  todaySummary: TodaySummary.fromJson(
    json['today_summary'] as Map<String, dynamic>,
  ),
  weeklySummary: WeeklySummary.fromJson(
    json['weekly_summary'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$DashboardToJson(Dashboard instance) => <String, dynamic>{
  'baby_info': instance.babyInfo,
  'latest_feeding': instance.latestFeeding,
  'latest_diaper': instance.latestDiaper,
  'latest_sleep': instance.latestSleep,
  'today_summary': instance.todaySummary,
  'weekly_summary': instance.weeklySummary,
};

BabyInfo _$BabyInfoFromJson(Map<String, dynamic> json) => BabyInfo(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  birthDate: json['birth_date'] as String,
  ageInDays: (json['age_in_days'] as num).toInt(),
);

Map<String, dynamic> _$BabyInfoToJson(BabyInfo instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'birth_date': instance.birthDate,
  'age_in_days': instance.ageInDays,
};

TodaySummary _$TodaySummaryFromJson(Map<String, dynamic> json) => TodaySummary(
  feedingCount: (json['feeding_count'] as num).toInt(),
  diaperCount: (json['diaper_count'] as num).toInt(),
  sleepHours: (json['sleep_hours'] as num).toDouble(),
);

Map<String, dynamic> _$TodaySummaryToJson(TodaySummary instance) =>
    <String, dynamic>{
      'feeding_count': instance.feedingCount,
      'diaper_count': instance.diaperCount,
      'sleep_hours': instance.sleepHours,
    };

WeeklySummary _$WeeklySummaryFromJson(Map<String, dynamic> json) =>
    WeeklySummary(
      avgFeedingPerDay: (json['avg_feeding_per_day'] as num).toDouble(),
      avgDiaperPerDay: (json['avg_diaper_per_day'] as num).toDouble(),
      avgSleepHoursPerDay: (json['avg_sleep_hours_per_day'] as num).toDouble(),
    );

Map<String, dynamic> _$WeeklySummaryToJson(WeeklySummary instance) =>
    <String, dynamic>{
      'avg_feeding_per_day': instance.avgFeedingPerDay,
      'avg_diaper_per_day': instance.avgDiaperPerDay,
      'avg_sleep_hours_per_day': instance.avgSleepHoursPerDay,
    };

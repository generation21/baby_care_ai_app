// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dashboard _$DashboardFromJson(Map<String, dynamic> json) => Dashboard(
  baby: BabyInfo.fromJson(json['baby'] as Map<String, dynamic>),
  lastRecords: LastRecords.fromJson(
    json['last_records'] as Map<String, dynamic>,
  ),
  activeFeedingTimer: ActiveFeedingTimerData.fromJson(
    json['active_feeding_timer'] as Map<String, dynamic>,
  ),
  dailySummary: DailySummary.fromJson(
    json['daily_summary'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$DashboardToJson(Dashboard instance) => <String, dynamic>{
  'baby': instance.baby,
  'last_records': instance.lastRecords,
  'active_feeding_timer': instance.activeFeedingTimer,
  'daily_summary': instance.dailySummary,
};

LastRecords _$LastRecordsFromJson(Map<String, dynamic> json) => LastRecords(
  breastMilk: json['breast_milk'] == null
      ? null
      : LastRecord.fromJson(json['breast_milk'] as Map<String, dynamic>),
  formula: json['formula'] == null
      ? null
      : LastRecord.fromJson(json['formula'] as Map<String, dynamic>),
  solid: json['solid'] == null
      ? null
      : LastRecord.fromJson(json['solid'] as Map<String, dynamic>),
  pumping: json['pumping'] == null
      ? null
      : LastRecord.fromJson(json['pumping'] as Map<String, dynamic>),
  sleep: json['sleep'] == null
      ? null
      : LastRecord.fromJson(json['sleep'] as Map<String, dynamic>),
  diaper: json['diaper'] == null
      ? null
      : LastRecord.fromJson(json['diaper'] as Map<String, dynamic>),
  temperature: json['temperature'] == null
      ? null
      : LastRecord.fromJson(json['temperature'] as Map<String, dynamic>),
  medicine: json['medicine'] == null
      ? null
      : LastRecord.fromJson(json['medicine'] as Map<String, dynamic>),
  activity: json['activity'] == null
      ? null
      : LastRecord.fromJson(json['activity'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LastRecordsToJson(LastRecords instance) =>
    <String, dynamic>{
      'breast_milk': instance.breastMilk,
      'formula': instance.formula,
      'solid': instance.solid,
      'pumping': instance.pumping,
      'sleep': instance.sleep,
      'diaper': instance.diaper,
      'temperature': instance.temperature,
      'medicine': instance.medicine,
      'activity': instance.activity,
    };

LastRecord _$LastRecordFromJson(Map<String, dynamic> json) => LastRecord(
  time: json['time'] as String?,
  relativeTime: json['relative_time'] as String,
  details: json['details'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$LastRecordToJson(LastRecord instance) =>
    <String, dynamic>{
      'time': instance.time,
      'relative_time': instance.relativeTime,
      'details': instance.details,
    };

ActiveFeedingTimerData _$ActiveFeedingTimerDataFromJson(
  Map<String, dynamic> json,
) => ActiveFeedingTimerData(
  isActive: json['is_active'] as bool,
  startTime: json['start_time'] as String?,
  currentSide: json['current_side'] as String?,
  leftDurationSeconds: (json['left_duration_seconds'] as num?)?.toInt(),
  rightDurationSeconds: (json['right_duration_seconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$ActiveFeedingTimerDataToJson(
  ActiveFeedingTimerData instance,
) => <String, dynamic>{
  'is_active': instance.isActive,
  'start_time': instance.startTime,
  'current_side': instance.currentSide,
  'left_duration_seconds': instance.leftDurationSeconds,
  'right_duration_seconds': instance.rightDurationSeconds,
};

DailySummary _$DailySummaryFromJson(Map<String, dynamic> json) => DailySummary(
  date: json['date'] as String,
  totalFeedingAmount: json['total_feeding_amount'] as String? ?? '0.0',
  totalFeedingDurationMinutes:
      (json['total_feeding_duration_minutes'] as num?)?.toInt() ?? 0,
  feedingCount: (json['feeding_count'] as num?)?.toInt() ?? 0,
  breastMilkCount: (json['breast_milk_count'] as num?)?.toInt() ?? 0,
  formulaCount: (json['formula_count'] as num?)?.toInt() ?? 0,
  solidCount: (json['solid_count'] as num?)?.toInt() ?? 0,
  pumpingCount: (json['pumping_count'] as num?)?.toInt() ?? 0,
  totalSleepDurationMinutes:
      (json['total_sleep_duration_minutes'] as num?)?.toInt() ?? 0,
  sleepCount: (json['sleep_count'] as num?)?.toInt() ?? 0,
  diaperCount: (json['diaper_count'] as num?)?.toInt() ?? 0,
  temperatureCount: (json['temperature_count'] as num?)?.toInt() ?? 0,
  medicineCount: (json['medicine_count'] as num?)?.toInt() ?? 0,
  activityCount: (json['activity_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$DailySummaryToJson(DailySummary instance) =>
    <String, dynamic>{
      'date': instance.date,
      'total_feeding_amount': instance.totalFeedingAmount,
      'total_feeding_duration_minutes': instance.totalFeedingDurationMinutes,
      'feeding_count': instance.feedingCount,
      'breast_milk_count': instance.breastMilkCount,
      'formula_count': instance.formulaCount,
      'solid_count': instance.solidCount,
      'pumping_count': instance.pumpingCount,
      'total_sleep_duration_minutes': instance.totalSleepDurationMinutes,
      'sleep_count': instance.sleepCount,
      'diaper_count': instance.diaperCount,
      'temperature_count': instance.temperatureCount,
      'medicine_count': instance.medicineCount,
      'activity_count': instance.activityCount,
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
  feedingCount: (json['feeding_count'] as num?)?.toInt() ?? 0,
  diaperCount: (json['diaper_count'] as num?)?.toInt() ?? 0,
  sleepHours: (json['sleep_hours'] as num?)?.toDouble() ?? 0.0,
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

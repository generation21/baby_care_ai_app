import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/care_record.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class CareRecordCard extends StatelessWidget {
  final CareRecord record;
  final VoidCallback onTap;

  const CareRecordCard({
    super.key,
    required this.record,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final parsedDateTime = DateTime.tryParse(record.recordedAt);
    final recordedTimeLabel = parsedDateTime == null
        ? record.recordedAt
        : DateFormat('yyyy.MM.dd HH:mm').format(parsedDateTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary50,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        record.recordType.displayName,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      recordedTimeLabel,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _summaryText(record),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                if (record.notes != null && record.notes!.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    record.notes!.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _summaryText(CareRecord careRecord) {
    switch (careRecord.recordType) {
      case CareRecordType.diaper:
        return careRecord.diaperType?.displayName ?? '기저귀 기록';
      case CareRecordType.sleep:
        final durationMinutes = careRecord.sleepDurationMinutes;
        if (durationMinutes != null) {
          final hours = durationMinutes ~/ 60;
          final minutes = durationMinutes % 60;
          if (hours > 0) {
            return '수면 시간 $hours시간 $minutes분';
          }
          return '수면 시간 $minutes분';
        }
        return '수면 기록';
      case CareRecordType.temperature:
        if (careRecord.temperature != null) {
          final unit = careRecord.temperatureUnit ?? 'C';
          return '체온 ${careRecord.temperature}°$unit';
        }
        return '체온 기록';
      case CareRecordType.medicine:
        final medicineName = careRecord.medicineName;
        final medicineDosage = careRecord.medicineDosage;
        if (medicineName != null && medicineDosage != null) {
          return '$medicineName ($medicineDosage)';
        }
        if (medicineName != null) {
          return medicineName;
        }
        return '약물 기록';
      case CareRecordType.bath:
        return '목욕 기록';
      case CareRecordType.other:
        return '기타 기록';
    }
  }
}

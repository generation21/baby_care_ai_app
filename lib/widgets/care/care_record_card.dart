import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/l10n.dart';
import '../../models/care_record.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class CareRecordCard extends StatelessWidget {
  final CareRecord record;
  final VoidCallback onTap;

  const CareRecordCard({super.key, required this.record, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final parsedDateTime = DateTime.tryParse(record.recordedAt);
    final recordedTimeLabel = parsedDateTime == null
        ? record.recordedAt
        : DateFormat.yMd(localeName).add_Hm().format(parsedDateTime);

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
                  _summaryText(context, record),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                if (record.notes != null &&
                    record.notes!.trim().isNotEmpty) ...[
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

  String _summaryText(BuildContext context, CareRecord careRecord) {
    final l10n = context.l10n;
    switch (careRecord.recordType) {
      case CareRecordType.diaper:
        return careRecord.diaperType?.displayName ?? l10n.diaperRecordSummary;
      case CareRecordType.sleep:
        final durationMinutes = careRecord.sleepDurationMinutes;
        if (durationMinutes != null) {
          final hours = durationMinutes ~/ 60;
          final minutes = durationMinutes % 60;
          return l10n.sleepDurationSummary(hours, minutes);
        }
        return l10n.sleepRecordSummary;
      case CareRecordType.temperature:
        if (careRecord.temperature != null) {
          final unit = careRecord.temperatureUnit ?? 'C';
          return l10n.temperatureValueSummary(
            careRecord.temperature.toString(),
            unit,
          );
        }
        return l10n.temperatureRecordSummary;
      case CareRecordType.medicine:
        final medicineName = careRecord.medicineName;
        final medicineDosage = careRecord.medicineDosage;
        if (medicineName != null && medicineDosage != null) {
          return '$medicineName ($medicineDosage)';
        }
        if (medicineName != null) {
          return medicineName;
        }
        return l10n.medicineRecordSummary;
      case CareRecordType.bath:
        return l10n.bathRecordSummary;
      case CareRecordType.other:
        return l10n.otherRecordSummary;
    }
  }
}

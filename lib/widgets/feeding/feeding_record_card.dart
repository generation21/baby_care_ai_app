import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../../models/feeding_record.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class FeedingRecordCard extends StatelessWidget {
  static const double _cardRadius = 16;
  static const EdgeInsets _cardPadding = EdgeInsets.all(16);
  static const EdgeInsets _cardMargin = EdgeInsets.only(bottom: 12);

  final FeedingRecord record;
  final VoidCallback onTap;

  const FeedingRecordCard({
    super.key,
    required this.record,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final dateTime = DateTime.tryParse(record.recordedAt);
    final timeText = dateTime == null
        ? record.recordedAt
        : DateFormat.yMd(localeName).add_Hm().format(dateTime);

    return Container(
      margin: _cardMargin,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_cardRadius),
          onTap: onTap,
          child: Padding(
            padding: _cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildTypeBadge(),
                    const Spacer(),
                    Text(
                      timeText,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    if (record.amount != null)
                      _buildMetaText(
                        l10n.feedingAmountLabel,
                        '${record.amount}${record.unit ?? ''}',
                      ),
                    if (record.durationMinutes != null)
                      _buildMetaText(
                        l10n.feedingDurationLabel,
                        l10n.minutesLabel(record.durationMinutes!),
                      ),
                    if (record.side != null)
                      _buildMetaText(
                        l10n.feedingSideLabel,
                        _sideDisplayName(record.side!, l10n),
                      ),
                  ],
                ),
                if (record.notes != null &&
                    record.notes!.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    record.notes!.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
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

  Widget _buildTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        record.feedingType.displayName,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMetaText(String label, String value) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
            text: value,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _sideDisplayName(String side, AppLocalizations l10n) {
    switch (side) {
      case 'left':
        return l10n.sideLeft;
      case 'right':
        return l10n.sideRight;
      case 'both':
        return l10n.sideBoth;
      default:
        return side;
    }
  }
}

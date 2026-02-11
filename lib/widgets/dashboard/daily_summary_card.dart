import 'package:flutter/material.dart';
import '../../models/dashboard.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// 일별 통계 요약 카드 위젯
/// 
/// 오늘의 수유, 기저귀, 수면 통계를 한눈에 보여줍니다.
class DailySummaryCard extends StatelessWidget {
  final TodaySummary todaySummary;
  final int? totalFeedingAmount;

  const DailySummaryCard({
    super.key,
    required this.todaySummary,
    this.totalFeedingAmount,
  });

  @override
  Widget build(BuildContext context) {
    final sleepHours = todaySummary.sleepHours.floor();
    final sleepMinutes = ((todaySummary.sleepHours - sleepHours) * 60).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.today,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '오늘의 요약',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 통계 항목들
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  icon: Icons.restaurant,
                  label: '수유',
                  value: '${todaySummary.feedingCount}회',
                  sublabel: totalFeedingAmount != null ? '${totalFeedingAmount}ml' : null,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.nightlight_round,
                  label: '수면',
                  value: sleepHours > 0 ? '$sleepHours시간' : '$sleepMinutes분',
                  sublabel: sleepHours > 0 && sleepMinutes > 0 ? '$sleepMinutes분' : null,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  icon: Icons.child_care,
                  label: '기저귀',
                  value: '${todaySummary.diaperCount}회',
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(), // 공간 균형을 위한 빈 컨테이너
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? sublabel;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    this.sublabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (sublabel != null) ...[
            const SizedBox(height: 2),
            Text(
              sublabel!,
              style: AppTextStyles.bodySmall.copyWith(
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

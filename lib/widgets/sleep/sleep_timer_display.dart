import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class SleepTimerDisplay extends StatelessWidget {
  final bool isSleeping;
  final DateTime? sleepStartTime;
  final Duration elapsedDuration;

  const SleepTimerDisplay({
    super.key,
    required this.isSleeping,
    required this.sleepStartTime,
    required this.elapsedDuration,
  });

  @override
  Widget build(BuildContext context) {
    final hours = elapsedDuration.inHours;
    final minutes = elapsedDuration.inMinutes % 60;
    final seconds = elapsedDuration.inSeconds % 60;
    final durationLabel =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Icon(
            Icons.bedtime,
            size: 56,
            color: isSleeping ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            isSleeping ? '수면 진행 중' : '수면 대기 중',
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            durationLabel,
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (sleepStartTime != null) ...[
            const SizedBox(height: 8),
            Text(
              '시작: ${sleepStartTime!.year}-${sleepStartTime!.month.toString().padLeft(2, '0')}-${sleepStartTime!.day.toString().padLeft(2, '0')} ${sleepStartTime!.hour.toString().padLeft(2, '0')}:${sleepStartTime!.minute.toString().padLeft(2, '0')}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

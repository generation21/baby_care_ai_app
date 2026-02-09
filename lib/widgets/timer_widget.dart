import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class TimerWidget extends StatelessWidget {
  final bool isActive;
  final String leftTime;
  final String rightTime;
  final String currentSide;

  const TimerWidget({
    super.key,
    required this.isActive,
    required this.leftTime,
    required this.rightTime,
    required this.currentSide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _TimerSide(
                  label: 'Left',
                  time: leftTime,
                  isActive: currentSide == 'left',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _TimerSide(
                  label: 'Right',
                  time: rightTime,
                  isActive: currentSide == 'right',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.pause, size: 18),
                  label: const Text('Pause'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Complete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerSide extends StatelessWidget {
  final String label;
  final String time;
  final bool isActive;

  const _TimerSide({
    required this.label,
    required this.time,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary50 : AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.border,
          width: isActive ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.captionSmall.copyWith(
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: AppTextStyles.headline1.copyWith(
              color: isActive ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

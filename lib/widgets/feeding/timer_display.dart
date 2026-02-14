import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// 타이머 시간 표시 위젯
/// 
/// 분:초 형식으로 경과 시간을 표시합니다.
class TimerDisplay extends StatelessWidget {
  final int elapsedSeconds;
  final bool isRunning;

  const TimerDisplay({
    super.key,
    required this.elapsedSeconds,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = elapsedSeconds ~/ 60;
    final seconds = elapsedSeconds % 60;
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');

    return Column(
      children: [
        // 타이머 아이콘
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: isRunning 
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.timer,
            size: 60,
            color: isRunning ? AppColors.primary : Colors.grey,
          ),
        ),
        
        const SizedBox(height: 32),
        
        // 시간 표시
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 분
            _TimeUnit(
              value: minutesStr,
              label: '분',
            ),
            
            // 구분자
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                ':',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.0,
                ),
              ),
            ),
            
            // 초
            _TimeUnit(
              value: secondsStr,
              label: '초',
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 상태 표시
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isRunning 
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isRunning ? Icons.play_circle_filled : Icons.pause_circle_filled,
                size: 16,
                color: isRunning ? AppColors.primary : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                isRunning ? '진행 중' : '일시정지',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isRunning ? AppColors.primary : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 시간 단위 표시 위젯 (분 또는 초)
class _TimeUnit extends StatelessWidget {
  final String value;
  final String label;

  const _TimeUnit({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.0,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/time_utils.dart';

/// 진행 중인 수유 타이머 위젯
/// 
/// 현재 진행 중인 수유를 실시간으로 표시합니다.
class ActiveFeedingTimer extends StatefulWidget {
  final int babyId;
  final DateTime? startTime;
  final String? currentSide; // 'left' or 'right'
  final int? leftDurationSeconds;
  final int? rightDurationSeconds;
  final VoidCallback? onStop;
  final VoidCallback? onSwitchSide;

  const ActiveFeedingTimer({
    super.key,
    required this.babyId,
    this.startTime,
    this.currentSide,
    this.leftDurationSeconds,
    this.rightDurationSeconds,
    this.onStop,
    this.onSwitchSide,
  });

  @override
  State<ActiveFeedingTimer> createState() => _ActiveFeedingTimerState();
}

class _ActiveFeedingTimerState extends State<ActiveFeedingTimer> {
  Timer? _timer;
  int _currentElapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    if (widget.startTime != null) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _updateElapsedTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _updateElapsedTime();
      }
    });
  }

  void _updateElapsedTime() {
    if (widget.startTime != null) {
      setState(() {
        _currentElapsedSeconds = DateTime.now().difference(widget.startTime!).inSeconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 진행 중인 수유가 없는 경우
    if (widget.startTime == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Icon(
              Icons.timer_off_outlined,
              size: 48,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 12),
            Text(
              '진행 중인 수유가 없습니다',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                context.push('/feeding-timer/${widget.babyId}');
              },
              icon: const Icon(Icons.timer, size: 18),
              label: const Text('타이머 시작'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final leftDuration = widget.leftDurationSeconds ?? 0;
    final rightDuration = widget.rightDurationSeconds ?? 0;
    final totalDuration = leftDuration + rightDuration + _currentElapsedSeconds;
    final currentSide = widget.currentSide ?? 'left';
    final isLeft = currentSide == 'left';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.info.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.timer,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '수유 진행 중',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                TimeUtils.formatDuration(totalDuration),
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 좌우 타이머
          Row(
            children: [
              Expanded(
                child: _SideTimer(
                  side: '왼쪽',
                  duration: leftDuration,
                  isActive: isLeft,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SideTimer(
                  side: '오른쪽',
                  duration: rightDuration,
                  isActive: !isLeft,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 버튼 - 타이머 화면으로 이동
          ElevatedButton.icon(
            onPressed: () {
              context.push('/feeding-timer/${widget.babyId}');
            },
            icon: const Icon(Icons.fullscreen, size: 18),
            label: const Text('타이머 열기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideTimer extends StatelessWidget {
  final String side;
  final int duration;
  final bool isActive;

  const _SideTimer({
    required this.side,
    required this.duration,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive 
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive 
              ? AppColors.primary
              : AppColors.borderLight,
          width: isActive ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isActive)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                side,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isActive 
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            TimeUtils.formatDuration(duration),
            style: AppTextStyles.headlineSmall.copyWith(
              color: isActive 
                  ? AppColors.primary
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

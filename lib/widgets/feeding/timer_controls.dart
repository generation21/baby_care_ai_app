import 'package:flutter/material.dart';
import '../../states/timer_state.dart';
import '../../theme/app_colors.dart';

/// 타이머 컨트롤 버튼 위젯
/// 
/// 시작/일시정지/전환/완료 버튼을 제공합니다.
class TimerControls extends StatelessWidget {
  final TimerState timerState;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback? onSwitch;
  final VoidCallback onComplete;

  const TimerControls({
    super.key,
    required this.timerState,
    required this.onPause,
    required this.onResume,
    this.onSwitch,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 일시정지/재개 버튼
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: timerState.isRunning ? onPause : onResume,
            icon: Icon(
              timerState.isRunning ? Icons.pause : Icons.play_arrow,
              size: 24,
            ),
            label: Text(
              timerState.isRunning ? '일시정지' : '재개',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: timerState.isRunning 
                  ? Colors.orange 
                  : AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        Row(
          children: [
            // 좌우 전환 버튼 (모유 수유일 경우에만)
            if (onSwitch != null)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onSwitch,
                  icon: const Icon(Icons.swap_horiz, size: 20),
                  label: const Text(
                    '좌우 전환',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            
            if (onSwitch != null) const SizedBox(width: 12),
            
            // 완료 버튼
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onComplete,
                icon: const Icon(Icons.check, size: 20),
                label: const Text(
                  '완료',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

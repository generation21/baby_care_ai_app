import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/feeding_record.dart';
import '../../states/timer_state.dart';
import '../../states/dashboard_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/feeding/timer_display.dart';
import '../../widgets/feeding/breast_side_selector.dart';
import '../../widgets/feeding/timer_controls.dart';

/// 수유 타이머 전체 화면
/// 
/// 진행 중인 수유 타이머를 실시간으로 추적하고 관리합니다.
class FeedingTimerScreen extends StatefulWidget {
  final int babyId;

  const FeedingTimerScreen({
    super.key,
    required this.babyId,
  });

  @override
  State<FeedingTimerScreen> createState() => _FeedingTimerScreenState();
}

class _FeedingTimerScreenState extends State<FeedingTimerScreen> {
  @override
  void initState() {
    super.initState();
    // 빌드 완료 후 타이머 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      final timerState = context.read<TimerState>();
      // 타이머가 아직 시작되지 않았다면 기본값으로 시작
      if (!timerState.isActive) {
        timerState.startTimer(
          feedingType: FeedingType.breastMilk,
          side: 'left',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('수유 타이머'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _showCancelDialog,
            tooltip: '타이머 취소',
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<TimerState>(
          builder: (context, timerState, child) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        
                        // 타이머 표시
                        TimerDisplay(
                          elapsedSeconds: timerState.elapsedSeconds,
                          isRunning: timerState.isRunning,
                        ),
                        
                        const SizedBox(height: 60),
                        
                        // 좌/우 유방 선택 (모유 수유일 경우에만)
                        if (timerState.feedingType == FeedingType.breastMilk)
                          BreastSideSelector(
                            currentSide: timerState.side,
                            onSideChanged: (side) {
                              timerState.switchSide();
                            },
                          ),
                        
                        const SizedBox(height: 40),
                        
                        // 통계 정보
                        _buildStatistics(timerState),
                      ],
                    ),
                  ),
                ),
                
                // 타이머 컨트롤
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: TimerControls(
                    timerState: timerState,
                    onPause: () => timerState.pauseTimer(),
                    onResume: () => timerState.resumeTimer(),
                    onSwitch: () => timerState.switchSide(),
                    onComplete: () => _handleComplete(timerState),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 통계 정보 위젯
  Widget _buildStatistics(TimerState timerState) {
    final minutes = timerState.elapsedSeconds ~/ 60;
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Text(
            '경과 시간',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          if (hours > 0)
            Text(
              '$hours시간 $remainingMinutes분',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            )
          else
            Text(
              '$minutes분',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          
          if (timerState.side != null) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  timerState.side == 'left' 
                      ? Icons.arrow_back 
                      : Icons.arrow_forward,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  timerState.side == 'left' ? '왼쪽 유방' : '오른쪽 유방',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// 타이머 완료 처리
  Future<void> _handleComplete(TimerState timerState) async {
    try {
      await timerState.completeTimer(widget.babyId);
      
      // 대시보드 새로고침
      if (mounted) {
        context.read<DashboardState>().loadDashboard(widget.babyId);
      }
      
      // 성공 메시지 표시 후 화면 닫기
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('수유 기록이 저장되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('타이머 완료 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 타이머 취소 확인 다이얼로그
  Future<void> _showCancelDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('타이머 취소'),
        content: const Text('진행 중인 타이머를 취소하시겠습니까?\n기록은 저장되지 않습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('계속하기'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('취소하기'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      context.read<TimerState>().cancelTimer();
      Navigator.pop(context);
    }
  }
}

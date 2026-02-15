import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/care_record.dart';
import '../../states/care_state.dart';
import '../../states/dashboard_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/sleep/sleep_controls.dart';
import '../../widgets/sleep/sleep_timer_display.dart';

class SleepTrackerScreen extends StatefulWidget {
  final int babyId;

  const SleepTrackerScreen({
    super.key,
    required this.babyId,
  });

  @override
  State<SleepTrackerScreen> createState() => _SleepTrackerScreenState();
}

class _SleepTrackerScreenState extends State<SleepTrackerScreen> {
  Timer? _ticker;
  bool _isLoading = true;
  bool _isProcessing = false;
  CareRecord? _activeSleepRecord;
  Duration _elapsedDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeTracker();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _initializeTracker() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<CareState>().loadRecords(
            widget.babyId,
            recordType: 'sleep',
          );
      _syncActiveSleepRecord();
    } catch (_) {
      // 에러는 상태에서 관리
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _syncActiveSleepRecord() {
    final careState = context.read<CareState>();
    _activeSleepRecord = careState.activeSleepRecord;
    _startOrStopTicker();
    _refreshElapsedDuration();
  }

  void _startOrStopTicker() {
    _ticker?.cancel();
    if (_activeSleepRecord == null) {
      return;
    }

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      setState(_refreshElapsedDuration);
    });
  }

  void _refreshElapsedDuration() {
    final activeRecord = _activeSleepRecord;
    if (activeRecord?.sleepStart == null) {
      _elapsedDuration = Duration.zero;
      return;
    }

    final parsedStartTime = DateTime.tryParse(activeRecord!.sleepStart!);
    if (parsedStartTime == null) {
      _elapsedDuration = Duration.zero;
      return;
    }

    final now = DateTime.now();
    final diff = now.difference(parsedStartTime);
    _elapsedDuration = diff.isNegative ? Duration.zero : diff;
  }

  Future<void> _handleStartSleep() async {
    if (_isProcessing) {
      return;
    }
    setState(() {
      _isProcessing = true;
    });

    try {
      final startedRecord = await context.read<CareState>().startSleepRecord(
            widget.babyId,
          );
      _activeSleepRecord = startedRecord;
      _startOrStopTicker();
      _refreshElapsedDuration();

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('수면 기록을 시작했습니다.')),
      );
      await context.read<DashboardState>().refreshDashboard(widget.babyId);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('수면 시작에 실패했습니다: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _handleStopSleep() async {
    final activeRecord = _activeSleepRecord;
    if (_isProcessing || activeRecord == null) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final completedRecord = await context.read<CareState>().endSleepRecord(
            widget.babyId,
            recordId: activeRecord.id,
          );
      final durationMinutes = completedRecord.sleepDurationMinutes ?? 0;
      _activeSleepRecord = null;
      _elapsedDuration = Duration.zero;
      _ticker?.cancel();

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('수면 종료 완료 ($durationMinutes분)')),
      );
      await context.read<DashboardState>().refreshDashboard(widget.babyId);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('수면 종료에 실패했습니다: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final startTime = DateTime.tryParse(_activeSleepRecord?.sleepStart ?? '');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(
              title: '수면 추적',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              actions: [
                IconButton(
                  tooltip: '수면 기록 목록',
                  onPressed: () => context.push('/care/${widget.babyId}?type=sleep'),
                  icon: const Icon(Icons.list_alt),
                ),
              ],
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SleepTimerDisplay(
                            isSleeping: _activeSleepRecord != null,
                            sleepStartTime: startTime,
                            elapsedDuration: _elapsedDuration,
                          ),
                          const SizedBox(height: 16),
                          SleepControls(
                            isSleeping: _activeSleepRecord != null,
                            isProcessing: _isProcessing,
                            onStart: _handleStartSleep,
                            onStop: _handleStopSleep,
                          ),
                          const SizedBox(height: 16),
                          _buildGuideText(),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideText() {
    final isSleeping = _activeSleepRecord != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Text(
        isSleeping
            ? '수면이 진행 중입니다. 깨어나면 수면 종료 버튼을 눌러 기록을 완료하세요.'
            : '수면 시작 버튼을 누르면 즉시 수면 기록이 시작됩니다.',
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}

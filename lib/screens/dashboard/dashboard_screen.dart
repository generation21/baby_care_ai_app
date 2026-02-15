import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/care_record.dart';
import '../../models/dashboard.dart';
import '../../states/care_state.dart';
import '../../states/dashboard_state.dart';
import '../../states/baby_state.dart';
import '../../states/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/bottom_navigation_widget.dart';
import '../../widgets/dashboard/baby_info_card.dart';
import '../../widgets/dashboard/daily_summary_card.dart';
import '../../widgets/dashboard/active_feeding_timer.dart';
import '../../widgets/dashboard/last_records_section.dart';
import '../../widgets/dashboard/quick_add_button.dart';

/// 통합 대시보드 화면
///
/// 모든 육아 활동의 최신 상태를 한 번에 표시하고
/// 빠른 기록 추가 기능을 제공합니다.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedNavIndex = 0;
  Dashboard? _dashboard;
  CareRecord? _activeSleepRecord;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboard();
    });
  }

  /// 대시보드 데이터 로딩
  Future<void> _loadDashboard() async {
    if (!mounted) return;

    final authState = context.read<AuthState>();
    if (!authState.isAuthenticated) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 먼저 아기 목록 로드
      final babyState = context.read<BabyState>();
      final dashboardState = context.read<DashboardState>();
      final careState = context.read<CareState>();
      await babyState.loadBabies();

      // 아기가 없으면 빈 상태로 표시
      if (babyState.babies.isEmpty) {
        if (mounted) {
          setState(() {
            _dashboard = null;
            _isLoading = false;
          });
        }
        return;
      }

      // 첫 번째 아기의 대시보드 로드
      final firstBaby = babyState.babies.first;
      await dashboardState.loadDashboard(firstBaby.id);
      await careState.loadRecords(
        firstBaby.id,
        recordType: 'sleep',
      );

      if (mounted) {
        setState(() {
          _dashboard = dashboardState.dashboard;
          _activeSleepRecord = careState.activeSleepRecord;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  /// Pull to Refresh
  Future<void> _onRefresh() async {
    await _loadDashboard();
  }

  /// 네비게이션 탭
  void _onNavigationTap(int index) {
    setState(() {
      _selectedNavIndex = index;
    });

      switch (index) {
      case 0: // Home
        break;
      case 1: // Records
        if (mounted) {
          final currentBabyId = _dashboard?.babyInfo.id;
          if (currentBabyId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('먼저 아이를 등록해주세요')),
            );
          } else {
            context.push('/feeding/$currentBabyId');
          }
        }
        break;
      case 2: // AI Chat
        if (mounted) {
          context.push('/ai-chat');
        }
        break;
      case 3: // Settings
        if (mounted) {
          context.push('/settings');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 앱 바
            AppBarWidget(
              title: 'Baby Care',
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_outline),
                  onPressed: () => context.push('/babies'),
                  tooltip: '아기 목록',
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    await context.push('/add-child');
                    _loadDashboard();
                  },
                  tooltip: '아기 추가',
                ),
              ],
            ),
            // 메인 콘텐츠
            Expanded(
              child: _buildContent(),
            ),
            // 하단 네비게이션
            BottomNavigationWidget(
              currentIndex: _selectedNavIndex,
              onTap: _onNavigationTap,
            ),
          ],
        ),
      ),
      // 빠른 추가 버튼
      floatingActionButton: _isLoading || _dashboard == null
          ? null
          : QuickAddButton(
              babyId: _dashboard!.babyInfo.id,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildContent() {
    // 로딩 상태
    if (_isLoading) {
      return _buildLoadingState();
    }

    // 에러 상태
    if (_errorMessage != null) {
      return _buildErrorState();
    }

    // 데이터 없음 (아기 미등록)
    if (_dashboard == null) {
      return _buildEmptyState();
    }

    // 정상 상태 - Pull to Refresh 적용
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아기 정보 카드
            BabyInfoCard(
              babyInfo: _dashboard!.babyInfo,
              onTap: () => context.push('/baby/${_dashboard!.babyInfo.id}'),
            ),
            const SizedBox(height: 24),

            // 일별 통계 요약
            DailySummaryCard(
              todaySummary: _dashboard!.todaySummary,
              totalFeedingAmount: _dashboard!.dailySummary.totalFeedingAmountValue.toInt(),
            ),
            const SizedBox(height: 24),

            // 진행 중인 수유 타이머
            Text(
              '진행 중인 활동',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            ActiveFeedingTimer(
              babyId: _dashboard!.babyInfo.id,
              startTime: _dashboard!.activeFeedingTimer.isActive && 
                         _dashboard!.activeFeedingTimer.startTime != null
                  ? DateTime.parse(_dashboard!.activeFeedingTimer.startTime!)
                  : null,
              currentSide: _dashboard!.activeFeedingTimer.currentSide,
              leftDurationSeconds: _dashboard!.activeFeedingTimer.leftDurationSeconds,
              rightDurationSeconds: _dashboard!.activeFeedingTimer.rightDurationSeconds,
            ),
            const SizedBox(height: 12),
            _buildActiveSleepStatusCard(_dashboard!.babyInfo.id),
            const SizedBox(height: 24),

            // 최근 기록
            Text(
              '최근 기록',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            LastRecordsSection(
              lastRecords: _dashboard!.lastRecords,
              onTapFeeding: () {
                context.push('/feeding/${_dashboard!.babyInfo.id}');
              },
              onTapDiaper: () {
                context.push('/care/${_dashboard!.babyInfo.id}?type=diaper');
              },
              onTapSleep: () {
                context.push('/sleep/${_dashboard!.babyInfo.id}');
              },
            ),
            const SizedBox(height: 80), // 하단 여백 (FAB 고려)
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSleepStatusCard(int babyId) {
    final activeSleepRecord = _activeSleepRecord;
    final sleepStartTime = DateTime.tryParse(activeSleepRecord?.sleepStart ?? '');
    final elapsedMinutes = sleepStartTime == null
        ? null
        : DateTime.now().difference(sleepStartTime).inMinutes;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '수면 상태',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            activeSleepRecord == null
                ? '현재 진행 중인 수면이 없습니다'
                : '수면 진행 중 (${elapsedMinutes ?? 0}분 경과)',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await context.push('/sleep/$babyId');
                if (mounted) {
                  _loadDashboard();
                }
              },
              icon: Icon(activeSleepRecord == null ? Icons.play_arrow : Icons.bedtime),
              label: Text(activeSleepRecord == null ? '수면 시작하기' : '수면 추적 보기'),
            ),
          ),
        ],
      ),
    );
  }

  /// 로딩 상태 UI
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            '대시보드를 불러오는 중...',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 에러 상태 UI
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              '데이터를 불러오는데 실패했습니다',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? '알 수 없는 오류가 발생했습니다',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadDashboard,
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 빈 상태 UI (아기 미등록)
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.child_care,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              '등록된 아기가 없습니다',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '아기를 추가하면 대시보드에\n기록이 표시됩니다',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                await context.push('/add-child');
                _loadDashboard();
              },
              icon: const Icon(Icons.add),
              label: const Text('아기 등록하기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/baby_profile_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/timer_widget.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/record_list_item.dart';
import '../states/auth_state.dart';
import 'add_feeding_screen.dart';
import 'ai_chat_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic>? _dashboardData;
  List<Map<String, dynamic>> _babies = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDashboard());
  }

  Future<void> _loadDashboard() async {
    if (!mounted) return;
    final authState = context.read<AuthState>();
    if (!authState.isAuthenticated) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final babies = await authState.babyCareApi.getBabies();
      if (!mounted) return;

      if (babies.isEmpty) {
        setState(() {
          _babies = [];
          _dashboardData = null;
          _isLoading = false;
        });
        return;
      }

      final firstBaby = babies.first;
      final babyId = firstBaby['id'] as int;
      final dashboard = await authState.babyCareApi.getDashboard(babyId);

      if (mounted) {
        setState(() {
          _babies = babies;
          _dashboardData = dashboard;
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

  void _onNavigationTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    if (index == 2) { // AI Chat
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AIChatScreen()),
      );
    }
  }


  String _formatAge(Map<String, dynamic>? baby) {
    if (baby == null) return '-';
    final months = baby['age_in_months'] as int? ?? 0;
    final days = baby['age_in_days'] as int? ?? 0;
    final dayOfMonth = days % 30;
    if (months > 0) {
      return dayOfMonth > 0 ? '$months개월 $dayOfMonth일' : '$months개월';
    }
    return '$days일';
  }

  /// 안전한 숫자 파싱 (문자열 또는 숫자를 double로 변환)
  double _parseNumeric(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  /// 안전한 정수 파싱 (문자열 또는 숫자를 int로 변환)
  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(
              title: 'Baby Care',
              actions: [
                IconButton(
                  icon: const Icon(Icons.add, color: AppColors.textPrimary),
                  onPressed: () async {
                    await context.push('/add-child');
                    _loadDashboard();
                  },
                  tooltip: '아이 추가',
                ),
              ],
            ),
            Expanded(
              child: _buildContent(),
            ),
            BottomNavigationWidget(
              currentIndex: _selectedIndex,
              onTap: _onNavigationTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!, style: AppTextStyles.body1),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadDashboard,
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    final baby = _dashboardData?['baby'] as Map<String, dynamic>?;
    final dailySummary = _dashboardData?['daily_summary'] as Map<String, dynamic>?;
    final lastRecords = _dashboardData?['last_records'] as Map<String, dynamic>? ?? {};
    final activeTimer = _dashboardData?['active_feeding_timer'] as Map<String, dynamic>?;
    final babyName = baby?['name'] as String? ?? '아이';
    final babyAge = _formatAge(baby);
    final feedingCount = _parseInt(dailySummary?['feeding_count']);
    final feedingAmount = _parseNumeric(dailySummary?['total_feeding_amount']);
    final sleepDurationMin = _parseInt(dailySummary?['total_sleep_duration_minutes']);
    final sleepNapCount = _parseInt(dailySummary?['sleep_count']);
    final diaperCount = _parseInt(dailySummary?['diaper_count']);
    final lastDiaper = lastRecords['diaper'] as Map<String, dynamic>?;
    final lastDiaperTime = lastDiaper?['relative_time'] as String? ?? '-';

    if (_babies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.child_care, size: 64, color: AppColors.textSecondary),
              const SizedBox(height: 16),
              Text('등록된 아이가 없습니다', style: AppTextStyles.headline6),
              const SizedBox(height: 8),
              Text(
                '아이를 추가하면 대시보드에 기록이 표시됩니다.',
                style: AppTextStyles.body2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await context.push('/add-child');
                  _loadDashboard();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '아이 등록하기',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BabyProfileHeader(babyName: babyName, babyAge: babyAge),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Today\'s Summary', style: AppTextStyles.headline6),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.restaurant,
                        label: 'Feeding',
                        value: '$feedingCount times',
                        sublabel: '${feedingAmount.toInt()}ml',
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.nightlight_round,
                        label: 'Sleep',
                        value: '${sleepDurationMin ~/ 60}h ${sleepDurationMin % 60}m',
                        sublabel: '$sleepNapCount naps',
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.child_care,
                        label: 'Diaper',
                        value: '$diaperCount times',
                        sublabel: lastDiaperTime,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.thermostat,
                        label: 'Temperature',
                        value: '-',
                        sublabel: '-',
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
                    
                    const SizedBox(height: 24),
                    
                    // Quick Actions Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quick Actions', style: AppTextStyles.headline6),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              QuickActionButton(
                                icon: Icons.restaurant,
                                label: 'Feeding',
                                color: AppColors.primary,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const AddFeedingScreen(),
                                    ),
                                  );
                                },
                              ),
                              QuickActionButton(
                                icon: Icons.nightlight_round,
                                label: 'Sleep',
                                color: AppColors.info,
                                onTap: () {},
                              ),
                              QuickActionButton(
                                icon: Icons.child_care,
                                label: 'Diaper',
                                color: AppColors.accent,
                                onTap: () {},
                              ),
                              QuickActionButton(
                                icon: Icons.favorite,
                                label: 'Health',
                                color: AppColors.error,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Active Timer', style: AppTextStyles.headline6),
                const SizedBox(height: 12),
                TimerWidget(
                  isActive: activeTimer != null,
                  leftTime: _formatDuration(activeTimer?['left_duration_seconds']),
                  rightTime: _formatDuration(activeTimer?['right_duration_seconds']),
                  currentSide: activeTimer?['current_side'] ?? 'left',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent History', style: AppTextStyles.headline6),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: _buildRecentHistory(lastRecords),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(dynamic val) {
    if (val == null) return '00:00';
    final sec = val is int ? val : int.tryParse(val.toString()) ?? 0;
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _formatRecordDetails(Map<String, dynamic>? r, String type) {
    if (r == null) return '';
    final details = r['details'];
    if (details is! Map) return r['record_type']?.toString() ?? '';
    if (type == 'breast_milk' || type == 'formula') {
      final amount = details['amount'];
      final duration = details['duration_minutes'];
      final side = details['side'];
      final parts = <String>[];
      if (amount != null) parts.add('${amount}ml');
      if (duration != null) parts.add('${duration}min');
      if (side != null) parts.add(side.toString());
      return parts.join(' - ');
    }
    if (type == 'diaper') return details['diaper_type']?.toString() ?? '';
    if (type == 'sleep') {
      final min = details['sleep_duration_minutes'];
      return min != null ? '$min minutes' : '';
    }
    return '';
  }

  Widget _buildRecentHistory(Map<String, dynamic> lastRecords) {
    final items = <Widget>[];
    final types = ['breast_milk', 'formula', 'diaper', 'sleep'];
    final titles = {'breast_milk': 'Breast Milk', 'formula': 'Formula', 'diaper': 'Diaper Change', 'sleep': 'Nap'};
    final icons = {'breast_milk': Icons.restaurant, 'formula': Icons.restaurant, 'diaper': Icons.child_care, 'sleep': Icons.nightlight_round};
    final colors = [AppColors.primary, AppColors.primary, AppColors.accent, AppColors.info];

    for (var i = 0; i < types.length; i++) {
      final r = lastRecords[types[i]] as Map<String, dynamic>?;
      if (r != null) {
        items.add(
          RecordListItem(
            icon: icons[types[i]]!,
            title: titles[types[i]]!,
            time: r['relative_time'] ?? '-',
            details: _formatRecordDetails(r, types[i]),
            color: colors[i],
            onTap: () {},
          ),
        );
        if (i < types.length - 1) items.add(Divider(height: 1, color: AppColors.border));
      }
    }

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text('최근 기록이 없습니다', style: AppTextStyles.body2),
      );
    }

    return Column(children: items);
  }
}

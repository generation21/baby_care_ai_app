import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/baby_profile_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/timer_widget.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/record_list_item.dart';
import 'add_feeding_screen.dart';
import 'ai_chat_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            const AppBarWidget(title: 'Baby Care'),
            
            // Scroll Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baby Profile Header
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: BabyProfileHeader(
                        babyName: '서준이',
                        babyAge: '7개월 8일',
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Today's Summary Section
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
                                  value: '6 times',
                                  sublabel: '480ml',
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: StatCard(
                                  icon: Icons.nightlight_round,
                                  label: 'Sleep',
                                  value: '10h 30m',
                                  sublabel: '4 naps',
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
                                  value: '6 times',
                                  sublabel: 'Last 2h ago',
                                  color: AppColors.accent,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: StatCard(
                                  icon: Icons.thermostat,
                                  label: 'Temperature',
                                  value: '36.5°C',
                                  sublabel: 'Normal',
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
                    
                    // Active Timer Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Active Timer', style: AppTextStyles.headline6),
                          const SizedBox(height: 12),
                          const TimerWidget(
                            isActive: true,
                            leftTime: '12:30',
                            rightTime: '08:15',
                            currentSide: 'left',
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Recent History Section
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
                            child: Column(
                              children: [
                                RecordListItem(
                                  icon: Icons.restaurant,
                                  title: 'Breast Milk',
                                  time: '4 minutes ago',
                                  details: '15 min - Left',
                                  color: AppColors.primary,
                                  onTap: () {},
                                ),
                                Divider(height: 1, color: AppColors.border),
                                RecordListItem(
                                  icon: Icons.restaurant,
                                  title: 'Formula',
                                  time: '4 hours 22 min ago',
                                  details: '85ml',
                                  color: AppColors.primary,
                                  onTap: () {},
                                ),
                                Divider(height: 1, color: AppColors.border),
                                RecordListItem(
                                  icon: Icons.child_care,
                                  title: 'Diaper Change',
                                  time: '2 hours 3 min ago',
                                  details: 'Dirty',
                                  color: AppColors.accent,
                                  onTap: () {},
                                ),
                                Divider(height: 1, color: AppColors.border),
                                RecordListItem(
                                  icon: Icons.nightlight_round,
                                  title: 'Nap',
                                  time: '2 hours 52 min ago',
                                  details: '90 minutes',
                                  color: AppColors.info,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Navigation
            BottomNavigationWidget(
              currentIndex: _selectedIndex,
              onTap: _onNavigationTap,
            ),
          ],
        ),
      ),
    );
  }
}

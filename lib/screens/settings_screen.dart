import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../states/auth_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_bar_widget.dart';

/// 설정 화면
/// 
/// 앱 설정 및 사용자 정보를 관리합니다.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(
              title: '설정',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/dashboard'),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 계정 정보 섹션
                  _SectionHeader(title: '계정 정보'),
                  const SizedBox(height: 8),
                  _SettingsCard(
                    children: [
                      _SettingsItem(
                        icon: Icons.person_outline,
                        title: '사용자 ID',
                        subtitle: authState.userId ?? '알 수 없음',
                        onTap: null,
                      ),
                      const Divider(height: 1),
                      _SettingsItem(
                        icon: Icons.phone_android,
                        title: '디바이스 ID',
                        subtitle: authState.deviceId ?? '알 수 없음',
                        onTap: null,
                      ),
                      const Divider(height: 1),
                      _SettingsItem(
                        icon: Icons.info_outline,
                        title: '인증 방식',
                        subtitle: '디바이스 기반 자동 인증',
                        onTap: null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // 앱 정보 섹션
                  _SectionHeader(title: '앱 정보'),
                  const SizedBox(height: 8),
                  _SettingsCard(
                    children: [
                      _SettingsItem(
                        icon: Icons.info,
                        title: '버전',
                        subtitle: '1.0.0',
                        onTap: null,
                      ),
                      const Divider(height: 1),
                      _SettingsItem(
                        icon: Icons.article_outlined,
                        title: '이용약관',
                        onTap: () {
                          // TODO: 이용약관 화면으로 이동
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('준비 중입니다')),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _SettingsItem(
                        icon: Icons.privacy_tip_outlined,
                        title: '개인정보 처리방침',
                        onTap: () {
                          // TODO: 개인정보 처리방침 화면으로 이동
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('준비 중입니다')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // 알림 설정 섹션
                  _SectionHeader(title: '알림'),
                  const SizedBox(height: 8),
                  _SettingsCard(
                    children: [
                      _SettingsItem(
                        icon: Icons.notifications_outlined,
                        title: '푸시 알림',
                        trailing: Switch(
                          value: true,
                          onChanged: (value) {
                            // TODO: 알림 설정 변경
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('준비 중입니다')),
                            );
                          },
                          activeTrackColor: AppColors.primary,
                        ),
                        onTap: null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // 데이터 관리 섹션
                  _SectionHeader(title: '데이터 관리'),
                  const SizedBox(height: 8),
                  _SettingsCard(
                    children: [
                      _SettingsItem(
                        icon: Icons.backup_outlined,
                        title: '데이터 백업',
                        onTap: () {
                          // TODO: 백업 기능
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('준비 중입니다')),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _SettingsItem(
                        icon: Icons.restore_outlined,
                        title: '데이터 복원',
                        onTap: () {
                          // TODO: 복원 기능
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('준비 중입니다')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // 로그아웃 버튼
                  _SettingsCard(
                    children: [
                      _SettingsItem(
                        icon: Icons.logout,
                        title: '로그아웃',
                        titleColor: AppColors.error,
                        onTap: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('로그아웃'),
                              content: const Text(
                                '로그아웃하시겠습니까?\n\n디바이스 기반 인증이므로, 로그아웃 후 다시 로그인하면 새로운 사용자로 등록됩니다.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.error,
                                  ),
                                  child: const Text('로그아웃'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true && context.mounted) {
                            await context.read<AuthState>().signOut();
                            if (context.mounted) {
                              context.go('/splash');
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                color: titleColor ?? AppColors.textPrimary,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: titleColor ?? AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else if (onTap != null)
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textTertiary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

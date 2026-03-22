import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../../l10n/app_localizations.dart';
import '../../l10n/l10n.dart';
// import '../../services/permission_service.dart';
import '../../services/settings_service.dart';
import '../../states/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const String _privacyPolicyUrl =
      'https://coherent-sky-363.notion.site/312211c598b180a7a9cdcc1edd11d677';
  static const String _termsOfServiceUrl =
      'https://coherent-sky-363.notion.site/312211c598b180969243fd5f24f53214';

  final SettingsService _settingsService = SettingsService();
  // final PermissionService _permissionService = PermissionService();

  bool _isLoading = true;
  // bool _notificationsEnabled = true;
  String _appVersionLabel = '-';
  // PermissionStatus _notificationPermissionStatus = PermissionStatus.denied;
  // PermissionStatus _photoPermissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // final notificationsEnabled = await _settingsService
    //     .getNotificationsEnabled();
    final appVersionLabel = await _settingsService.getAppVersionLabel();
    // final notificationStatus = await _permissionService
    // .getNotificationPermissionStatus();
    // final photoStatus = await _permissionService.getPhotoPermissionStatus();

    if (!mounted) {
      return;
    }

    setState(() {
      // _notificationsEnabled = notificationsEnabled;
      _appVersionLabel = appVersionLabel;
      // _notificationPermissionStatus = notificationStatus;
      // _photoPermissionStatus = photoStatus;
      _isLoading = false;
    });
  }

  /*
  Future<void> _toggleNotifications(bool enabled) async {
    await _settingsService.setNotificationsEnabled(enabled);
    if (!mounted) {
      return;
    }
    setState(() {
      _notificationsEnabled = enabled;
    });
  }
  */

  // Future<void> _requestAllPermissions() async {
  //   final result = await _permissionService.requestEssentialPermissions();
  //   if (!mounted) {
  //     return;
  //   }
  //   setState(() {
  //     _notificationPermissionStatus =
  //         result[AppPermissionType.notifications] ??
  //         _notificationPermissionStatus;
  //     _photoPermissionStatus =
  //         result[AppPermissionType.photos] ?? _photoPermissionStatus;
  //   });
  // }

  // Future<void> _requestSinglePermission(
  //   AppPermissionType permissionType,
  // ) async {
  //   final status = permissionType == AppPermissionType.notifications
  //       ? await _permissionService.requestNotificationPermission()
  //       : await _permissionService.requestPhotoPermission();
  //   if (!mounted) {
  //     return;
  //   }
  //   setState(() {
  //     if (permissionType == AppPermissionType.notifications) {
  //       _notificationPermissionStatus = status;
  //     } else {
  //       _photoPermissionStatus = status;
  //     }
  //   });
  // }

  Future<void> _confirmAndLogout() async {
    final l10n = context.l10n;
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logoutTitle),
        content: Text(l10n.logoutDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.logoutTitle),
          ),
        ],
      ),
    );

    if (shouldLogout != true || !mounted) {
      return;
    }

    await context.read<AuthState>().signOut();
    if (!mounted) {
      return;
    }
    context.go('/splash');
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('페이지를 열 수 없습니다.')),
        );
      }
    }
  }

  /// 계정 삭제 - 2단계 확인 후 영구 삭제 실행
  Future<void> _confirmAndDeleteAccount() async {
    // 1단계: 삭제 결과 안내 + 진행 의사 확인
    final proceedToFinalConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('계정 삭제'),
        content: const Text(
          '계정을 삭제하면 모든 아이 기록, AI 대화 내역 등 데이터가 영구적으로 삭제됩니다.\n\n정말 삭제하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('계속'),
          ),
        ],
      ),
    );

    if (proceedToFinalConfirm != true || !mounted) return;

    // 2단계: 복구 불가 최종 경고 확인
    final confirmedDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 22),
            const SizedBox(width: 8),
            const Text('최종 확인'),
          ],
        ),
        content: const Text(
          '삭제된 계정과 데이터는 복구할 수 없습니다.\n정말로 계정을 영구 삭제하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('영구 삭제'),
          ),
        ],
      ),
    );

    if (confirmedDelete != true || !mounted) return;

    final authState = context.read<AuthState>();
    final success = await authState.deleteAccount();

    if (!mounted) return;

    if (success) {
      context.go('/splash');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.errorMessage ?? '계정 삭제에 실패했습니다. 다시 시도해주세요.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(
              title: l10n.settingsTitle,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/dashboard'),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppDimensions.md),
                children: [
                  _SectionHeader(title: l10n.profileSectionTitle),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.person_outline,
                        title: l10n.profileMenuTitle,
                        subtitle: l10n.profileMenuSubtitle,
                        onTap: () => context.push('/settings/profile'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xl),
                  // TODO(seungbum): 언어/테마 설정은 추후 보완 후 재활성화 예정.
                  /*
                  _SectionHeader(title: l10n.languageSectionTitle),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.language_outlined,
                        title: l10n.languageTileTitle,
                        trailing: DropdownButton<String>(
                          value: localeState.locale?.languageCode ?? 'ko',
                          underline: const SizedBox.shrink(),
                          items: [
                            DropdownMenuItem(
                              value: 'ko',
                              child: Text(l10n.languageKorean),
                            ),
                            DropdownMenuItem(
                              value: 'en',
                              child: Text(l10n.languageEnglish),
                            ),
                            DropdownMenuItem(
                              value: 'ja',
                              child: Text(l10n.languageJapanese),
                            ),
                          ],
                          onChanged: (value) async {
                            if (value == null) {
                              return;
                            }
                            await context.read<LocaleState>().setLocale(
                              Locale(value),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xl),
                  _SectionHeader(title: l10n.themeSectionTitle),
                  _SettingsCard(
                    children: [
                      _ThemeModeTile(
                        mode: ThemeMode.system,
                        selectedMode: themeState.selectedThemeMode,
                        title: l10n.themeSystemTitle,
                        subtitle: l10n.themeSystemSubtitle,
                        onTap: () => themeState.setThemeMode(ThemeMode.system),
                      ),
                      const Divider(height: 1),
                      _ThemeModeTile(
                        mode: ThemeMode.light,
                        selectedMode: themeState.selectedThemeMode,
                        title: l10n.themeLightTitle,
                        subtitle: l10n.themeLightSubtitle,
                        onTap: () => themeState.setThemeMode(ThemeMode.light),
                      ),
                      const Divider(height: 1),
                      _ThemeModeTile(
                        mode: ThemeMode.dark,
                        selectedMode: themeState.selectedThemeMode,
                        title: l10n.themeDarkTitle,
                        subtitle: l10n.themeDarkSubtitle,
                        onTap: () => themeState.setThemeMode(ThemeMode.dark),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xl),
                  */
                  // TODO(seungbum): 알림 설정은 추후 보완 후 재활성화 예정.
                  /*
                  _SectionHeader(title: l10n.notificationsSectionTitle),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.notifications_outlined,
                        title: l10n.notificationsToggleTitle,
                        subtitle: l10n.notificationsToggleSubtitle,
                        trailing: Switch(
                          value: _notificationsEnabled,
                          activeTrackColor: AppColors.primary,
                          onChanged: _toggleNotifications,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xl),
                  */
                  // _SectionHeader(title: l10n.permissionsSectionTitle),
                  // _SettingsCard(
                  //   children: [
                  //     _PermissionTile(
                  //       icon: Icons.notifications_active_outlined,
                  //       title: l10n.notificationPermissionTitle,
                  //       status: _notificationPermissionStatus,
                  //       statusLabel: _statusLabel(
                  //         _notificationPermissionStatus,
                  //         l10n,
                  //       ),
                  //       onActionTap: () => _handlePermissionAction(
                  //         AppPermissionType.notifications,
                  //         _notificationPermissionStatus,
                  //       ),
                  //       actionLabel: _actionLabel(
                  //         _notificationPermissionStatus,
                  //         l10n,
                  //       ),
                  //     ),
                  //     const Divider(height: 1),
                  //     _PermissionTile(
                  //       icon: Icons.photo_library_outlined,
                  //       title: l10n.photoPermissionTitle,
                  //       status: _photoPermissionStatus,
                  //       statusLabel: _statusLabel(_photoPermissionStatus, l10n),
                  //       onActionTap: () => _handlePermissionAction(
                  //         AppPermissionType.photos,
                  //         _photoPermissionStatus,
                  //       ),
                  //       actionLabel: _actionLabel(_photoPermissionStatus, l10n),
                  //     ),
                  //     const Divider(height: 1),
                  //     _SettingsTile(
                  //       icon: Icons.refresh_outlined,
                  //       title: l10n.permissionRequestAll,
                  //       onTap: _requestAllPermissions,
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: AppDimensions.xl),
                  _SectionHeader(title: l10n.appInfoSectionTitle),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.info_outline,
                        title: l10n.appVersionTitle,
                        subtitle: _appVersionLabel,
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.privacy_tip_outlined,
                        title: '개인정보 처리방침',
                        onTap: () => _launchUrl(_privacyPolicyUrl),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.description_outlined,
                        title: '이용약관',
                        onTap: () => _launchUrl(_termsOfServiceUrl),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xl),
                  _SectionHeader(title: l10n.accountSectionTitle),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.logout_outlined,
                        title: l10n.logoutTitle,
                        titleColor: AppColors.error,
                        onTap: _confirmAndLogout,
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.delete_forever_outlined,
                        title: '계정 삭제',
                        subtitle: '모든 데이터가 영구적으로 삭제됩니다',
                        titleColor: AppColors.error,
                        onTap: _confirmAndDeleteAccount,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
  String _statusLabel(PermissionStatus status, AppLocalizations l10n) {
    switch (status) {
      case PermissionStatus.granted:
        return l10n.permissionStatusGranted;
      case PermissionStatus.denied:
        return l10n.permissionStatusDenied;
      case PermissionStatus.limited:
        return l10n.permissionStatusLimited;
      case PermissionStatus.permanentlyDenied:
        return l10n.permissionStatusNeedSettings;
      case PermissionStatus.restricted:
        return l10n.permissionStatusLimited;
      case PermissionStatus.provisional:
        return l10n.permissionStatusLimited;
    }
  }

  String _actionLabel(PermissionStatus status, AppLocalizations l10n) {
    if (status == PermissionStatus.permanentlyDenied) {
      return l10n.permissionActionOpenSettings;
    }
    return l10n.permissionActionRequest;
  }
  */

  // Future<void> _handlePermissionAction(
  //   AppPermissionType permissionType,
  //   PermissionStatus status,
  // ) async {
  //   if (status == PermissionStatus.permanentlyDenied) {
  //     await _permissionService.openSystemSettings();
  //     return;
  //   }
  //   await _requestSinglePermission(permissionType);
  // }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimensions.xs,
        bottom: AppDimensions.xs,
      ),
      child: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
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
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? titleColor;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.sm,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: AppDimensions.iconSize,
                color: titleColor ?? AppColors.textPrimary,
              ),
              const SizedBox(width: AppDimensions.md),
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
                      const SizedBox(height: AppDimensions.xxs),
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
              if (trailing != null) ...[
                trailing!,
              ] else if (onTap != null) ...[
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// TODO(seungbum): 테마 설정 UI 재활성화 시 _ThemeModeTile 복구.

/*
class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final PermissionStatus status;
  final String statusLabel;
  final String actionLabel;
  final VoidCallback onActionTap;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.status,
    required this.statusLabel,
    required this.actionLabel,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = status == PermissionStatus.granted
        ? AppColors.success
        : AppColors.warning;

    return _SettingsTile(
      icon: icon,
      title: title,
      subtitle: statusLabel,
      trailing: TextButton(
        onPressed: onActionTap,
        child: Text(
          actionLabel,
          style: AppTextStyles.caption.copyWith(color: statusColor),
        ),
      ),
      onTap: onActionTap,
    );
  }
}
*/

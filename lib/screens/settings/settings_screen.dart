import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../services/permission_service.dart';
import '../../services/settings_service.dart';
import '../../states/auth_state.dart';
import '../../states/theme_state.dart';
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
  static const String _title = '설정';
  static const String _profileMenuTitle = '프로필 설정';
  static const String _profileMenuSubtitle = '이름 및 계정 정보 관리';
  static const String _themeSectionTitle = '테마';
  static const String _notificationsSectionTitle = '알림';
  static const String _permissionsSectionTitle = '권한';
  static const String _appInfoSectionTitle = '앱 정보';
  static const String _logoutSectionTitle = '계정';
  static const String _notificationsToggleTitle = '알림 받기';
  static const String _notificationsToggleSubtitle = '향후 세부 알림 설정이 추가됩니다';
  static const String _notificationPermissionTitle = '알림 권한';
  static const String _photoPermissionTitle = '사진 권한';
  static const String _versionTileTitle = '앱 버전';
  static const String _logoutTileTitle = '로그아웃';
  static const String _logoutDialogTitle = '로그아웃';
  static const String _logoutDialogDescription =
      '로그아웃 후 앱을 다시 열면 새로운 익명 사용자로 로그인됩니다.';
  static const String _statusGranted = '허용됨';
  static const String _statusDenied = '거부됨';
  static const String _statusLimited = '제한됨';
  static const String _statusPermanentlyDenied = '설정 필요';
  static const String _statusRestricted = '제한됨';
  static const String _requestPermissionLabel = '권한 요청';
  static const String _openSystemSettingsLabel = '설정 열기';
  static const String _requestAllPermissionsLabel = '필수 권한 다시 요청';

  final SettingsService _settingsService = SettingsService();
  final PermissionService _permissionService = PermissionService();

  bool _isLoading = true;
  bool _notificationsEnabled = true;
  String _appVersionLabel = '-';
  PermissionStatus _notificationPermissionStatus = PermissionStatus.denied;
  PermissionStatus _photoPermissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final notificationsEnabled = await _settingsService
        .getNotificationsEnabled();
    final appVersionLabel = await _settingsService.getAppVersionLabel();
    final notificationStatus = await _permissionService
        .getNotificationPermissionStatus();
    final photoStatus = await _permissionService.getPhotoPermissionStatus();

    if (!mounted) {
      return;
    }

    setState(() {
      _notificationsEnabled = notificationsEnabled;
      _appVersionLabel = appVersionLabel;
      _notificationPermissionStatus = notificationStatus;
      _photoPermissionStatus = photoStatus;
      _isLoading = false;
    });
  }

  Future<void> _toggleNotifications(bool enabled) async {
    await _settingsService.setNotificationsEnabled(enabled);
    if (!mounted) {
      return;
    }
    setState(() {
      _notificationsEnabled = enabled;
    });
  }

  Future<void> _requestAllPermissions() async {
    final result = await _permissionService.requestEssentialPermissions();
    if (!mounted) {
      return;
    }
    setState(() {
      _notificationPermissionStatus =
          result[AppPermissionType.notifications] ??
          _notificationPermissionStatus;
      _photoPermissionStatus =
          result[AppPermissionType.photos] ?? _photoPermissionStatus;
    });
  }

  Future<void> _requestSinglePermission(
    AppPermissionType permissionType,
  ) async {
    final status = permissionType == AppPermissionType.notifications
        ? await _permissionService.requestNotificationPermission()
        : await _permissionService.requestPhotoPermission();
    if (!mounted) {
      return;
    }
    setState(() {
      if (permissionType == AppPermissionType.notifications) {
        _notificationPermissionStatus = status;
      } else {
        _photoPermissionStatus = status;
      }
    });
  }

  Future<void> _confirmAndLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_logoutDialogTitle),
        content: const Text(_logoutDialogDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text(_logoutDialogTitle),
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

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeState>();

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
              title: _title,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/dashboard'),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppDimensions.md),
                children: [
                  _SectionHeader(title: '프로필'),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.person_outline,
                        title: _profileMenuTitle,
                        subtitle: _profileMenuSubtitle,
                        onTap: () => context.push('/settings/profile'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xl),
                  _SectionHeader(title: _themeSectionTitle),
                  _SettingsCard(
                    children: [
                      _ThemeModeTile(
                        mode: ThemeMode.system,
                        selectedMode: themeState.selectedThemeMode,
                        title: '시스템 설정',
                        subtitle: '디바이스 테마를 따릅니다',
                        onTap: () => themeState.setThemeMode(ThemeMode.system),
                      ),
                      const Divider(height: 1),
                      _ThemeModeTile(
                        mode: ThemeMode.light,
                        selectedMode: themeState.selectedThemeMode,
                        title: '라이트',
                        subtitle: '밝은 테마 사용',
                        onTap: () => themeState.setThemeMode(ThemeMode.light),
                      ),
                      const Divider(height: 1),
                      _ThemeModeTile(
                        mode: ThemeMode.dark,
                        selectedMode: themeState.selectedThemeMode,
                        title: '다크',
                        subtitle: '어두운 테마 사용',
                        onTap: () => themeState.setThemeMode(ThemeMode.dark),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xl),
                  _SectionHeader(title: _notificationsSectionTitle),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.notifications_outlined,
                        title: _notificationsToggleTitle,
                        subtitle: _notificationsToggleSubtitle,
                        trailing: Switch(
                          value: _notificationsEnabled,
                          activeTrackColor: AppColors.primary,
                          onChanged: _toggleNotifications,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xl),
                  _SectionHeader(title: _permissionsSectionTitle),
                  _SettingsCard(
                    children: [
                      _PermissionTile(
                        icon: Icons.notifications_active_outlined,
                        title: _notificationPermissionTitle,
                        status: _notificationPermissionStatus,
                        statusLabel: _statusLabel(
                          _notificationPermissionStatus,
                        ),
                        onActionTap: () => _handlePermissionAction(
                          AppPermissionType.notifications,
                          _notificationPermissionStatus,
                        ),
                        actionLabel: _actionLabel(
                          _notificationPermissionStatus,
                        ),
                      ),
                      const Divider(height: 1),
                      _PermissionTile(
                        icon: Icons.photo_library_outlined,
                        title: _photoPermissionTitle,
                        status: _photoPermissionStatus,
                        statusLabel: _statusLabel(_photoPermissionStatus),
                        onActionTap: () => _handlePermissionAction(
                          AppPermissionType.photos,
                          _photoPermissionStatus,
                        ),
                        actionLabel: _actionLabel(_photoPermissionStatus),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.refresh_outlined,
                        title: _requestAllPermissionsLabel,
                        onTap: _requestAllPermissions,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xl),
                  _SectionHeader(title: _appInfoSectionTitle),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.info_outline,
                        title: _versionTileTitle,
                        subtitle: _appVersionLabel,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xl),
                  _SectionHeader(title: _logoutSectionTitle),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.logout_outlined,
                        title: _logoutTileTitle,
                        titleColor: AppColors.error,
                        onTap: _confirmAndLogout,
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

  String _statusLabel(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return _statusGranted;
      case PermissionStatus.denied:
        return _statusDenied;
      case PermissionStatus.limited:
        return _statusLimited;
      case PermissionStatus.permanentlyDenied:
        return _statusPermanentlyDenied;
      case PermissionStatus.restricted:
        return _statusRestricted;
      case PermissionStatus.provisional:
        return _statusLimited;
    }
  }

  String _actionLabel(PermissionStatus status) {
    if (status == PermissionStatus.permanentlyDenied) {
      return _openSystemSettingsLabel;
    }
    return _requestPermissionLabel;
  }

  Future<void> _handlePermissionAction(
    AppPermissionType permissionType,
    PermissionStatus status,
  ) async {
    if (status == PermissionStatus.permanentlyDenied) {
      await _permissionService.openSystemSettings();
      return;
    }
    await _requestSinglePermission(permissionType);
  }
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

class _ThemeModeTile extends StatelessWidget {
  final ThemeMode mode;
  final ThemeMode selectedMode;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ThemeModeTile({
    required this.mode,
    required this.selectedMode,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsTile(
      icon: mode == ThemeMode.system
          ? Icons.settings_suggest_outlined
          : mode == ThemeMode.light
          ? Icons.light_mode_outlined
          : Icons.dark_mode_outlined,
      title: title,
      subtitle: subtitle,
      trailing: Icon(
        selectedMode == mode
            ? Icons.check_circle
            : Icons.radio_button_unchecked,
        color: selectedMode == mode
            ? AppColors.primary
            : AppColors.textTertiary,
      ),
      onTap: onTap,
    );
  }
}

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

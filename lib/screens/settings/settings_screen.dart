import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../../services/permission_service.dart';
import '../../services/settings_service.dart';
import '../../states/auth_state.dart';
import '../../states/locale_state.dart';
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeState = context.watch<ThemeState>();
    final localeState = context.watch<LocaleState>();

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
                  _SectionHeader(title: l10n.permissionsSectionTitle),
                  _SettingsCard(
                    children: [
                      _PermissionTile(
                        icon: Icons.notifications_active_outlined,
                        title: l10n.notificationPermissionTitle,
                        status: _notificationPermissionStatus,
                        statusLabel: _statusLabel(
                          _notificationPermissionStatus,
                          l10n,
                        ),
                        onActionTap: () => _handlePermissionAction(
                          AppPermissionType.notifications,
                          _notificationPermissionStatus,
                        ),
                        actionLabel: _actionLabel(
                          _notificationPermissionStatus,
                          l10n,
                        ),
                      ),
                      const Divider(height: 1),
                      _PermissionTile(
                        icon: Icons.photo_library_outlined,
                        title: l10n.photoPermissionTitle,
                        status: _photoPermissionStatus,
                        statusLabel: _statusLabel(_photoPermissionStatus, l10n),
                        onActionTap: () => _handlePermissionAction(
                          AppPermissionType.photos,
                          _photoPermissionStatus,
                        ),
                        actionLabel: _actionLabel(_photoPermissionStatus, l10n),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.refresh_outlined,
                        title: l10n.permissionRequestAll,
                        onTap: _requestAllPermissions,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xl),
                  _SectionHeader(title: l10n.appInfoSectionTitle),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.info_outline,
                        title: l10n.appVersionTitle,
                        subtitle: _appVersionLabel,
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

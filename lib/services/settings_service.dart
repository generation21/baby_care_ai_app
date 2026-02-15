import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _keyNotificationsEnabled =
      'settings_notifications_enabled';
  static const String _keyDisplayName = 'settings_profile_display_name';

  Future<bool> getNotificationsEnabled() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_keyNotificationsEnabled) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_keyNotificationsEnabled, enabled);
  }

  Future<String?> getDisplayName() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_keyDisplayName);
  }

  Future<void> setDisplayName(String displayName) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_keyDisplayName, displayName);
  }

  Future<String> getAppVersionLabel() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version}+${packageInfo.buildNumber}';
  }
}

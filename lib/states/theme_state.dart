import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState extends ChangeNotifier {
  static const String _keyThemeMode = 'theme_mode';

  bool _isInitialized = false;
  ThemeMode _themeMode = ThemeMode.system;

  bool get isInitialized => _isInitialized;
  ThemeMode get selectedThemeMode => _themeMode;

  ThemeMode get themeMode => _themeMode;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedThemeMode =
        prefs.getString(_keyThemeMode) ?? ThemeMode.system.name;
    _themeMode = _parseThemeMode(storedThemeMode);
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, mode.name);
    notifyListeners();
  }

  // Legacy API 호환을 위해 유지합니다.
  bool get followSystem => _themeMode == ThemeMode.system;
  ThemeMode get manualThemeMode =>
      _themeMode == ThemeMode.system ? ThemeMode.light : _themeMode;

  Future<void> setFollowSystem(bool value) async {
    await setThemeMode(value ? ThemeMode.system : manualThemeMode);
  }

  Future<void> setManualThemeMode(ThemeMode mode) async {
    if (mode == ThemeMode.system) {
      return;
    }
    await setThemeMode(mode);
  }

  ThemeMode _parseThemeMode(String rawMode) {
    if (rawMode == ThemeMode.dark.name) {
      return ThemeMode.dark;
    }
    if (rawMode == ThemeMode.system.name) {
      return ThemeMode.system;
    }
    return ThemeMode.light;
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState extends ChangeNotifier {
  static const String _keyFollowSystem = 'theme_follow_system';
  static const String _keyManualMode = 'theme_manual_mode';

  bool _isInitialized = false;
  bool _followSystem = true;
  ThemeMode _manualThemeMode = ThemeMode.light;

  bool get isInitialized => _isInitialized;
  bool get followSystem => _followSystem;
  ThemeMode get manualThemeMode => _manualThemeMode;

  ThemeMode get themeMode => _followSystem ? ThemeMode.system : _manualThemeMode;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    _followSystem = prefs.getBool(_keyFollowSystem) ?? true;
    final storedManualMode = prefs.getString(_keyManualMode) ?? ThemeMode.light.name;
    _manualThemeMode = _parseThemeMode(storedManualMode);
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setFollowSystem(bool value) async {
    _followSystem = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFollowSystem, value);
    notifyListeners();
  }

  Future<void> setManualThemeMode(ThemeMode mode) async {
    if (mode == ThemeMode.system) {
      return;
    }
    _manualThemeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyManualMode, mode.name);
    notifyListeners();
  }

  ThemeMode _parseThemeMode(String rawMode) {
    if (rawMode == ThemeMode.dark.name) {
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }
}

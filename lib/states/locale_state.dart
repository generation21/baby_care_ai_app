import 'package:flutter/material.dart';

import '../services/settings_service.dart';

class LocaleState extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();
  Locale? _locale;
  bool _isInitialized = false;

  Locale? get locale => _locale;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    final localeCode = await _settingsService.getLocaleCode();
    if (localeCode != null && localeCode.isNotEmpty) {
      _locale = Locale(localeCode);
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _settingsService.setLocaleCode(locale.languageCode);
    notifyListeners();
  }
}

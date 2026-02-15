// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Baby Care AI';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get profileSectionTitle => 'Profile';

  @override
  String get profileMenuTitle => 'Profile settings';

  @override
  String get profileMenuSubtitle => 'Manage name and account info';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get languageTileTitle => 'App language';

  @override
  String get languageKorean => 'Korean';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageJapanese => 'Japanese';

  @override
  String get themeSectionTitle => 'Theme';

  @override
  String get themeSystemTitle => 'System';

  @override
  String get themeSystemSubtitle => 'Follow device theme';

  @override
  String get themeLightTitle => 'Light';

  @override
  String get themeLightSubtitle => 'Use light mode';

  @override
  String get themeDarkTitle => 'Dark';

  @override
  String get themeDarkSubtitle => 'Use dark mode';

  @override
  String get notificationsSectionTitle => 'Notifications';

  @override
  String get notificationsToggleTitle => 'Enable notifications';

  @override
  String get notificationsToggleSubtitle => 'Detailed options will be added later';

  @override
  String get permissionsSectionTitle => 'Permissions';

  @override
  String get notificationPermissionTitle => 'Notification permission';

  @override
  String get photoPermissionTitle => 'Photo permission';

  @override
  String get permissionStatusGranted => 'Granted';

  @override
  String get permissionStatusDenied => 'Denied';

  @override
  String get permissionStatusLimited => 'Limited';

  @override
  String get permissionStatusNeedSettings => 'Open settings';

  @override
  String get permissionActionRequest => 'Request';

  @override
  String get permissionActionOpenSettings => 'Settings';

  @override
  String get permissionRequestAll => 'Request required permissions again';

  @override
  String get appInfoSectionTitle => 'App info';

  @override
  String get appVersionTitle => 'App version';

  @override
  String get accountSectionTitle => 'Account';

  @override
  String get logoutTitle => 'Log out';

  @override
  String get cancel => 'Cancel';

  @override
  String get logoutDescription => 'After logging out, the app signs in as a new anonymous user.';

  @override
  String get profileSettingsTitle => 'Profile settings';

  @override
  String get basicInfoTitle => 'Basic info';

  @override
  String get displayNameLabel => 'Display name';

  @override
  String get displayNameHint => 'e.g. Mom, Dad';

  @override
  String get saveNameButton => 'Save name';

  @override
  String get savedProfileNameMessage => 'Profile name saved.';

  @override
  String get accountInfoTitle => 'Account info';

  @override
  String get userIdLabel => 'User ID';

  @override
  String get deviceIdLabel => 'Device ID';

  @override
  String get splashTagline => 'Track, Care, Connect';

  @override
  String get loadingLabel => 'Loading...';

  @override
  String get versionPrefix => 'Version';

  @override
  String get feedingListTitle => 'Feeding records';

  @override
  String get addFeedingTooltip => 'Add feeding record';

  @override
  String get retryButton => 'Retry';

  @override
  String get emptyFeedingTitle => 'No feeding records';

  @override
  String get emptyFeedingSubtitle => 'Tap + at the top-right to add one.';

  @override
  String get allFeedingLoaded => 'All feeding records are loaded.';

  @override
  String get dateRangeFilterLabel => 'Date filter';

  @override
  String get clearDateRangeButton => 'Clear date range';

  @override
  String get feedingAmountLabel => 'Amount';

  @override
  String get feedingDurationLabel => 'Duration';

  @override
  String get feedingSideLabel => 'Side';

  @override
  String minutesLabel(int count) {
    return '${count}m';
  }

  @override
  String get sideLeft => 'Left';

  @override
  String get sideRight => 'Right';

  @override
  String get sideBoth => 'Both';

  @override
  String get careListTitle => 'Care records';

  @override
  String get addCareTooltip => 'Add care record';

  @override
  String get emptyCareTitle => 'No care records';

  @override
  String get emptyCareSubtitle => 'Tap + at the top-right to add one.';

  @override
  String get allCareLoaded => 'All care records are loaded.';

  @override
  String get diaperRecordSummary => 'Diaper record';

  @override
  String get sleepRecordSummary => 'Sleep record';

  @override
  String sleepDurationSummary(int hours, int minutes) {
    return 'Sleep ${hours}h ${minutes}m';
  }

  @override
  String get temperatureRecordSummary => 'Temperature record';

  @override
  String temperatureValueSummary(Object value, Object unit) {
    return 'Temperature $value°$unit';
  }

  @override
  String get medicineRecordSummary => 'Medication record';

  @override
  String get bathRecordSummary => 'Bath record';

  @override
  String get otherRecordSummary => 'Other record';
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Baby Care AI'**
  String get appTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @profileSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileSectionTitle;

  /// No description provided for @profileMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile settings'**
  String get profileMenuTitle;

  /// No description provided for @profileMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage name and account info'**
  String get profileMenuSubtitle;

  /// No description provided for @languageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSectionTitle;

  /// No description provided for @languageTileTitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get languageTileTitle;

  /// No description provided for @languageKorean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get languageKorean;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get languageJapanese;

  /// No description provided for @themeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeSectionTitle;

  /// No description provided for @themeSystemTitle.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystemTitle;

  /// No description provided for @themeSystemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow device theme'**
  String get themeSystemSubtitle;

  /// No description provided for @themeLightTitle.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLightTitle;

  /// No description provided for @themeLightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use light mode'**
  String get themeLightSubtitle;

  /// No description provided for @themeDarkTitle.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDarkTitle;

  /// No description provided for @themeDarkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use dark mode'**
  String get themeDarkSubtitle;

  /// No description provided for @notificationsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSectionTitle;

  /// No description provided for @notificationsToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get notificationsToggleTitle;

  /// No description provided for @notificationsToggleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Detailed options will be added later'**
  String get notificationsToggleSubtitle;

  /// No description provided for @permissionsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissionsSectionTitle;

  /// No description provided for @notificationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification permission'**
  String get notificationPermissionTitle;

  /// No description provided for @photoPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo permission'**
  String get photoPermissionTitle;

  /// No description provided for @permissionStatusGranted.
  ///
  /// In en, this message translates to:
  /// **'Granted'**
  String get permissionStatusGranted;

  /// No description provided for @permissionStatusDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get permissionStatusDenied;

  /// No description provided for @permissionStatusLimited.
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get permissionStatusLimited;

  /// No description provided for @permissionStatusNeedSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get permissionStatusNeedSettings;

  /// No description provided for @permissionActionRequest.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get permissionActionRequest;

  /// No description provided for @permissionActionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get permissionActionOpenSettings;

  /// No description provided for @permissionRequestAll.
  ///
  /// In en, this message translates to:
  /// **'Request required permissions again'**
  String get permissionRequestAll;

  /// No description provided for @appInfoSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'App info'**
  String get appInfoSectionTitle;

  /// No description provided for @appVersionTitle.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersionTitle;

  /// No description provided for @accountSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSectionTitle;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logoutDescription.
  ///
  /// In en, this message translates to:
  /// **'After logging out, the app signs in as a new anonymous user.'**
  String get logoutDescription;

  /// No description provided for @profileSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile settings'**
  String get profileSettingsTitle;

  /// No description provided for @basicInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic info'**
  String get basicInfoTitle;

  /// No description provided for @displayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayNameLabel;

  /// No description provided for @displayNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mom, Dad'**
  String get displayNameHint;

  /// No description provided for @saveNameButton.
  ///
  /// In en, this message translates to:
  /// **'Save name'**
  String get saveNameButton;

  /// No description provided for @savedProfileNameMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile name saved.'**
  String get savedProfileNameMessage;

  /// No description provided for @accountInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Account info'**
  String get accountInfoTitle;

  /// No description provided for @userIdLabel.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userIdLabel;

  /// No description provided for @deviceIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get deviceIdLabel;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Track, Care, Connect'**
  String get splashTagline;

  /// No description provided for @loadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingLabel;

  /// No description provided for @versionPrefix.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionPrefix;

  /// No description provided for @feedingListTitle.
  ///
  /// In en, this message translates to:
  /// **'Feeding records'**
  String get feedingListTitle;

  /// No description provided for @addFeedingTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add feeding record'**
  String get addFeedingTooltip;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @emptyFeedingTitle.
  ///
  /// In en, this message translates to:
  /// **'No feeding records'**
  String get emptyFeedingTitle;

  /// No description provided for @emptyFeedingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + at the top-right to add one.'**
  String get emptyFeedingSubtitle;

  /// No description provided for @allFeedingLoaded.
  ///
  /// In en, this message translates to:
  /// **'All feeding records are loaded.'**
  String get allFeedingLoaded;

  /// No description provided for @dateRangeFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Date filter'**
  String get dateRangeFilterLabel;

  /// No description provided for @clearDateRangeButton.
  ///
  /// In en, this message translates to:
  /// **'Clear date range'**
  String get clearDateRangeButton;

  /// No description provided for @feedingAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get feedingAmountLabel;

  /// No description provided for @feedingDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get feedingDurationLabel;

  /// No description provided for @feedingSideLabel.
  ///
  /// In en, this message translates to:
  /// **'Side'**
  String get feedingSideLabel;

  /// No description provided for @minutesLabel.
  ///
  /// In en, this message translates to:
  /// **'{count}m'**
  String minutesLabel(int count);

  /// No description provided for @sideLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get sideLeft;

  /// No description provided for @sideRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get sideRight;

  /// No description provided for @sideBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get sideBoth;

  /// No description provided for @careListTitle.
  ///
  /// In en, this message translates to:
  /// **'Care records'**
  String get careListTitle;

  /// No description provided for @addCareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add care record'**
  String get addCareTooltip;

  /// No description provided for @emptyCareTitle.
  ///
  /// In en, this message translates to:
  /// **'No care records'**
  String get emptyCareTitle;

  /// No description provided for @emptyCareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + at the top-right to add one.'**
  String get emptyCareSubtitle;

  /// No description provided for @allCareLoaded.
  ///
  /// In en, this message translates to:
  /// **'All care records are loaded.'**
  String get allCareLoaded;

  /// No description provided for @diaperRecordSummary.
  ///
  /// In en, this message translates to:
  /// **'Diaper record'**
  String get diaperRecordSummary;

  /// No description provided for @sleepRecordSummary.
  ///
  /// In en, this message translates to:
  /// **'Sleep record'**
  String get sleepRecordSummary;

  /// No description provided for @sleepDurationSummary.
  ///
  /// In en, this message translates to:
  /// **'Sleep {hours}h {minutes}m'**
  String sleepDurationSummary(int hours, int minutes);

  /// No description provided for @temperatureRecordSummary.
  ///
  /// In en, this message translates to:
  /// **'Temperature record'**
  String get temperatureRecordSummary;

  /// No description provided for @temperatureValueSummary.
  ///
  /// In en, this message translates to:
  /// **'Temperature {value}°{unit}'**
  String temperatureValueSummary(Object value, Object unit);

  /// No description provided for @medicineRecordSummary.
  ///
  /// In en, this message translates to:
  /// **'Medication record'**
  String get medicineRecordSummary;

  /// No description provided for @bathRecordSummary.
  ///
  /// In en, this message translates to:
  /// **'Bath record'**
  String get bathRecordSummary;

  /// No description provided for @otherRecordSummary.
  ///
  /// In en, this message translates to:
  /// **'Other record'**
  String get otherRecordSummary;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Baby Care AI';

  @override
  String get settingsTitle => '設定';

  @override
  String get profileSectionTitle => 'プロフィール';

  @override
  String get profileMenuTitle => 'プロフィール設定';

  @override
  String get profileMenuSubtitle => '名前とアカウント情報を管理';

  @override
  String get languageSectionTitle => '言語';

  @override
  String get languageTileTitle => 'アプリ言語';

  @override
  String get languageKorean => '韓国語';

  @override
  String get languageEnglish => '英語';

  @override
  String get languageJapanese => '日本語';

  @override
  String get themeSectionTitle => 'テーマ';

  @override
  String get themeSystemTitle => 'システム設定';

  @override
  String get themeSystemSubtitle => '端末のテーマに従います';

  @override
  String get themeLightTitle => 'ライト';

  @override
  String get themeLightSubtitle => '明るいテーマを使用';

  @override
  String get themeDarkTitle => 'ダーク';

  @override
  String get themeDarkSubtitle => '暗いテーマを使用';

  @override
  String get notificationsSectionTitle => '通知';

  @override
  String get notificationsToggleTitle => '通知を受け取る';

  @override
  String get notificationsToggleSubtitle => '詳細な通知設定は今後追加予定です';

  @override
  String get permissionsSectionTitle => '権限';

  @override
  String get notificationPermissionTitle => '通知権限';

  @override
  String get photoPermissionTitle => '写真権限';

  @override
  String get permissionStatusGranted => '許可済み';

  @override
  String get permissionStatusDenied => '拒否';

  @override
  String get permissionStatusLimited => '制限あり';

  @override
  String get permissionStatusNeedSettings => '設定が必要';

  @override
  String get permissionActionRequest => '権限を要求';

  @override
  String get permissionActionOpenSettings => '設定を開く';

  @override
  String get permissionRequestAll => '必須権限を再要求';

  @override
  String get appInfoSectionTitle => 'アプリ情報';

  @override
  String get appVersionTitle => 'アプリバージョン';

  @override
  String get accountSectionTitle => 'アカウント';

  @override
  String get logoutTitle => 'ログアウト';

  @override
  String get cancel => 'キャンセル';

  @override
  String get logoutDescription => 'ログアウト後にアプリを再起動すると、新しい匿名ユーザーでログインします。';

  @override
  String get profileSettingsTitle => 'プロフィール設定';

  @override
  String get basicInfoTitle => '基本情報';

  @override
  String get displayNameLabel => '表示名';

  @override
  String get displayNameHint => '例: ママ、パパ';

  @override
  String get saveNameButton => '名前を保存';

  @override
  String get savedProfileNameMessage => 'プロフィール名を保存しました。';

  @override
  String get accountInfoTitle => 'アカウント情報';

  @override
  String get userIdLabel => 'ユーザーID';

  @override
  String get deviceIdLabel => 'デバイスID';

  @override
  String get splashTagline => 'Track, Care, Connect';

  @override
  String get loadingLabel => 'Loading...';

  @override
  String get versionPrefix => 'Version';

  @override
  String get feedingListTitle => '授乳記録';

  @override
  String get addFeedingTooltip => '授乳記録を追加';

  @override
  String get retryButton => '再試行';

  @override
  String get emptyFeedingTitle => '授乳記録がありません';

  @override
  String get emptyFeedingSubtitle => '右上の + ボタンで授乳記録を追加してください。';

  @override
  String get allFeedingLoaded => 'すべての授乳記録を読み込みました。';

  @override
  String get dateRangeFilterLabel => '期間フィルター';

  @override
  String get clearDateRangeButton => '期間をリセット';

  @override
  String get feedingAmountLabel => '量';

  @override
  String get feedingDurationLabel => '時間';

  @override
  String get feedingSideLabel => '部位';

  @override
  String minutesLabel(int count) {
    return '$count分';
  }

  @override
  String get sideLeft => '左';

  @override
  String get sideRight => '右';

  @override
  String get sideBoth => '両方';

  @override
  String get careListTitle => '育児記録';

  @override
  String get addCareTooltip => '育児記録を追加';

  @override
  String get emptyCareTitle => '育児記録がありません';

  @override
  String get emptyCareSubtitle => '右上の + ボタンで記録を追加してください。';

  @override
  String get allCareLoaded => 'すべての育児記録を読み込みました。';

  @override
  String get diaperRecordSummary => 'おむつ記録';

  @override
  String get sleepRecordSummary => '睡眠記録';

  @override
  String sleepDurationSummary(int hours, int minutes) {
    return '睡眠時間 $hours時間 $minutes分';
  }

  @override
  String get temperatureRecordSummary => '体温記録';

  @override
  String temperatureValueSummary(Object value, Object unit) {
    return '体温 $value°$unit';
  }

  @override
  String get medicineRecordSummary => '服薬記録';

  @override
  String get bathRecordSummary => '入浴記録';

  @override
  String get otherRecordSummary => 'その他記録';
}

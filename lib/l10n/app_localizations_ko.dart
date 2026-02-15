// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Baby Care AI';

  @override
  String get settingsTitle => '설정';

  @override
  String get profileSectionTitle => '프로필';

  @override
  String get profileMenuTitle => '프로필 설정';

  @override
  String get profileMenuSubtitle => '이름 및 계정 정보 관리';

  @override
  String get languageSectionTitle => '언어';

  @override
  String get languageTileTitle => '앱 언어';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageEnglish => '영어';

  @override
  String get languageJapanese => '일본어';

  @override
  String get themeSectionTitle => '테마';

  @override
  String get themeSystemTitle => '시스템 설정';

  @override
  String get themeSystemSubtitle => '디바이스 테마를 따릅니다';

  @override
  String get themeLightTitle => '라이트';

  @override
  String get themeLightSubtitle => '밝은 테마 사용';

  @override
  String get themeDarkTitle => '다크';

  @override
  String get themeDarkSubtitle => '어두운 테마 사용';

  @override
  String get notificationsSectionTitle => '알림';

  @override
  String get notificationsToggleTitle => '알림 받기';

  @override
  String get notificationsToggleSubtitle => '향후 세부 알림 설정이 추가됩니다';

  @override
  String get permissionsSectionTitle => '권한';

  @override
  String get notificationPermissionTitle => '알림 권한';

  @override
  String get photoPermissionTitle => '사진 권한';

  @override
  String get permissionStatusGranted => '허용됨';

  @override
  String get permissionStatusDenied => '거부됨';

  @override
  String get permissionStatusLimited => '제한됨';

  @override
  String get permissionStatusNeedSettings => '설정 필요';

  @override
  String get permissionActionRequest => '권한 요청';

  @override
  String get permissionActionOpenSettings => '설정 열기';

  @override
  String get permissionRequestAll => '필수 권한 다시 요청';

  @override
  String get appInfoSectionTitle => '앱 정보';

  @override
  String get appVersionTitle => '앱 버전';

  @override
  String get accountSectionTitle => '계정';

  @override
  String get logoutTitle => '로그아웃';

  @override
  String get cancel => '취소';

  @override
  String get logoutDescription => '로그아웃 후 앱을 다시 열면 새로운 익명 사용자로 로그인됩니다.';

  @override
  String get profileSettingsTitle => '프로필 설정';

  @override
  String get basicInfoTitle => '기본 정보';

  @override
  String get displayNameLabel => '표시 이름';

  @override
  String get displayNameHint => '예: 엄마, 아빠';

  @override
  String get saveNameButton => '이름 저장';

  @override
  String get savedProfileNameMessage => '프로필 이름을 저장했습니다.';

  @override
  String get accountInfoTitle => '계정 정보';

  @override
  String get userIdLabel => '사용자 ID';

  @override
  String get deviceIdLabel => '디바이스 ID';

  @override
  String get splashTagline => 'Track, Care, Connect';

  @override
  String get loadingLabel => 'Loading...';

  @override
  String get versionPrefix => 'Version';

  @override
  String get feedingListTitle => '수유 기록';

  @override
  String get addFeedingTooltip => '수유 기록 추가';

  @override
  String get retryButton => '다시 시도';

  @override
  String get emptyFeedingTitle => '수유 기록이 없습니다';

  @override
  String get emptyFeedingSubtitle => '우측 상단 + 버튼으로 수유 기록을 추가해보세요.';

  @override
  String get allFeedingLoaded => '모든 수유 기록을 불러왔습니다.';

  @override
  String get dateRangeFilterLabel => '기간 필터';

  @override
  String get clearDateRangeButton => '기간 초기화';

  @override
  String get feedingAmountLabel => '양';

  @override
  String get feedingDurationLabel => '시간';

  @override
  String get feedingSideLabel => '부위';

  @override
  String minutesLabel(int count) {
    return '$count분';
  }

  @override
  String get sideLeft => '왼쪽';

  @override
  String get sideRight => '오른쪽';

  @override
  String get sideBoth => '양쪽';

  @override
  String get careListTitle => '육아 기록';

  @override
  String get addCareTooltip => '육아 기록 추가';

  @override
  String get emptyCareTitle => '육아 기록이 없습니다';

  @override
  String get emptyCareSubtitle => '우측 상단 + 버튼으로 기록을 추가해보세요.';

  @override
  String get allCareLoaded => '모든 육아 기록을 불러왔습니다.';

  @override
  String get diaperRecordSummary => '기저귀 기록';

  @override
  String get sleepRecordSummary => '수면 기록';

  @override
  String sleepDurationSummary(int hours, int minutes) {
    return '수면 시간 $hours시간 $minutes분';
  }

  @override
  String get temperatureRecordSummary => '체온 기록';

  @override
  String temperatureValueSummary(Object value, Object unit) {
    return '체온 $value°$unit';
  }

  @override
  String get medicineRecordSummary => '약물 기록';

  @override
  String get bathRecordSummary => '목욕 기록';

  @override
  String get otherRecordSummary => '기타 기록';
}

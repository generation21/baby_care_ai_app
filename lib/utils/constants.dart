/// 앱 전역 상수 정의
/// 
/// 앱 전체에서 사용되는 상수값들을 중앙에서 관리합니다.
class AppConstants {
  AppConstants._();

  // 앱 정보
  static const String appName = 'Baby Care AI';
  static const String appVersion = '1.0.0';

  // 네트워크 관련
  static const int maxRetryAttempts = 3;
  static const Duration networkTimeout = Duration(seconds: 30);

  // 로컬 스토리지 키
  static const String storageKeyAccessToken = 'access_token';
  static const String storageKeyRefreshToken = 'refresh_token';
  static const String storageKeyUserId = 'user_id';
  static const String storageKeyBabyProfile = 'baby_profile';
  static const String storageKeyUserPreferences = 'user_preferences';

  // 날짜/시간 포맷
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';

  // 피드 관련 상수
  static const int minFeedingAmount = 0;
  static const int maxFeedingAmount = 1000; // ml
  static const int defaultFeedingAmount = 100;

  // 수면 관련 상수
  static const int minSleepDuration = 0; // 분
  static const int maxSleepDuration = 1440; // 24시간
  static const int defaultSleepDuration = 120; // 2시간

  // 기저귀 관련 상수
  static const List<String> diaperTypes = [
    'wet',
    'dirty',
    'both',
  ];

  // 건강 관련 상수
  static const double minTemperature = 35.0; // 섭씨
  static const double maxTemperature = 42.0; // 섭씨
  static const double normalTemperatureMin = 36.5;
  static const double normalTemperatureMax = 37.5;

  // 페이지네이션
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // 애니메이션 지속 시간
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // 디바운스/스로틀
  static const Duration debounceDelay = Duration(milliseconds: 300);
  static const Duration throttleDelay = Duration(milliseconds: 1000);
}

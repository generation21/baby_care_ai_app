/// 앱의 모든 라우트 경로와 이름을 관리하는 상수 클래스
class RouteConstants {
  // Private constructor to prevent instantiation
  RouteConstants._();

  // Main routes
  static const String home = '/';
  static const String settings = '/settings';

  // Future routes (예시)
  static const String profile = '/profile';
  static const String login = '/login';
  static const String register = '/register';

  // Nested routes
  static const String profileEdit = '/profile/edit';
  static const String settingsNotifications = '/settings/notifications';
  static const String settingsPrivacy = '/settings/privacy';

  // Route with parameters
  static String userProfile(String userId) => '/user/$userId';
  static String productDetail(String productId) => '/product/$productId';

  // Route names for GoRouter
  static const String homeName = 'home';
  static const String settingsName = 'settings';
  static const String profileName = 'profile';
  static const String loginName = 'login';
  static const String registerName = 'register';
  static const String profileEditName = 'profileEdit';
  static const String settingsNotificationsName = 'settingsNotifications';
  static const String settingsPrivacyName = 'settingsPrivacy';
  static const String userProfileName = 'userProfile';
  static const String productDetailName = 'productDetail';

  // Helper methods
  static List<String> get allRoutes => [
    home,
    settings,
    profile,
    login,
    register,
    profileEdit,
    settingsNotifications,
    settingsPrivacy,
  ];

  // Route groups for organization
  static const List<String> authRoutes = [login, register];

  static const List<String> settingsRoutes = [
    settings,
    settingsNotifications,
    settingsPrivacy,
  ];
}

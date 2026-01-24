import 'package:babycareai/screens/home_screen.dart';
import 'package:babycareai/screens/settings_screen.dart';
import 'package:babycareai/utils/route_constants.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: RouteConstants.home,
  routes: [
    GoRoute(
      path: RouteConstants.home,
      name: RouteConstants.homeName,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RouteConstants.settings,
      name: RouteConstants.settingsName,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

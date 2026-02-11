import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../screens/add_child_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/splash_screen.dart';
import '../states/auth_state.dart';

/// 앱 라우터 설정
/// 
/// GoRouter를 사용한 라우팅 관리
/// 디바이스 기반 자동 인증을 사용하므로 로그인/회원가입 화면이 없습니다.
class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/splash',
      redirect: (context, state) {
        final authState = Provider.of<AuthState>(context, listen: false);
        final isAuthenticated = authState.isAuthenticated;
        final isSplashRoute = state.matchedLocation == '/splash';

        // 스플래시 화면은 항상 접근 가능
        if (isSplashRoute) {
          return null;
        }

        // 인증되지 않은 경우 스플래시로 리다이렉트
        if (!isAuthenticated) {
          return '/splash';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/add-child',
          name: 'add-child',
          builder: (context, state) => const AddChildScreen(),
        ),
      ],
    );
  }
}

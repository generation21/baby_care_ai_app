import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/splash_screen.dart';
import '../states/auth_state.dart';

/// 앱 라우터 설정
///
/// GoRouter를 사용한 라우팅 관리 및 인증 상태 기반 리다이렉션
class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/splash',
      redirect: (context, state) {
        final authState = Provider.of<AuthState>(context, listen: false);
        final isAuthenticated = authState.isAuthenticated;
        final isLoginRoute = state.matchedLocation == '/login';
        final isSignupRoute = state.matchedLocation == '/signup';
        final isSplashRoute = state.matchedLocation == '/splash';

        // 스플래시 화면은 항상 접근 가능
        if (isSplashRoute) {
          return null;
        }

        // 인증되지 않은 사용자가 보호된 경로에 접근하려는 경우
        if (!isAuthenticated && !isLoginRoute && !isSignupRoute) {
          return '/login';
        }

        // 인증된 사용자가 로그인/회원가입 화면에 접근하려는 경우
        if (isAuthenticated && (isLoginRoute || isSignupRoute)) {
          return '/dashboard';
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
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
      ],
    );
  }
}

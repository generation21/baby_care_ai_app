import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../screens/add_child_screen.dart';
import '../screens/ai_chat_screen.dart';
import '../screens/babies_screen.dart';
import '../screens/baby_detail_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/feeding/feeding_timer_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../states/auth_state.dart';

/// 앱 라우터 설정
/// 
/// GoRouter를 사용한 라우팅 관리
/// 디바이스 기반 자동 인증을 사용하므로 로그인/회원가입 화면이 없습니다.
/// 
/// ## 라우트 목록
/// - `/` : 홈 (자동으로 대시보드로 리다이렉트)
/// - `/splash` : 스플래시 화면
/// - `/dashboard` : 대시보드 (메인 화면)
/// - `/babies` : 아기 목록
/// - `/baby/:id` : 아기 상세 정보 (파라미터: babyId)
/// - `/settings` : 설정
/// - `/add-child` : 아기 추가
/// - `/ai-chat` : AI 채팅
/// 
/// ## 인증 리다이렉트 로직
/// - 인증되지 않은 사용자: `/splash`로 리다이렉트
/// - 인증된 사용자가 `/` 접근: `/dashboard`로 리다이렉트
class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final authState = Provider.of<AuthState>(context, listen: false);
        final isAuthenticated = authState.isAuthenticated;
        final currentLocation = state.matchedLocation;

        // 스플래시 화면은 항상 접근 가능
        if (currentLocation == '/splash') {
          return null;
        }

        // 인증되지 않은 경우 스플래시로 리다이렉트
        if (!isAuthenticated) {
          return '/splash';
        }

        // 루트 경로(/)는 대시보드로 리다이렉트
        if (currentLocation == '/') {
          return '/dashboard';
        }

        return null;
      },
      routes: [
        // 루트 경로
        GoRoute(
          path: '/',
          name: 'home',
          redirect: (context, state) => '/dashboard',
        ),
        
        // 스플래시 화면
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        
        // 대시보드 (메인 화면)
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        
        // 아기 목록
        GoRoute(
          path: '/babies',
          name: 'babies',
          builder: (context, state) => const BabiesScreen(),
        ),
        
        // 아기 상세 (파라미터: id)
        GoRoute(
          path: '/baby/:id',
          name: 'baby-detail',
          builder: (context, state) {
            final babyId = state.pathParameters['id']!;
            return BabyDetailScreen(babyId: babyId);
          },
        ),
        
        // 설정
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        
        // 아기 추가
        GoRoute(
          path: '/add-child',
          name: 'add-child',
          builder: (context, state) => const AddChildScreen(),
        ),
        
        // AI 채팅
        GoRoute(
          path: '/ai-chat',
          name: 'ai-chat',
          builder: (context, state) => const AIChatScreen(),
        ),
        
        // 수유 타이머
        GoRoute(
          path: '/feeding-timer/:babyId',
          name: 'feeding-timer',
          builder: (context, state) {
            final babyId = int.parse(state.pathParameters['babyId']!);
            return FeedingTimerScreen(babyId: babyId);
          },
        ),
      ],
    );
  }
}

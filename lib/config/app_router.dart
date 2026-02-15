import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../screens/baby/add_baby_screen.dart';
import '../screens/baby/baby_detail_screen.dart';
import '../screens/baby/baby_list_screen.dart';
import '../screens/baby/edit_baby_screen.dart';
import '../screens/care/add_care_screen.dart';
import '../screens/care/care_detail_screen.dart';
import '../screens/care/care_list_screen.dart';
import '../screens/care/edit_care_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/feeding/add_feeding_screen.dart';
import '../screens/feeding/edit_feeding_screen.dart';
import '../screens/feeding/feeding_detail_screen.dart';
import '../screens/feeding/feeding_list_screen.dart';
import '../screens/feeding/feeding_timer_screen.dart';
import '../screens/gpt/gpt_conversation_detail_screen.dart';
import '../screens/gpt/gpt_conversation_list_screen.dart';
import '../screens/gpt/gpt_question_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/sleep/sleep_tracker_screen.dart';
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
          builder: (context, state) => const BabyListScreen(),
        ),
        
        // 아기 상세 (파라미터: id)
        GoRoute(
          path: '/baby/:id',
          name: 'baby-detail',
          builder: (context, state) {
            final babyId = int.parse(state.pathParameters['id']!);
            return BabyDetailScreen(babyId: babyId);
          },
        ),

        // 아기 수정
        GoRoute(
          path: '/baby/:id/edit',
          name: 'baby-edit',
          builder: (context, state) {
            final babyId = int.parse(state.pathParameters['id']!);
            return EditBabyScreen(babyId: babyId);
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
          builder: (context, state) => const AddBabyScreen(),
        ),

        // 아기 추가 (신규 경로)
        GoRoute(
          path: '/baby/add',
          name: 'baby-add',
          builder: (context, state) => const AddBabyScreen(),
        ),
        
        // AI 채팅
        GoRoute(
          path: '/ai-chat',
          name: 'ai-chat',
          builder: (context, state) => const GPTQuestionScreen(),
        ),

        // GPT 대화 목록
        GoRoute(
          path: '/gpt/:babyId/conversations',
          name: 'gpt-conversation-list',
          builder: (context, state) {
            final babyId = int.parse(state.pathParameters['babyId']!);
            return GPTConversationListScreen(babyId: babyId);
          },
        ),

        // GPT 대화 상세
        GoRoute(
          path: '/gpt/:babyId/conversations/:conversationId',
          name: 'gpt-conversation-detail',
          builder: (context, state) {
            final babyId = int.parse(state.pathParameters['babyId']!);
            final conversationId = int.parse(state.pathParameters['conversationId']!);
            return GPTConversationDetailScreen(
              babyId: babyId,
              conversationId: conversationId,
            );
          },
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

        // 수유 기록 목록
        GoRoute(
          path: '/feeding/:babyId',
          name: 'feeding-list',
          builder: (context, state) {
            final babyId = int.parse(state.pathParameters['babyId']!);
            return FeedingListScreen(babyId: babyId);
          },
        ),

        // 수유 기록 추가
        GoRoute(
          path: '/feeding/:babyId/add',
          name: 'feeding-add',
          builder: (context, state) {
            final babyId = int.parse(state.pathParameters['babyId']!);
            return AddFeedingScreen(babyId: babyId);
          },
        ),

        // 수유 기록 상세
        GoRoute(
          path: '/feeding/:babyId/:recordId',
          name: 'feeding-detail',
          builder: (context, state) {
            final babyId = int.parse(state.pathParameters['babyId']!);
            final recordId = int.parse(state.pathParameters['recordId']!);
            return FeedingDetailScreen(
              babyId: babyId,
              recordId: recordId,
            );
          },
        ),

        // 수유 기록 수정
        GoRoute(
          path: '/feeding/:babyId/:recordId/edit',
          name: 'feeding-edit',
          builder: (context, state) {
            final babyId = int.parse(state.pathParameters['babyId']!);
            final recordId = int.parse(state.pathParameters['recordId']!);
            return EditFeedingScreen(
              babyId: babyId,
              recordId: recordId,
            );
          },
        ),

        // 육아 기록 목록
        GoRoute(
          path: '/care/:babyId',
          name: 'care-list',
          builder: (context, state) {
            final babyId = int.parse(state.pathParameters['babyId']!);
            final recordType = state.uri.queryParameters['type'];
            return CareListScreen(
              babyId: babyId,
              initialRecordType: recordType,
            );
          },
        ),

        // 육아 기록 추가
        GoRoute(
          path: '/care/:babyId/add',
          name: 'care-add',
          builder: (context, state) {
            final babyId = int.parse(state.pathParameters['babyId']!);
            return AddCareScreen(babyId: babyId);
          },
        ),

        // 육아 기록 상세
        GoRoute(
          path: '/care/:babyId/:recordId',
          name: 'care-detail',
          builder: (context, state) {
            final babyId = int.parse(state.pathParameters['babyId']!);
            final recordId = int.parse(state.pathParameters['recordId']!);
            return CareDetailScreen(
              babyId: babyId,
              recordId: recordId,
            );
          },
        ),

        // 육아 기록 수정
        GoRoute(
          path: '/care/:babyId/:recordId/edit',
          name: 'care-edit',
          builder: (context, state) {
            final babyId = int.parse(state.pathParameters['babyId']!);
            final recordId = int.parse(state.pathParameters['recordId']!);
            return EditCareScreen(
              babyId: babyId,
              recordId: recordId,
            );
          },
        ),

        // 수면 추적
        GoRoute(
          path: '/sleep/:babyId',
          name: 'sleep-tracker',
          builder: (context, state) {
            final babyId = int.parse(state.pathParameters['babyId']!);
            return SleepTrackerScreen(babyId: babyId);
          },
        ),
      ],
    );
  }
}

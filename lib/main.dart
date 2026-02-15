import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'clients/api_client.dart';
import 'config/app_router.dart';
import 'config/supabase_config.dart';
import 'services/baby_api_service.dart';
import 'services/feeding_api_service.dart';
import 'services/care_api_service.dart';
import 'services/gpt_api_service.dart';
import 'services/dashboard_api_service.dart';
import 'states/auth_state.dart';
import 'states/baby_state.dart';
import 'states/dashboard_state.dart';
import 'states/feeding_state.dart';
import 'states/care_state.dart';
import 'states/gpt_state.dart';
import 'states/timer_state.dart';
import 'states/theme_state.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  try {
    await SupabaseConfig.initialize();
  } catch (e) {
    debugPrint('Supabase 초기화 오류: $e');
    debugPrint('.env에 SUPABASE_URL, SUPABASE_ANON_KEY를 설정해주세요.');
  }

  runApp(const BabyCareApp());
}

class BabyCareApp extends StatelessWidget {
  const BabyCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // AuthState - 인증 상태 (최우선)
        ChangeNotifierProvider(
          create: (_) => AuthState(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeState()..initialize(),
        ),

        // API 클라이언트 및 서비스 - AuthState에 의존
        ProxyProvider<AuthState, ApiClient>(
          update: (_, authState, __) => authState.apiClient,
        ),

        // API 서비스들 - ApiClient에 의존
        ProxyProvider<ApiClient, BabyApiService>(
          update: (_, apiClient, __) => BabyApiService(apiClient),
        ),
        ProxyProvider<ApiClient, FeedingApiService>(
          update: (_, apiClient, __) => FeedingApiService(apiClient),
        ),
        ProxyProvider<ApiClient, CareApiService>(
          update: (_, apiClient, __) => CareApiService(apiClient),
        ),
        ProxyProvider<ApiClient, GPTApiService>(
          update: (_, apiClient, __) => GPTApiService(apiClient),
        ),
        ProxyProvider<ApiClient, DashboardApiService>(
          update: (_, apiClient, __) => DashboardApiService(apiClient),
        ),

        // 상태 관리 Provider들 - API 서비스에 의존
        ChangeNotifierProxyProvider<BabyApiService, BabyState>(
          create: (context) => BabyState(
            context.read<BabyApiService>(),
          ),
          update: (_, apiService, previous) =>
              previous ?? BabyState(apiService),
        ),
        ChangeNotifierProxyProvider<BabyApiService, DashboardState>(
          create: (context) => DashboardState(
            context.read<BabyApiService>(),
          ),
          update: (_, apiService, previous) =>
              previous ?? DashboardState(apiService),
        ),
        ChangeNotifierProxyProvider<FeedingApiService, FeedingState>(
          create: (context) => FeedingState(
            context.read<FeedingApiService>(),
          ),
          update: (_, apiService, previous) =>
              previous ?? FeedingState(apiService),
        ),
        ChangeNotifierProxyProvider<CareApiService, CareState>(
          create: (context) => CareState(
            context.read<CareApiService>(),
          ),
          update: (_, apiService, previous) =>
              previous ?? CareState(apiService),
        ),
        ChangeNotifierProxyProvider<GPTApiService, GPTState>(
          create: (context) => GPTState(
            context.read<GPTApiService>(),
          ),
          update: (_, apiService, previous) =>
              previous ?? GPTState(apiService),
        ),
        ChangeNotifierProxyProvider<DashboardApiService, TimerState>(
          create: (context) => TimerState(
            context.read<DashboardApiService>(),
          ),
          update: (_, apiService, previous) =>
              previous ?? TimerState(apiService),
        ),
      ],
      child: Consumer<ThemeState>(
        builder: (context, themeState, _) {
          return MaterialApp.router(
            title: 'Baby Care AI',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            routerConfig: AppRouter.createRouter(context),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ko', 'KR'),
              Locale('en', 'US'),
            ],
            locale: const Locale('ko', 'KR'),
          );
        },
      ),
    );
  }
}

import 'dart:async';
import 'dart:ui';

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
import 'services/logging_service.dart';
import 'states/auth_state.dart';
import 'states/baby_state.dart';
import 'states/dashboard_state.dart';
import 'states/feeding_state.dart';
import 'states/care_state.dart';
import 'states/gpt_state.dart';
import 'states/timer_state.dart';
import 'states/theme_state.dart';
import 'theme/app_theme.dart';
import 'widgets/common/network_status_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final loggingService = LoggingService.instance;

  FlutterError.onError = (FlutterErrorDetails details) {
    loggingService.error(
      'Flutter 프레임워크 에러 발생',
      tag: 'GLOBAL-ERROR',
      error: details.exception,
      stackTrace: details.stack,
    );
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    loggingService.error(
      'PlatformDispatcher 에러 발생',
      tag: 'GLOBAL-ERROR',
      error: error,
      stackTrace: stackTrace,
    );
    return true;
  };

  await runZonedGuarded<Future<void>>(
    () async {
      await dotenv.load(fileName: '.env');

      try {
        await SupabaseConfig.initialize();
      } catch (e, stackTrace) {
        loggingService.error(
          'Supabase 초기화 오류',
          tag: 'BOOT',
          error: e,
          stackTrace: stackTrace,
        );
      }

      runApp(const BabyCareApp());
    },
    (error, stackTrace) {
      loggingService.error(
        'runZonedGuarded 처리되지 않은 에러',
        tag: 'GLOBAL-ERROR',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}

class BabyCareApp extends StatelessWidget {
  const BabyCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // AuthState - 인증 상태 (최우선)
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => ThemeState()..initialize()),

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
          create: (context) => BabyState(context.read<BabyApiService>()),
          update: (_, apiService, previous) =>
              previous ?? BabyState(apiService),
        ),
        ChangeNotifierProxyProvider<BabyApiService, DashboardState>(
          create: (context) => DashboardState(context.read<BabyApiService>()),
          update: (_, apiService, previous) =>
              previous ?? DashboardState(apiService),
        ),
        ChangeNotifierProxyProvider<FeedingApiService, FeedingState>(
          create: (context) => FeedingState(context.read<FeedingApiService>()),
          update: (_, apiService, previous) =>
              previous ?? FeedingState(apiService),
        ),
        ChangeNotifierProxyProvider<CareApiService, CareState>(
          create: (context) => CareState(context.read<CareApiService>()),
          update: (_, apiService, previous) =>
              previous ?? CareState(apiService),
        ),
        ChangeNotifierProxyProvider<GPTApiService, GPTState>(
          create: (context) => GPTState(context.read<GPTApiService>()),
          update: (_, apiService, previous) => previous ?? GPTState(apiService),
        ),
        ChangeNotifierProxyProvider<DashboardApiService, TimerState>(
          create: (context) => TimerState(context.read<DashboardApiService>()),
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
            builder: (context, child) {
              if (child == null) {
                return const SizedBox.shrink();
              }
              return NetworkStatusBanner(child: child);
            },
            routerConfig: AppRouter.createRouter(context),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('ko', 'KR'), Locale('en', 'US')],
            locale: const Locale('ko', 'KR'),
          );
        },
      ),
    );
  }
}

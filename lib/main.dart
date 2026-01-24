import 'package:babycareai/router.dart';
import 'package:babycareai/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // 스플래시 화면 유지
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 앱 실행
  runApp(const MyApp());

  // 스플래시 화면 제거
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Base App',
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

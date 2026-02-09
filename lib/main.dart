import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'config/supabase_config.dart';
import 'config/app_router.dart';
import 'states/auth_state.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env 파일 로드
  await dotenv.load(fileName: '.env');

  // Supabase 초기화
  try {
    await SupabaseConfig.initialize();
  } catch (e) {
    debugPrint('Supabase 초기화 오류: $e');
    debugPrint('주의: .env 파일에 SUPABASE_URL과 SUPABASE_ANON_KEY를 설정해주세요.');
  }

  runApp(const BabyCareApp());
}

class BabyCareApp extends StatelessWidget {
  const BabyCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthState(),
      child: MaterialApp.router(
        title: 'Baby Care AI',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.createRouter(context),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

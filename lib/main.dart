import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'config/app_router.dart';
import 'config/supabase_config.dart';
import 'states/auth_state.dart';
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

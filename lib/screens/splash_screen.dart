import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../states/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    debugPrint('[Splash] 스플래시 화면 시작');
    final authState = context.read<AuthState>();

    // 스플래시 최소 2초 표시 + 인증 완료를 동시에 대기 (인증 최대 10초)
    debugPrint('[Splash] 인증 대기 중...');
    await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      Future.any([
        authState.authReady,
        Future.delayed(const Duration(seconds: 10)),
      ]),
    ]);

    debugPrint('[Splash] 인증 완료. 대시보드로 이동...');
    if (!mounted) return;

    context.go('/dashboard');
    debugPrint('[Splash] 대시보드 이동 완료');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Container
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      offset: const Offset(0, 8),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.child_care,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              
              // Branding Text
              Column(
                children: [
                  Text(
                    'Baby Care',
                    style: AppTextStyles.display.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track, Care, Connect',
                    style: AppTextStyles.body2.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Loading Section
              Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading...',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 120),
              
              // Version Info
              Column(
                children: [
                  Text(
                    'Version 1.0.0',
                    style: AppTextStyles.overline.copyWith(
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '© 2026 Baby Care AI',
                    style: AppTextStyles.overline.copyWith(
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

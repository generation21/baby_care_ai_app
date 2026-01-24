import 'package:babycareai/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// 많이 사용하는 테마 옵션만 포함한 예제 테마 클래스입니다.
/// 실제 프로젝트에서는 이를 기반으로 필요한 옵션을 추가하여 사용하세요.
class AppTheme {
  /// 라이트 테마 구성
  ///
  /// 필수 요소:
  /// 1. ColorScheme - 앱의 전반적인 색상 구성
  /// 2. TextTheme - 텍스트 스타일 구성
  /// 3. AppBarTheme - 상단 앱바 스타일 구성
  static ThemeData get lightTheme {
    return ThemeData(
      // Material 3 활성화
      useMaterial3: true,

      // 1. ColorScheme 설정
      // seedColor를 기반으로 자동으로 조화로운 색상 팔레트 생성
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        // 주요 색상 직접 지정
        primary: AppColors.primary,
        onPrimary: Colors.white,
        // 배경 색상
        surface: Colors.white,
        onSurface: Colors.black,
      ),

      // 2. TextTheme 설정
      // 앱 전체의 텍스트 스타일 정의
      textTheme: GoogleFonts.notoSansTextTheme(
        const TextTheme(
          // 가장 자주 사용되는 스타일만 정의
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        ),
      ),

      // 3. AppBarTheme 설정
      // 상단 앱바의 기본 스타일 정의
      appBarTheme: AppBarTheme(
        // 배경을 투명하게 설정하여 깔끔한 디자인 구현
        backgroundColor: Colors.transparent,
        // 그림자 효과 제거로 플랫한 디자인 구현
        elevation: 0,
        // 타이틀을 중앙 정렬
        centerTitle: true,
        // 상태바 스타일 설정
        // dark: 상태바 아이콘을 어두운 색상으로 설정
        // statusBarColor: 상태바 배경을 투명하게 설정
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        // 앱바 타이틀의 텍스트 스타일 설정
        // Noto Sans KR 폰트 적용으로 한글 가독성 최적화
        titleTextStyle: GoogleFonts.notoSansKr(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  /// 다크 테마 구성
  /// 라이트 테마와 동일한 구조를 가지되, 색상만 다르게 설정
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark, // 다크 모드 설정
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: Colors.black,
        surface: Colors.black,
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.notoSansKrTextTheme(
        const TextTheme(
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        ).apply(
          bodyColor: Colors.white, // 다크 모드에서의 기본 텍스트 색상
          displayColor: Colors.white,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        titleTextStyle: GoogleFonts.notoSansKr(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

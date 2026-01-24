import 'package:flutter/material.dart';

/// 앱에서 사용되는 색상을 정의하는 클래스입니다.
/// 색상을 별도의 파일로 분리하는 이유:
/// 1. 관심사 분리 (색상 정의와 테마 로직 분리)
/// 2. 재사용성 (여러 곳에서 색상 임포트하여 사용 가능)
/// 3. 유지보수성 (색상 변경 시 한 곳에서만 수정)
class AppColors {
  // 생성자를 private으로 선언하여 인스턴스화 방지
  AppColors._();

  /// 주 색상 - 앱의 주 색상
  static const Color primary = Color(0xFF2196F3); // Material Blue

  /// 보조 색상 - 주 색상과 조화를 이루는 색상
  static const Color secondary = Color(0xFF03DAC6); // Material Teal

  /// 배경 색상
  static const Color background = Colors.white;

  /// 에러 색상
  static const Color error = Color(0xFFB00020);

  /// 텍스트 색상
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;

  /// 구분선 색상
  static const Color divider = Colors.black12;

  // 추가 색상은 필요에 따라 정의
}

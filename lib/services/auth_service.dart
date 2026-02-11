import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import 'device_service.dart';

/// 인증 관련 예외 클래스
class AppAuthException implements Exception {
  final String message;
  AppAuthException(this.message);

  @override
  String toString() => message;
}

/// 디바이스 기반 인증 서비스 (Supabase 익명 인증)
///
/// Supabase 익명 로그인으로 백엔드 API 인증을 처리합니다.
/// 회원가입/소셜 로그인 없이 기기 정보만으로 자동 인증됩니다.
class AuthService {
  final SupabaseClient _supabase = SupabaseConfig.client;
  final DeviceService _deviceService = DeviceService();

  /// 현재 세션
  Session? get currentSession => _supabase.auth.currentSession;

  /// 현재 사용자
  User? get currentUser => _supabase.auth.currentUser;

  /// Access Token (백엔드 API용)
  String? get accessToken => _supabase.auth.currentSession?.accessToken;

  /// 사용자 ID (Supabase UUID)
  String? get userId => _supabase.auth.currentUser?.id;

  /// 로그인 상태
  bool get isAuthenticated => currentUser != null;

  /// 익명 로그인 (디바이스 기반)
  ///
  /// 앱 시작 시 호출하여 Supabase 익명 사용자를 생성합니다.
  /// 백엔드가 이 토큰을 검증합니다.
  Future<void> autoSignIn() async {
    try {
      final session = _supabase.auth.currentSession;

      if (session != null) {
        print('[AuthService] 기존 세션 존재: ${session.user.id}');
        return;
      }

      print('[AuthService] Supabase signInAnonymously 호출...');
      final response = await _supabase.auth.signInAnonymously();
      print('[AuthService] Supabase signInAnonymously 완료: ${response.user?.id}');
    } on AuthException catch (e) {
      print('[AuthService] Supabase AuthException: ${e.message}');
      throw AppAuthException('자동 로그인에 실패했습니다: ${e.message}');
    } catch (e) {
      print('[AuthService] Supabase 로그인 실패: $e');
      throw AppAuthException('자동 로그인에 실패했습니다: ${e.toString()}');
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw AppAuthException('로그아웃 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  /// 디바이스 ID (디바이스 등록/로그인 이력용)
  Future<String> getDeviceId() => _deviceService.getDeviceId();

  /// 플랫폼 정보
  String get platform => _deviceService.platform;

  /// 앱 ID
  static const String appId = 'app.babycareai';

  /// 토큰 새로고침
  Future<void> refreshToken() async {
    try {
      await _supabase.auth.refreshSession();
    } catch (e) {
      throw AppAuthException('토큰 갱신에 실패했습니다: ${e.toString()}');
    }
  }
}

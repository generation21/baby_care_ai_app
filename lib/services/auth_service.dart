import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

/// 인증 관련 예외 클래스
class AppAuthException implements Exception {
  final String message;
  AppAuthException(this.message);

  @override
  String toString() => message;
}

/// 인증 서비스 클래스
/// 
/// Supabase를 사용한 인증 기능을 제공합니다.
class AuthService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  /// 현재 사용자 세션
  Session? get currentSession => _supabase.auth.currentSession;

  /// 현재 사용자 정보
  User? get currentUser => _supabase.auth.currentUser;

  /// 로그인 상태 확인
  bool get isAuthenticated => currentUser != null;

  /// 이메일과 비밀번호로 회원가입
  /// 
  /// [email] 사용자 이메일
  /// [password] 비밀번호 (최소 6자 이상)
  /// [metadata] 추가 사용자 정보 (선택사항)
  /// 
  /// 반환값: 등록된 사용자 정보
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );

      if (response.user == null) {
        throw AppAuthException('회원가입에 실패했습니다.');
      }

      return response;
    } on AuthException catch (e) {
      throw AppAuthException(_handleSignUpError(e));
    } catch (e) {
      throw AppAuthException('회원가입 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  /// 회원가입 에러 처리
  String _handleSignUpError(AuthException e) {
    final message = e.message.toLowerCase();
    
    if (message.contains('already registered') || 
        message.contains('user already registered')) {
      return '이미 사용 중인 이메일입니다.';
    }
    if (message.contains('invalid email')) {
      return '유효하지 않은 이메일 형식입니다.';
    }
    if (message.contains('weak password') || 
        message.contains('password')) {
      return '비밀번호는 최소 6자 이상이어야 합니다.';
    }
    
    return '회원가입에 실패했습니다: ${e.message}';
  }

  /// 이메일과 비밀번호로 로그인
  /// 
  /// [email] 사용자 이메일
  /// [password] 비밀번호
  /// 
  /// 반환값: 인증 응답
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AppAuthException('로그인에 실패했습니다.');
      }

      return response;
    } on AuthException catch (e) {
      throw AppAuthException(_handleSignInError(e));
    } catch (e) {
      throw AppAuthException('로그인 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  /// 로그인 에러 처리
  String _handleSignInError(AuthException e) {
    final message = e.message.toLowerCase();
    
    if (message.contains('invalid login credentials')) {
      return '이메일 또는 비밀번호가 일치하지 않습니다.';
    }
    if (message.contains('email not confirmed')) {
      return '이메일 확인이 필요합니다. 이메일을 확인해주세요.';
    }
    if (message.contains('user not found')) {
      return '등록되지 않은 이메일입니다.';
    }
    if (message.contains('invalid email')) {
      return '유효하지 않은 이메일 형식입니다.';
    }
    
    return '로그인에 실패했습니다: ${e.message}';
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw AppAuthException('로그아웃 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  /// 비밀번호 재설정 이메일 전송
  /// 
  /// [email] 비밀번호를 재설정할 이메일 주소
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: null, // 앱 내에서 처리할 경우 null
      );
    } catch (e) {
      throw AppAuthException('비밀번호 재설정 이메일 전송 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  /// 현재 세션 새로고침
  Future<Session?> refreshSession() async {
    try {
      final response = await _supabase.auth.refreshSession();
      return response.session;
    } catch (e) {
      return null;
    }
  }

  /// 인증 상태 변경 스트림 구독
  /// 
  /// 로그인/로그아웃 상태 변경을 감지할 수 있습니다.
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}

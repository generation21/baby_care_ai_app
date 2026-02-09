import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../clients/api_client.dart';
import '../clients/api_client.dart' as api;

/// 인증 상태를 관리하는 ChangeNotifier
/// 
/// Provider 패턴을 사용하여 앱 전체에서 인증 상태를 공유합니다.
class AuthState extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiClient _apiClient = ApiClient();
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  /// 현재 사용자 정보
  User? get user => _user;

  /// 로딩 상태
  bool get isLoading => _isLoading;

  /// 에러 메시지
  String? get errorMessage => _errorMessage;

  /// 인증 상태
  bool get isAuthenticated => _user != null;

  AuthState() {
    _initializeAuth();
  }

  /// 인증 상태 초기화
  void _initializeAuth() {
    _user = _authService.currentUser;
    notifyListeners();

    // 인증 상태 변경 감지
    _authService.authStateChanges.listen((authState) {
      _user = authState.session?.user;
      notifyListeners();
    });
  }

  /// 이메일과 비밀번호로 회원가입
  Future<bool> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // 1. Supabase 회원가입
      final response = await _authService.signUp(
        email: email,
        password: password,
        metadata: metadata,
      );

      if (response.user == null) {
        throw AppAuthException('회원가입에 실패했습니다.');
      }

      _user = response.user;

      // 2. 세션이 있으면 서버 API 호출 (이메일 확인이 필요 없는 경우)
      if (response.session != null) {
        await _registerDeviceAndRecordLogin();
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } on AppAuthException catch (e) {
      _setError(e.message);
      _setLoading(false);
      notifyListeners();
      return false;
    } catch (e) {
      _setError('회원가입 중 예상치 못한 오류가 발생했습니다.');
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// 이메일과 비밀번호로 로그인
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // 1. Supabase 로그인
      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AppAuthException('로그인에 실패했습니다.');
      }

      _user = response.user;

      // 2. 로그인 이력 기록 (서버 API)
      await _recordLogin();

      _setLoading(false);
      notifyListeners();
      return true;
    } on AppAuthException catch (e) {
      _setError(e.message);
      _setLoading(false);
      notifyListeners();
      return false;
    } catch (e) {
      _setError('로그인 중 예상치 못한 오류가 발생했습니다.');
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.signOut();
      _user = null;
      _setLoading(false);
      notifyListeners();
    } on AppAuthException catch (e) {
      _setError(e.message);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('로그아웃 중 예상치 못한 오류가 발생했습니다.');
      _setLoading(false);
      notifyListeners();
    }
  }

  /// 비밀번호 재설정 이메일 전송
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      notifyListeners();
      return true;
    } on AppAuthException catch (e) {
      _setError(e.message);
      _setLoading(false);
      notifyListeners();
      return false;
    } catch (e) {
      _setError('비밀번호 재설정 이메일 전송 중 오류가 발생했습니다.');
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// 세션 새로고침
  Future<void> refreshSession() async {
    final session = await _authService.refreshSession();
    if (session != null) {
      _user = session.user;
      notifyListeners();
    }
  }

  /// 로딩 상태 설정
  void _setLoading(bool value) {
    _isLoading = value;
  }

  /// 에러 메시지 설정
  void _setError(String message) {
    _errorMessage = message;
  }

  /// 에러 메시지 초기화
  void _clearError() {
    _errorMessage = null;
  }

  /// 에러 메시지 수동 초기화 (외부에서 호출 가능)
  void clearError() {
    _clearError();
    notifyListeners();
  }

  /// 디바이스 등록 및 로그인 이력 기록 (회원가입 후)
  Future<void> _registerDeviceAndRecordLogin() async {
    try {
      // 디바이스 토큰 가져오기 (현재는 임시로 빈 문자열 사용)
      // TODO: 푸시 알림 토큰을 실제로 가져오도록 구현 필요
      final deviceToken = '';
      
      if (deviceToken.isEmpty) {
        // 디바이스 토큰이 없으면 스킵 (선택적 기능)
        return;
      }

      // 디바이스 등록
      await _apiClient.registerDevice(
        deviceToken: deviceToken,
        platform: api.PlatformInfo.platform,
        appId: api.PlatformInfo.appId,
      );

      // 로그인 이력 기록
      await _apiClient.recordLogin(
        deviceToken: deviceToken,
        appId: api.PlatformInfo.appId,
      );
    } catch (e) {
      // 디바이스 등록 실패는 무시 (선택적 기능)
      debugPrint('디바이스 등록 실패: $e');
    }
  }

  /// 로그인 이력 기록 (로그인 후)
  Future<void> _recordLogin() async {
    try {
      // 디바이스 토큰 가져오기 (현재는 임시로 빈 문자열 사용)
      // TODO: 푸시 알림 토큰을 실제로 가져오도록 구현 필요
      final deviceToken = '';
      
      if (deviceToken.isEmpty) {
        // 디바이스 토큰이 없으면 스킵 (선택적 기능)
        return;
      }

      // 로그인 이력 기록
      await _apiClient.recordLogin(
        deviceToken: deviceToken,
        appId: api.PlatformInfo.appId,
      );
    } catch (e) {
      // 로그인 이력 기록 실패는 무시 (선택적 기능)
      debugPrint('로그인 이력 기록 실패: $e');
    }
  }
}

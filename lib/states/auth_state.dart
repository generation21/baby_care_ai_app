import 'dart:async';
import 'package:flutter/foundation.dart';
import '../clients/api_client.dart';
import '../clients/baby_care_api.dart';
import '../services/auth_service.dart';
import '../services/device_service.dart';

/// 인증 상태 관리
///
/// Supabase 익명 인증 후 백엔드 API(디바이스 등록, 로그인 이력)를 호출합니다.
class AuthState extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final DeviceService _deviceService = DeviceService();
  late final ApiClient _apiClient = ApiClient(_authService);
  late final BabyCareApi _babyCareApi = BabyCareApi(_apiClient);

  bool _isLoading = false;
  String? _errorMessage;
  String? _deviceId;
  Map<String, dynamic>? _deviceInfo;
  final Completer<void> _authCompleter = Completer<void>();

  /// 인증 초기화가 완료될 때까지 대기 (성공/실패 모두)
  Future<void> get authReady => _authCompleter.future;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authService.isAuthenticated;
  String? get userId => _authService.userId;
  String? get deviceId => _deviceId;
  Map<String, dynamic>? get deviceInfo => _deviceInfo;

  ApiClient get apiClient => _apiClient;
  BabyCareApi get babyCareApi => _babyCareApi;

  AuthState() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    await autoSignIn();
  }

  /// 익명 로그인 후 디바이스 등록 및 로그인 이력 기록
  Future<bool> autoSignIn() async {
    debugPrint('[AuthState] autoSignIn 시작');
    _setLoading(true);
    _clearError();

    try {
      debugPrint('[AuthState] 디바이스 ID 가져오기...');
      _deviceId = await _deviceService.getDeviceId();
      _deviceInfo = await _deviceService.getDeviceInfo();
      debugPrint('[AuthState] 디바이스 ID: $_deviceId');

      debugPrint('[AuthState] Supabase 익명 로그인 시작...');
      await _authService.autoSignIn();
      debugPrint('[AuthState] Supabase 익명 로그인 완료. isAuthenticated: ${_authService.isAuthenticated}');

      if (_authService.isAuthenticated) {
        debugPrint('[AuthState] 백엔드 API 호출 시작...');
        await _registerDeviceAndRecordLogin();
        debugPrint('[AuthState] 백엔드 API 호출 완료');
      }

      _setLoading(false);
      if (!_authCompleter.isCompleted) _authCompleter.complete();
      notifyListeners();
      debugPrint('[AuthState] autoSignIn 완료 (성공)');
      return true;
    } on AppAuthException catch (e) {
      debugPrint('[AuthState] autoSignIn 실패 (AppAuthException): ${e.message}');
      _setError(e.message);
      _setLoading(false);
      if (!_authCompleter.isCompleted) _authCompleter.complete();
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('[AuthState] autoSignIn 실패 (Exception): $e');
      _setError('자동 로그인 중 오류가 발생했습니다: ${e.toString()}');
      _setLoading(false);
      if (!_authCompleter.isCompleted) _authCompleter.complete();
      notifyListeners();
      return false;
    }
  }

  /// 디바이스 등록 + 로그인 이력 기록 (백엔드 API)
  Future<void> _registerDeviceAndRecordLogin() async {
    try {
      debugPrint('[API] POST /api/v1/users/devices 호출...');
      await _apiClient.registerDevice(
        deviceToken: _deviceId!,
        platform: _authService.platform,
        appId: AuthService.appId,
      );
      debugPrint('[API] 디바이스 등록 완료');

      debugPrint('[API] POST /api/v1/users/login 호출...');
      await _apiClient.recordLogin(
        deviceToken: _deviceId!,
        appId: AuthService.appId,
      );
      debugPrint('[API] 로그인 이력 기록 완료');
    } catch (e) {
      debugPrint('[API] 디바이스 등록/로그인 이력 기록 실패 (무시): $e');
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    _clearError();
    try {
      await _authService.signOut();
      _setLoading(false);
      notifyListeners();
    } on AppAuthException catch (e) {
      _setError(e.message);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('로그아웃 중 오류가 발생했습니다.');
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> refreshToken() async {
    try {
      await _authService.refreshToken();
      notifyListeners();
    } catch (e) {
      debugPrint('토큰 갱신 실패: $e');
    }
  }

  void _setLoading(bool value) => _isLoading = value;
  void _setError(String message) => _errorMessage = message;
  void _clearError() => _errorMessage = null;
  void clearError() {
    _clearError();
    notifyListeners();
  }
}

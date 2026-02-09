import 'dart:io';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/api_config.dart';

/// API 클라이언트 클래스
/// 
/// 서버 API와 통신하기 위한 Dio 인스턴스를 제공하며,
/// 인증 토큰을 자동으로 헤더에 추가합니다.
class ApiClient {
  late final Dio _dio;
  final SupabaseClient _supabase = Supabase.instance.client;

  ApiClient() {
    _dio = ApiConfig.createDio();
    
    // 인증 인터셉터 추가
    _dio.interceptors.add(AuthInterceptor(_supabase));
  }

  Dio get dio => _dio;

  /// 디바이스 등록
  /// 
  /// [deviceToken] FCM/APNS 토큰
  /// [platform] "ios" 또는 "android"
  /// [appId] 앱 번들 ID
  Future<Map<String, dynamic>> registerDevice({
    required String deviceToken,
    required String platform,
    required String appId,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/users/devices',
        data: {
          'device_token': deviceToken,
          'platform': platform,
          'app_id': appId,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleApiError(e);
    }
  }

  /// 로그인 이력 기록
  /// 
  /// [deviceToken] 디바이스 토큰
  /// [appId] 앱 ID
  Future<Map<String, dynamic>> recordLogin({
    required String deviceToken,
    required String appId,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/users/login',
        data: {
          'device_token': deviceToken,
          'app_id': appId,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleApiError(e);
    }
  }

  /// 사용자 디바이스 목록 조회
  /// 
  /// [userId] 사용자 ID
  Future<List<Map<String, dynamic>>> getUserDevices(String userId) async {
    try {
      final response = await _dio.get(
        '/api/v1/users/$userId/devices',
      );
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleApiError(e);
    }
  }

  String _handleApiError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final data = e.response!.data;
      
      if (statusCode == 401) {
        return '인증이 필요합니다. 다시 로그인해주세요.';
      } else if (statusCode == 403) {
        return '권한이 없습니다.';
      } else if (statusCode == 404) {
        return '요청한 리소스를 찾을 수 없습니다.';
      } else if (data is Map && data.containsKey('error')) {
        return data['error'].toString();
      }
    }
    
    return '서버와 통신 중 오류가 발생했습니다: ${e.message}';
  }
}

/// 인증 인터셉터
/// 
/// 모든 API 요청에 Supabase Access Token을 자동으로 추가합니다.
class AuthInterceptor extends Interceptor {
  final SupabaseClient _supabase;

  AuthInterceptor(this._supabase);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Access Token을 Authorization 헤더에 추가
    final session = _supabase.auth.currentSession;
    
    if (session != null) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 401 에러 시 토큰 갱신 후 재시도
    if (err.response?.statusCode == 401) {
      _handleUnauthorized(err, handler);
    } else {
      handler.next(err);
    }
  }

  Future<void> _handleUnauthorized(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      // Supabase가 자동으로 토큰 갱신
      final response = await _supabase.auth.refreshSession();
      
      if (response.session == null) {
        // 세션이 없으면 로그아웃 처리
        await _supabase.auth.signOut();
        handler.next(err);
        return;
      }
      
      // 원래 요청 재시도
      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer ${response.session!.accessToken}';
      
      final retryResponse = await Dio().fetch(options);
      handler.resolve(retryResponse);
    } catch (e) {
      handler.next(err);
    }
  }
}

/// 플랫폼 정보 유틸리티
class PlatformInfo {
  static String get platform {
    if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isAndroid) {
      return 'android';
    }
    return 'unknown';
  }

  static String get appId {
    // TODO: 실제 앱 ID로 변경 필요
    return 'com.fromnowon.babycare';
  }
}

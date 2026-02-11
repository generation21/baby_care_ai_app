import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../services/auth_service.dart';

/// API 클라이언트
///
/// .env의 API_BASE_URL을 사용하여 백엔드와 통신합니다.
/// Supabase Access Token을 Authorization 헤더에 자동 추가합니다.
class ApiClient {
  late final Dio _dio;
  final AuthService _authService;

  ApiClient(this._authService) {
    _dio = ApiConfig.createDio();
    _dio.interceptors.add(AuthInterceptor(_authService));
  }

  Dio get dio => _dio;

  /// 디바이스 등록
  /// POST /api/v1/users/devices
  Future<Map<String, dynamic>> registerDevice({
    required String deviceToken,
    required String platform,
    required String appId,
  }) async {
    final response = await _dio.post(
      '/api/v1/users/devices',
      data: {
        'device_token': deviceToken,
        'platform': platform,
        'app_id': appId,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// 로그인 이력 기록
  /// POST /api/v1/users/login
  Future<Map<String, dynamic>> recordLogin({
    required String deviceToken,
    required String appId,
  }) async {
    final response = await _dio.post(
      '/api/v1/users/login',
      data: {
        'device_token': deviceToken,
        'app_id': appId,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// 사용자 디바이스 목록 조회
  /// GET /api/v1/users/{user_id}/devices
  Future<List<Map<String, dynamic>>> getUserDevices(String userId) async {
    final response = await _dio.get('/api/v1/users/$userId/devices');
    return List<Map<String, dynamic>>.from(
      (response.data as List).map((e) => Map<String, dynamic>.from(e as Map)),
    );
  }

  /// API 에러 처리
  static String handleApiError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final data = e.response!.data;

      if (statusCode == 401) {
        return '인증이 필요합니다.';
      }
      if (statusCode == 403) {
        return '권한이 없습니다.';
      }
      if (statusCode == 404) {
        return '요청한 리소스를 찾을 수 없습니다.';
      }
      if (data is Map && data['detail'] != null) {
        return data['detail'].toString();
      }
    }
    return '서버와 통신 중 오류가 발생했습니다: ${e.message}';
  }
}

/// 인증 인터셉터
///
/// 모든 요청에 Supabase Access Token을 Bearer로 추가합니다.
class AuthInterceptor extends Interceptor {
  final AuthService _authService;

  AuthInterceptor(this._authService);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = _authService.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
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
      await _authService.refreshToken();
      final options = err.requestOptions;
      final token = _authService.accessToken;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      final dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
      final retryResponse = await dio.fetch(options);
      handler.resolve(retryResponse);
    } catch (_) {
      handler.next(err);
    }
  }
}

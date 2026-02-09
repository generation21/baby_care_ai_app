import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API 설정을 관리하는 클래스
/// 
/// Base URL, 타임아웃 설정 등을 중앙에서 관리합니다.
class ApiConfig {
  /// API Base URL
  /// 
  /// .env 파일의 API_BASE_URL 값을 사용하며,
  /// 기본값은 http://localhost:8000 입니다.
  static String get baseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000';
  }

  /// 연결 타임아웃 (초)
  static const int connectTimeout = 30;

  /// 수신 타임아웃 (초)
  static const int receiveTimeout = 30;

  /// 전송 타임아웃 (초)
  static const int sendTimeout = 30;

  /// Dio 인스턴스 생성
  /// 
  /// 기본 설정이 적용된 Dio 인스턴스를 반환합니다.
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: connectTimeout),
        receiveTimeout: Duration(seconds: receiveTimeout),
        sendTimeout: Duration(seconds: sendTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 인터셉터 추가 (필요시)
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    return dio;
  }

  /// Mock 서비스 사용 여부
  /// 
  /// .env 파일의 USE_MOCK_SERVICE 값을 확인합니다.
  static bool get useMockService {
    return dotenv.env['USE_MOCK_SERVICE']?.toLowerCase() == 'true';
  }
}

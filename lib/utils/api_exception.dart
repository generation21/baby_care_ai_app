import 'package:dio/dio.dart';

/// API 예외 클래스
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic details;

  ApiException({
    required this.statusCode,
    required this.message,
    this.details,
  });

  /// DioException으로부터 ApiException 생성
  factory ApiException.fromDioException(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode ?? 500;
      final data = e.response!.data;

      String message = 'Unknown error';
      dynamic details;

      if (data is Map) {
        // FastAPI 에러 응답 형식 처리
        message = data['error']?.toString() ?? 
                  data['detail']?.toString() ?? 
                  data['message']?.toString() ?? 
                  'Unknown error';
        details = data['details'];
      } else if (data is String) {
        message = data;
      }

      return ApiException(
        statusCode: statusCode,
        message: message,
        details: details,
      );
    } else {
      // 네트워크 오류
      return ApiException(
        statusCode: 0,
        message: 'Network error: ${e.message}',
      );
    }
  }

  @override
  String toString() {
    if (details != null) {
      return 'ApiException($statusCode): $message\nDetails: $details';
    }
    return 'ApiException($statusCode): $message';
  }
}

/// 에러 핸들러
class ErrorHandler {
  /// ApiException으로부터 사용자 친화적인 메시지 생성
  static String getErrorMessage(ApiException e) {
    switch (e.statusCode) {
      case 400:
        return e.message;
      case 401:
        return '로그인이 필요합니다.';
      case 403:
        return '접근 권한이 없습니다.';
      case 404:
        return '데이터를 찾을 수 없습니다.';
      case 422:
        return '입력 데이터를 확인해주세요.\n${e.message}';
      case 500:
        return '서버 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.';
      default:
        if (e.statusCode == 0) {
          return '네트워크 연결을 확인해주세요.';
        }
        return '오류가 발생했습니다.\n${e.message}';
    }
  }

  /// DioException을 ApiException으로 변환하고 사용자 메시지 반환
  static String handleDioError(DioException e) {
    final apiException = ApiException.fromDioException(e);
    return getErrorMessage(apiException);
  }
}

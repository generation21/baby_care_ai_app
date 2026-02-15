import 'package:dio/dio.dart';

/// API 예외 클래스
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic details;
  final bool isNetworkError;
  final bool isTimeout;

  ApiException({
    required this.statusCode,
    required this.message,
    this.details,
    this.isNetworkError = false,
    this.isTimeout = false,
  });

  static const int statusNetworkError = 0;
  static const int statusTimeoutError = -1;
  static const int statusUnknownError = -2;

  static const Map<int, String> _defaultStatusMessages = {
    400: '요청이 올바르지 않습니다.',
    401: '로그인이 필요합니다.',
    403: '접근 권한이 없습니다.',
    404: '요청한 데이터를 찾을 수 없습니다.',
    409: '요청이 현재 상태와 충돌합니다.',
    422: '입력값을 확인해주세요.',
    429: '요청이 너무 많습니다. 잠시 후 다시 시도해주세요.',
    500: '서버 오류가 발생했습니다.',
    502: '서버 연결에 문제가 발생했습니다.',
    503: '서비스를 일시적으로 사용할 수 없습니다.',
    504: '서버 응답 시간이 초과되었습니다.',
  };

  /// DioException으로부터 ApiException 생성
  factory ApiException.fromDioException(DioException e) {
    if (_isTimeoutType(e.type)) {
      return ApiException(
        statusCode: statusTimeoutError,
        message: '네트워크 응답 시간이 초과되었습니다.',
        details: e.message,
        isNetworkError: true,
        isTimeout: true,
      );
    }

    if (_isNetworkType(e.type) || e.response == null) {
      return ApiException(
        statusCode: statusNetworkError,
        message: '네트워크 연결을 확인해주세요.',
        details: e.message,
        isNetworkError: true,
      );
    }

    final response = e.response!;
    final statusCode = response.statusCode ?? statusUnknownError;
    final data = response.data;

    String? responseMessage;
    dynamic details;

    if (data is Map) {
      responseMessage =
          data['error']?.toString() ??
          data['detail']?.toString() ??
          data['message']?.toString();
      details = data['details'];
    } else if (data is String && data.trim().isNotEmpty) {
      responseMessage = data;
    }

    return ApiException(
      statusCode: statusCode,
      message: responseMessage ?? defaultMessageForStatus(statusCode),
      details: details,
    );
  }

  static String defaultMessageForStatus(int statusCode) {
    return _defaultStatusMessages[statusCode] ?? '알 수 없는 오류가 발생했습니다.';
  }

  static bool _isTimeoutType(DioExceptionType type) {
    return type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout;
  }

  static bool _isNetworkType(DioExceptionType type) {
    return type == DioExceptionType.connectionError;
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
    if (e.isTimeout) {
      return '서버 응답이 지연되고 있습니다.\n잠시 후 다시 시도해주세요.';
    }
    if (e.isNetworkError || e.statusCode == ApiException.statusNetworkError) {
      return '인터넷 연결이 원활하지 않습니다.\n네트워크 상태를 확인해주세요.';
    }

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
      case 502:
      case 503:
      case 504:
        return '서버 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.';
      default:
        return '오류가 발생했습니다.\n${e.message}';
    }
  }

  /// DioException을 ApiException으로 변환하고 사용자 메시지 반환
  static String handleDioError(DioException e) {
    final apiException = ApiException.fromDioException(e);
    return getErrorMessage(apiException);
  }

  /// 임의의 예외를 사용자 메시지로 변환
  static String getMessageFromError(Object error) {
    if (error is ApiException) {
      return getErrorMessage(error);
    }
    if (error is DioException) {
      return handleDioError(error);
    }
    return '요청 처리 중 예기치 못한 오류가 발생했습니다.';
  }
}

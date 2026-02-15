import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetworkStatusService {
  NetworkStatusService._();

  static final NetworkStatusService instance = NetworkStatusService._();

  final ValueNotifier<bool> _isOfflineNotifier = ValueNotifier<bool>(false);
  ValueListenable<bool> get isOfflineListenable => _isOfflineNotifier;

  bool get isOffline => _isOfflineNotifier.value;

  void markOnline() {
    _isOfflineNotifier.value = false;
  }

  void markOffline() {
    _isOfflineNotifier.value = true;
  }

  void updateByDioException(DioException exception) {
    final isOfflineError =
        exception.type == DioExceptionType.connectionError ||
        exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.sendTimeout ||
        exception.response == null;

    if (isOfflineError) {
      markOffline();
      return;
    }
    markOnline();
  }
}

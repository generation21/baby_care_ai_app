import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class LoggingService {
  LoggingService._();

  static final LoggingService instance = LoggingService._();
  static const String _defaultTag = 'BabyCareAI';

  bool get _isProduction => kReleaseMode;

  void debug(String message, {String tag = _defaultTag}) {
    _log(LogLevel.debug, message, tag: tag);
  }

  void info(String message, {String tag = _defaultTag}) {
    _log(LogLevel.info, message, tag: tag);
  }

  void warning(String message, {String tag = _defaultTag}) {
    _log(LogLevel.warning, message, tag: tag);
  }

  void error(
    String message, {
    String tag = _defaultTag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void _log(
    LogLevel level,
    String message, {
    required String tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // 프로덕션에서는 warning/error만 출력해 노이즈를 줄입니다.
    if (_isProduction && level != LogLevel.warning && level != LogLevel.error) {
      return;
    }

    final levelLabel = switch (level) {
      LogLevel.debug => 'DEBUG',
      LogLevel.info => 'INFO',
      LogLevel.warning => 'WARN',
      LogLevel.error => 'ERROR',
    };

    final buffer = StringBuffer('[$levelLabel][$tag] $message');
    if (error != null) {
      buffer.write(' | error: $error');
    }
    if (stackTrace != null && !_isProduction) {
      buffer.write('\n$stackTrace');
    }
    debugPrint(buffer.toString());
  }
}

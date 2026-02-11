import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/feeding_record.dart';
import '../services/dashboard_api_service.dart';
import '../utils/api_exception.dart';

/// 타이머 상태
enum TimerStatus {
  idle,
  running,
  paused,
  completed,
}

/// 수유 타이머 상태 관리
/// 
/// 수유 타이머의 시작, 일시정지, 재개, 완료 상태를 관리합니다.
class TimerState extends ChangeNotifier {
  final DashboardApiService _apiService;

  TimerStatus _status = TimerStatus.idle;
  FeedingType? _feedingType;
  String? _side;
  DateTime? _startTime;
  int _elapsedSeconds = 0;
  Timer? _timer;
  String? _errorMessage;

  TimerState(this._apiService);

  // Getters
  TimerStatus get status => _status;
  FeedingType? get feedingType => _feedingType;
  String? get side => _side;
  DateTime? get startTime => _startTime;
  int get elapsedSeconds => _elapsedSeconds;
  String? get errorMessage => _errorMessage;
  bool get isRunning => _status == TimerStatus.running;
  bool get isPaused => _status == TimerStatus.paused;
  bool get isActive => _status == TimerStatus.running || _status == TimerStatus.paused;

  /// 경과 시간 문자열 (MM:SS 형식)
  String get elapsedTimeFormatted {
    final minutes = _elapsedSeconds ~/ 60;
    final seconds = _elapsedSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// 타이머 시작
  void startTimer({
    required FeedingType feedingType,
    String? side,
  }) {
    _status = TimerStatus.running;
    _feedingType = feedingType;
    _side = side;
    _startTime = DateTime.now();
    _elapsedSeconds = 0;
    _clearError();

    _startTicking();
    notifyListeners();
  }

  /// 타이머 일시정지
  void pauseTimer() {
    if (_status != TimerStatus.running) return;

    _status = TimerStatus.paused;
    _stopTicking();
    notifyListeners();
  }

  /// 타이머 재개
  void resumeTimer() {
    if (_status != TimerStatus.paused) return;

    _status = TimerStatus.running;
    _startTicking();
    notifyListeners();
  }

  /// 타이머 완료 및 수유 기록 생성
  Future<FeedingRecord> completeTimer(
    int babyId, {
    int? amount,
  }) async {
    if (_status == TimerStatus.idle || _startTime == null) {
      throw Exception('타이머가 시작되지 않았습니다.');
    }

    _stopTicking();
    _clearError();

    try {
      final timerData = {
        'feeding_type': _getFeedingTypeString(_feedingType!),
        'side': _side,
        'start_time': _startTime!.toIso8601String(),
      };

      final record = await _apiService.completeFeedingTimer(
        babyId,
        timerData: timerData,
        amount: amount,
      );

      _status = TimerStatus.completed;
      notifyListeners();

      // 완료 후 상태 초기화
      Future.delayed(const Duration(seconds: 1), reset);

      return record;
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      _status = TimerStatus.paused;
      notifyListeners();
      rethrow;
    } catch (e) {
      _setError('타이머 완료 중 오류가 발생했습니다.');
      _status = TimerStatus.paused;
      notifyListeners();
      rethrow;
    }
  }

  /// 타이머 취소
  void cancelTimer() {
    _stopTicking();
    reset();
  }

  /// 좌우 전환 (모유 수유 시)
  void switchSide() {
    if (_side == 'left') {
      _side = 'right';
    } else if (_side == 'right') {
      _side = 'left';
    }
    notifyListeners();
  }

  /// 타이머 틱 시작
  void _startTicking() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      notifyListeners();
    });
  }

  /// 타이머 틱 중지
  void _stopTicking() {
    _timer?.cancel();
    _timer = null;
  }

  /// 상태 초기화
  void reset() {
    _stopTicking();
    _status = TimerStatus.idle;
    _feedingType = null;
    _side = null;
    _startTime = null;
    _elapsedSeconds = 0;
    _errorMessage = null;
    notifyListeners();
  }

  /// FeedingType을 문자열로 변환
  String _getFeedingTypeString(FeedingType type) {
    switch (type) {
      case FeedingType.breastMilk:
        return 'breast_milk';
      case FeedingType.formula:
        return 'formula';
      case FeedingType.pumping:
        return 'pumping';
      case FeedingType.solidFood:
        return 'solid_food';
    }
  }

  void _setError(String message) => _errorMessage = message;
  void _clearError() => _errorMessage = null;

  /// 에러 메시지 클리어
  void clearError() {
    _clearError();
    notifyListeners();
  }

  @override
  void dispose() {
    _stopTicking();
    super.dispose();
  }
}

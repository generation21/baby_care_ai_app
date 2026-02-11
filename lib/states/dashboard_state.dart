import 'package:flutter/foundation.dart';
import '../models/dashboard.dart';
import '../services/baby_api_service.dart';
import '../utils/api_exception.dart';

/// Dashboard 상태 관리
/// 
/// 대시보드 데이터 및 로딩 상태를 관리합니다.
class DashboardState extends ChangeNotifier {
  final BabyApiService _apiService;

  Dashboard? _dashboard;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastUpdated;

  DashboardState(this._apiService);

  // Getters
  Dashboard? get dashboard => _dashboard;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get lastUpdated => _lastUpdated;
  bool get hasDashboard => _dashboard != null;

  /// 대시보드 조회
  Future<void> loadDashboard(int babyId) async {
    _setLoading(true);
    _clearError();

    try {
      _dashboard = await _apiService.getDashboard(babyId);
      _lastUpdated = DateTime.now();
      _setLoading(false);
      notifyListeners();
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      _setLoading(false);
      notifyListeners();
      rethrow;
    } catch (e) {
      _setError('대시보드를 불러오는 중 오류가 발생했습니다.');
      _setLoading(false);
      notifyListeners();
      rethrow;
    }
  }

  /// 대시보드 새로고침
  Future<void> refreshDashboard(int babyId) async {
    // 로딩 표시 없이 백그라운드에서 새로고침
    try {
      _dashboard = await _apiService.getDashboard(babyId);
      _lastUpdated = DateTime.now();
      _clearError();
      notifyListeners();
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      notifyListeners();
    } catch (e) {
      _setError('대시보드를 새로고침하는 중 오류가 발생했습니다.');
      notifyListeners();
    }
  }

  /// 대시보드 데이터 강제 새로고침 (로딩 표시)
  Future<void> forceRefresh(int babyId) async {
    await loadDashboard(babyId);
  }

  /// 마지막 업데이트로부터 경과 시간 (초)
  int? get secondsSinceLastUpdate {
    if (_lastUpdated == null) return null;
    return DateTime.now().difference(_lastUpdated!).inSeconds;
  }

  /// 자동 새로고침 필요 여부 (5분 경과)
  bool get needsRefresh {
    if (_lastUpdated == null) return true;
    final seconds = secondsSinceLastUpdate;
    return seconds != null && seconds > 300; // 5분
  }

  /// 상태 초기화
  void reset() {
    _dashboard = null;
    _isLoading = false;
    _errorMessage = null;
    _lastUpdated = null;
    notifyListeners();
  }

  void _setLoading(bool value) => _isLoading = value;
  void _setError(String message) => _errorMessage = message;
  void _clearError() => _errorMessage = null;

  /// 에러 메시지 클리어
  void clearError() {
    _clearError();
    notifyListeners();
  }
}

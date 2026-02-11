import 'package:flutter/foundation.dart';
import '../models/feeding_record.dart';
import '../services/feeding_api_service.dart';
import '../utils/api_exception.dart';

/// Feeding 상태 관리
/// 
/// FeedingRecord 목록 및 페이지네이션 상태를 관리합니다.
class FeedingState extends ChangeNotifier {
  final FeedingApiService _apiService;

  List<FeedingRecord> _records = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  
  // 페이지네이션
  int _offset = 0;
  bool _hasMore = true;
  static const int _pageSize = 50;

  // 필터
  String? _feedingTypeFilter;
  String? _startDateFilter;
  String? _endDateFilter;

  FeedingState(this._apiService);

  // Getters
  List<FeedingRecord> get records => _records;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get hasRecords => _records.isNotEmpty;

  String? get feedingTypeFilter => _feedingTypeFilter;
  String? get startDateFilter => _startDateFilter;
  String? get endDateFilter => _endDateFilter;

  /// 수유 기록 목록 조회 (초기 로드)
  Future<void> loadRecords(
    int babyId, {
    String? feedingType,
    String? startDate,
    String? endDate,
  }) async {
    _setLoading(true);
    _clearError();
    _offset = 0;
    _hasMore = true;

    // 필터 저장
    _feedingTypeFilter = feedingType;
    _startDateFilter = startDate;
    _endDateFilter = endDate;

    try {
      final newRecords = await _apiService.getFeedingRecords(
        babyId,
        feedingType: feedingType,
        startDate: startDate,
        endDate: endDate,
        limit: _pageSize,
        offset: _offset,
      );

      _records = newRecords;
      _offset = newRecords.length;
      _hasMore = newRecords.length == _pageSize;

      _setLoading(false);
      notifyListeners();
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      _setLoading(false);
      notifyListeners();
      rethrow;
    } catch (e) {
      _setError('수유 기록을 불러오는 중 오류가 발생했습니다.');
      _setLoading(false);
      notifyListeners();
      rethrow;
    }
  }

  /// 수유 기록 더 불러오기 (페이지네이션)
  Future<void> loadMore(int babyId) async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final newRecords = await _apiService.getFeedingRecords(
        babyId,
        feedingType: _feedingTypeFilter,
        startDate: _startDateFilter,
        endDate: _endDateFilter,
        limit: _pageSize,
        offset: _offset,
      );

      _records.addAll(newRecords);
      _offset += newRecords.length;
      _hasMore = newRecords.length == _pageSize;

      _isLoadingMore = false;
      notifyListeners();
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _setError('수유 기록을 더 불러오는 중 오류가 발생했습니다.');
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// 수유 기록 생성 (API 호출)
  Future<FeedingRecord> createFeedingRecord(
    int babyId, {
    required FeedingType feedingType,
    int? amount,
    String? unit,
    int? durationMinutes,
    String? side,
    String? notes,
    String? recordedAt,
  }) async {
    try {
      final newRecord = await _apiService.createFeedingRecord(
        babyId,
        feedingType: feedingType,
        amount: amount,
        unit: unit,
        durationMinutes: durationMinutes,
        side: side,
        notes: notes,
        recordedAt: recordedAt,
      );
      
      // 목록 맨 앞에 추가
      _records.insert(0, newRecord);
      notifyListeners();
      
      return newRecord;
    } catch (e) {
      rethrow;
    }
  }

  /// 수유 기록 생성 후 목록에 추가
  void addRecord(FeedingRecord record) {
    _records.insert(0, record);
    notifyListeners();
  }

  /// 수유 기록 수정 후 목록 업데이트
  void updateRecord(FeedingRecord record) {
    final index = _records.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      _records[index] = record;
      notifyListeners();
    }
  }

  /// 수유 기록 삭제 후 목록에서 제거
  void removeRecord(int recordId) {
    _records.removeWhere((r) => r.id == recordId);
    notifyListeners();
  }

  /// 필터 변경
  void setFilters({
    String? feedingType,
    String? startDate,
    String? endDate,
  }) {
    _feedingTypeFilter = feedingType;
    _startDateFilter = startDate;
    _endDateFilter = endDate;
    notifyListeners();
  }

  /// 필터 초기화
  void clearFilters() {
    _feedingTypeFilter = null;
    _startDateFilter = null;
    _endDateFilter = null;
    notifyListeners();
  }

  /// 상태 초기화
  void reset() {
    _records = [];
    _isLoading = false;
    _isLoadingMore = false;
    _errorMessage = null;
    _offset = 0;
    _hasMore = true;
    _feedingTypeFilter = null;
    _startDateFilter = null;
    _endDateFilter = null;
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

import 'package:flutter/foundation.dart';
import '../models/care_record.dart';
import '../services/care_api_service.dart';
import '../utils/api_exception.dart';

/// Care 상태 관리
/// 
/// CareRecord 목록 및 페이지네이션 상태를 관리합니다.
class CareState extends ChangeNotifier {
  final CareApiService _apiService;
  static const int _defaultPageSize = 50;
  static const int _maxPageSize = 100;

  List<CareRecord> _records = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  
  // 페이지네이션
  int _offset = 0;
  bool _hasMore = true;
  int _currentPageSize = _defaultPageSize;

  // 필터
  String? _recordTypeFilter;
  String? _startDateFilter;
  String? _endDateFilter;

  CareState(this._apiService);

  // Getters
  List<CareRecord> get records => _records;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get hasRecords => _records.isNotEmpty;

  String? get recordTypeFilter => _recordTypeFilter;
  String? get startDateFilter => _startDateFilter;
  String? get endDateFilter => _endDateFilter;

  /// 육아 기록 목록 조회 (초기 로드)
  Future<void> loadRecords(
    int babyId, {
    String? recordType,
    String? startDate,
    String? endDate,
    int? limit,
  }) async {
    _setLoading(true);
    _clearError();
    _offset = 0;
    _hasMore = true;
    _currentPageSize = _resolvePageSize(limit);

    // 필터 저장
    _recordTypeFilter = recordType;
    _startDateFilter = startDate;
    _endDateFilter = endDate;

    try {
      final newRecords = await _apiService.getCareRecords(
        babyId,
        recordType: recordType,
        startDate: startDate,
        endDate: endDate,
        limit: _currentPageSize,
        offset: _offset,
      );

      _records = newRecords;
      _offset = newRecords.length;
      _hasMore = newRecords.length == _currentPageSize;

      _setLoading(false);
      notifyListeners();
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      _setLoading(false);
      notifyListeners();
      rethrow;
    } catch (e) {
      _setError('육아 기록을 불러오는 중 오류가 발생했습니다.');
      _setLoading(false);
      notifyListeners();
      rethrow;
    }
  }

  /// 육아 기록 더 불러오기 (페이지네이션)
  Future<void> loadMore(int babyId) async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final newRecords = await _apiService.getCareRecords(
        babyId,
        recordType: _recordTypeFilter,
        startDate: _startDateFilter,
        endDate: _endDateFilter,
        limit: _currentPageSize,
        offset: _offset,
      );

      _records.addAll(newRecords);
      _offset += newRecords.length;
      _hasMore = newRecords.length == _currentPageSize;

      _isLoadingMore = false;
      notifyListeners();
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _setError('육아 기록을 더 불러오는 중 오류가 발생했습니다.');
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// 육아 기록 생성 (API 호출)
  Future<CareRecord> createCareRecord(
    int babyId, {
    required CareRecordType recordType,
    DiaperType? diaperType,
    String? sleepStart,
    String? sleepEnd,
    double? temperature,
    String? temperatureUnit,
    String? medicineName,
    String? medicineDosage,
    String? notes,
    String? recordedAt,
  }) async {
    try {
      final newRecord = await _apiService.createCareRecord(
        babyId,
        recordType: recordType,
        diaperType: diaperType,
        sleepStart: sleepStart,
        sleepEnd: sleepEnd,
        temperature: temperature,
        temperatureUnit: temperatureUnit,
        medicineName: medicineName,
        medicineDosage: medicineDosage,
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

  /// 육아 기록 상세 조회
  Future<CareRecord> getCareRecord(int babyId, int recordId) async {
    try {
      final record = await _apiService.getCareRecord(babyId, recordId);
      final existingIndex = _records.indexWhere((item) => item.id == record.id);
      if (existingIndex >= 0) {
        _records[existingIndex] = record;
        notifyListeners();
      }
      return record;
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      notifyListeners();
      rethrow;
    } catch (e) {
      _setError('육아 기록을 불러오는 중 오류가 발생했습니다.');
      notifyListeners();
      rethrow;
    }
  }

  /// 육아 기록 수정
  Future<CareRecord> editCareRecord(
    int babyId,
    int recordId, {
    CareRecordType? recordType,
    DiaperType? diaperType,
    String? sleepStart,
    String? sleepEnd,
    double? temperature,
    String? temperatureUnit,
    String? medicineName,
    String? medicineDosage,
    String? notes,
    String? recordedAt,
  }) async {
    try {
      final updatedRecord = await _apiService.updateCareRecord(
        babyId,
        recordId,
        recordType: recordType,
        diaperType: diaperType,
        sleepStart: sleepStart,
        sleepEnd: sleepEnd,
        temperature: temperature,
        temperatureUnit: temperatureUnit,
        medicineName: medicineName,
        medicineDosage: medicineDosage,
        notes: notes,
        recordedAt: recordedAt,
      );
      updateRecord(updatedRecord);
      return updatedRecord;
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      notifyListeners();
      rethrow;
    } catch (e) {
      _setError('육아 기록을 수정하는 중 오류가 발생했습니다.');
      notifyListeners();
      rethrow;
    }
  }

  /// 육아 기록 삭제
  Future<void> deleteCareRecord(int babyId, int recordId) async {
    try {
      await _apiService.deleteCareRecord(babyId, recordId);
      removeRecord(recordId);
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      notifyListeners();
      rethrow;
    } catch (e) {
      _setError('육아 기록을 삭제하는 중 오류가 발생했습니다.');
      notifyListeners();
      rethrow;
    }
  }

  /// 수면 기록 시작
  Future<CareRecord> startSleepRecord(
    int babyId, {
    String? notes,
  }) async {
    final nowIsoString = DateTime.now().toIso8601String();
    return createCareRecord(
      babyId,
      recordType: CareRecordType.sleep,
      sleepStart: nowIsoString,
      recordedAt: nowIsoString,
      notes: notes,
    );
  }

  /// 수면 기록 종료
  Future<CareRecord> endSleepRecord(
    int babyId, {
    required int recordId,
    String? notes,
  }) async {
    final nowIsoString = DateTime.now().toIso8601String();
    return editCareRecord(
      babyId,
      recordId,
      sleepEnd: nowIsoString,
      notes: notes,
    );
  }

  /// 육아 기록 생성 후 목록에 추가
  void addRecord(CareRecord record) {
    _records.insert(0, record);
    notifyListeners();
  }

  /// 육아 기록 수정 후 목록 업데이트
  void updateRecord(CareRecord record) {
    final index = _records.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      _records[index] = record;
      notifyListeners();
    }
  }

  /// 육아 기록 삭제 후 목록에서 제거
  void removeRecord(int recordId) {
    _records.removeWhere((r) => r.id == recordId);
    notifyListeners();
  }

  /// 타입별 필터링된 기록 가져오기
  List<CareRecord> getRecordsByType(CareRecordType type) {
    return _records.where((r) => r.recordType == type).toList();
  }

  /// 진행 중인 수면 기록 찾기 (sleep_end가 null인 것)
  CareRecord? get activeSleepRecord {
    try {
      return _records.firstWhere(
        (r) => r.recordType == CareRecordType.sleep && r.sleepEnd == null,
      );
    } catch (e) {
      return null;
    }
  }

  /// 필터 변경
  void setFilters({
    String? recordType,
    String? startDate,
    String? endDate,
  }) {
    _recordTypeFilter = recordType;
    _startDateFilter = startDate;
    _endDateFilter = endDate;
    notifyListeners();
  }

  /// 필터 초기화
  void clearFilters() {
    _recordTypeFilter = null;
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
    _currentPageSize = _defaultPageSize;
    _recordTypeFilter = null;
    _startDateFilter = null;
    _endDateFilter = null;
    notifyListeners();
  }

  void _setLoading(bool value) => _isLoading = value;
  void _setError(String message) => _errorMessage = message;
  void _clearError() => _errorMessage = null;
  int _resolvePageSize(int? limit) {
    if (limit == null || limit <= 0) {
      return _defaultPageSize;
    }
    if (limit > _maxPageSize) {
      return _maxPageSize;
    }
    return limit;
  }

  /// 에러 메시지 클리어
  void clearError() {
    _clearError();
    notifyListeners();
  }
}

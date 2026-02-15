import 'package:dio/dio.dart';
import '../clients/api_client.dart';
import '../models/feeding_record.dart';
import '../models/care_record.dart';
import '../utils/api_exception.dart';

/// Dashboard API 서비스
///
/// 빠른 기록 추가 및 타이머 관리 기능을 제공합니다.
class DashboardApiService {
  final ApiClient _apiClient;
  static const String _basePath = '/api/v1/baby-care-ai/babies';

  DashboardApiService(this._apiClient);

  /// 빠른 수유 기록 추가
  /// POST /api/v1/baby-care-ai/babies/{baby_id}/feeding-records
  ///
  /// 현재 시간으로 간편하게 수유 기록을 추가합니다.
  Future<FeedingRecord> addQuickFeeding(
    int babyId, {
    required FeedingType feedingType,
    int? amount,
    String? unit,
    int? durationMinutes,
    String? side,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();
      final data = <String, dynamic>{
        'feeding_type': _feedingTypeToString(feedingType),
        'recorded_at': now,
      };
      if (amount != null) data['amount'] = amount;
      if (unit != null) data['unit'] = unit;
      if (durationMinutes != null) data['duration_minutes'] = durationMinutes;
      if (side != null) data['side'] = side;

      final response = await _apiClient.dio.post(
        '$_basePath/$babyId/feeding-records',
        data: data,
      );
      _apiClient.invalidateCacheByPrefix('$_basePath/$babyId/dashboard');
      _apiClient.invalidateCacheByPrefix('$_basePath/$babyId/feeding-records');

      return FeedingRecord.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 빠른 기저귀 기록 추가
  /// POST /api/v1/baby-care-ai/babies/{baby_id}/care-records
  ///
  /// 현재 시간으로 간편하게 기저귀 교체 기록을 추가합니다.
  Future<CareRecord> addQuickDiaper(
    int babyId, {
    required DiaperType diaperType,
    String? notes,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();
      final response = await _apiClient.dio.post(
        '$_basePath/$babyId/care-records',
        data: {
          'record_type': 'diaper',
          'diaper_type': _diaperTypeToString(diaperType),
          'recorded_at': now,
          if (notes != null) 'notes': notes,
        },
      );
      _apiClient.invalidateCacheByPrefix('$_basePath/$babyId/dashboard');
      _apiClient.invalidateCacheByPrefix('$_basePath/$babyId/care-records');

      return CareRecord.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 수면 시작
  /// POST /api/v1/baby-care-ai/babies/{baby_id}/care-records
  ///
  /// 수면 시작 시간을 기록합니다 (종료 시간 없음).
  Future<CareRecord> startSleep(int babyId) async {
    try {
      final now = DateTime.now().toIso8601String();
      final response = await _apiClient.dio.post(
        '$_basePath/$babyId/care-records',
        data: {'record_type': 'sleep', 'sleep_start': now, 'recorded_at': now},
      );
      _apiClient.invalidateCacheByPrefix('$_basePath/$babyId/dashboard');
      _apiClient.invalidateCacheByPrefix('$_basePath/$babyId/care-records');

      return CareRecord.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 수면 종료
  /// PUT /api/v1/baby-care-ai/babies/{baby_id}/care-records/{record_id}
  ///
  /// 진행 중인 수면 기록에 종료 시간을 추가합니다.
  Future<CareRecord> endSleep(int babyId, int recordId) async {
    try {
      final now = DateTime.now().toIso8601String();
      final response = await _apiClient.dio.put(
        '$_basePath/$babyId/care-records/$recordId',
        data: {'sleep_end': now},
      );
      _apiClient.invalidateCacheByPrefix('$_basePath/$babyId/dashboard');
      _apiClient.invalidateCacheByPrefix('$_basePath/$babyId/care-records');

      return CareRecord.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 수유 타이머 시작
  ///
  /// 로컬에서 관리되는 타이머 상태를 서버에 동기화합니다.
  /// 실제 기록은 타이머 완료 시 생성됩니다.
  Map<String, dynamic> startFeedingTimer({
    required FeedingType feedingType,
    String? side,
  }) {
    return {
      'feeding_type': _feedingTypeToString(feedingType),
      'side': side,
      'start_time': DateTime.now().toIso8601String(),
    };
  }

  /// 수유 타이머 완료 및 기록 생성
  /// POST /api/v1/baby-care-ai/babies/{baby_id}/feeding-records
  Future<FeedingRecord> completeFeedingTimer(
    int babyId, {
    required Map<String, dynamic> timerData,
    int? amount,
  }) async {
    try {
      final startTime = DateTime.parse(timerData['start_time'] as String);
      final endTime = DateTime.now();
      final durationMinutes = endTime.difference(startTime).inMinutes;

      final data = <String, dynamic>{
        'feeding_type': timerData['feeding_type'],
        'duration_minutes': durationMinutes,
        'recorded_at': startTime.toIso8601String(),
      };
      if (timerData['side'] != null) data['side'] = timerData['side'];
      if (amount != null) data['amount'] = amount;

      final response = await _apiClient.dio.post(
        '$_basePath/$babyId/feeding-records',
        data: data,
      );
      _apiClient.invalidateCacheByPrefix('$_basePath/$babyId/dashboard');
      _apiClient.invalidateCacheByPrefix('$_basePath/$babyId/feeding-records');

      return FeedingRecord.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// FeedingType Enum을 문자열로 변환
  String _feedingTypeToString(FeedingType type) {
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

  /// DiaperType Enum을 문자열로 변환
  String _diaperTypeToString(DiaperType type) {
    switch (type) {
      case DiaperType.wet:
        return 'wet';
      case DiaperType.dirty:
        return 'dirty';
      case DiaperType.both:
        return 'both';
    }
  }
}

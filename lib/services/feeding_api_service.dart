import 'package:dio/dio.dart';
import '../clients/api_client.dart';
import '../models/feeding_record.dart';
import '../utils/api_exception.dart';

/// Feeding API 서비스
/// 
/// 수유 기록 CRUD 기능을 제공합니다.
class FeedingApiService {
  final ApiClient _apiClient;
  static const String _basePath = '/api/v1/baby-care-ai/babies';

  FeedingApiService(this._apiClient);

  /// 수유 기록 목록 조회
  /// GET /api/v1/baby-care-ai/babies/{baby_id}/feeding-records
  Future<List<FeedingRecord>> getFeedingRecords(
    int babyId, {
    String? feedingType,
    String? startDate,
    String? endDate,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit,
        'offset': offset,
      };
      if (feedingType != null) queryParams['feeding_type'] = feedingType;
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;

      final response = await _apiClient.dio.get(
        '$_basePath/$babyId/feeding-records',
        queryParameters: queryParams,
      );

      return (response.data as List)
          .map((json) => FeedingRecord.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 수유 기록 상세 조회
  /// GET /api/v1/baby-care-ai/babies/{baby_id}/feeding-records/{record_id}
  Future<FeedingRecord> getFeedingRecord(int babyId, int recordId) async {
    try {
      final response = await _apiClient.dio.get(
        '$_basePath/$babyId/feeding-records/$recordId',
      );

      return FeedingRecord.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 수유 기록 생성
  /// POST /api/v1/baby-care-ai/babies/{baby_id}/feeding-records
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
      final data = <String, dynamic>{
        'feeding_type': _feedingTypeToString(feedingType),
      };
      if (amount != null) data['amount'] = amount;
      if (unit != null) data['unit'] = unit;
      if (durationMinutes != null) data['duration_minutes'] = durationMinutes;
      if (side != null) data['side'] = side;
      if (notes != null) data['notes'] = notes;
      if (recordedAt != null) data['recorded_at'] = recordedAt;

      final response = await _apiClient.dio.post(
        '$_basePath/$babyId/feeding-records',
        data: data,
      );

      return FeedingRecord.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 수유 기록 수정
  /// PUT /api/v1/baby-care-ai/babies/{baby_id}/feeding-records/{record_id}
  Future<FeedingRecord> updateFeedingRecord(
    int babyId,
    int recordId, {
    FeedingType? feedingType,
    int? amount,
    String? unit,
    int? durationMinutes,
    String? side,
    String? notes,
    String? recordedAt,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (feedingType != null) {
        data['feeding_type'] = _feedingTypeToString(feedingType);
      }
      if (amount != null) data['amount'] = amount;
      if (unit != null) data['unit'] = unit;
      if (durationMinutes != null) data['duration_minutes'] = durationMinutes;
      if (side != null) data['side'] = side;
      if (notes != null) data['notes'] = notes;
      if (recordedAt != null) data['recorded_at'] = recordedAt;

      final response = await _apiClient.dio.put(
        '$_basePath/$babyId/feeding-records/$recordId',
        data: data,
      );

      return FeedingRecord.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 수유 기록 삭제
  /// DELETE /api/v1/baby-care-ai/babies/{baby_id}/feeding-records/{record_id}
  Future<void> deleteFeedingRecord(int babyId, int recordId) async {
    try {
      await _apiClient.dio.delete(
        '$_basePath/$babyId/feeding-records/$recordId',
      );
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
}

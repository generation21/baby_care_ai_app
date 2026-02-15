import 'package:dio/dio.dart';
import '../clients/api_client.dart';
import '../models/care_record.dart';
import '../utils/api_exception.dart';

/// Care API 서비스
///
/// 육아 기록(기저귀, 수면, 목욕, 약, 체온 등) CRUD 기능을 제공합니다.
class CareApiService {
  final ApiClient _apiClient;
  static const String _basePath = '/api/v1/baby-care-ai/babies';
  static const Duration _defaultCacheTtl = Duration(minutes: 5);

  CareApiService(this._apiClient);

  /// 육아 기록 목록 조회
  /// GET /api/v1/baby-care-ai/babies/{baby_id}/care-records
  Future<List<CareRecord>> getCareRecords(
    int babyId, {
    String? recordType,
    String? startDate,
    String? endDate,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit, 'offset': offset};
      if (recordType != null) queryParams['record_type'] = recordType;
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;

      final response = await _apiClient.get(
        '$_basePath/$babyId/care-records',
        queryParameters: queryParams,
        cacheTtl: _defaultCacheTtl,
      );

      return (response.data as List)
          .map((json) => CareRecord.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 육아 기록 상세 조회
  /// GET /api/v1/baby-care-ai/babies/{baby_id}/care-records/{record_id}
  Future<CareRecord> getCareRecord(int babyId, int recordId) async {
    try {
      final response = await _apiClient.get(
        '$_basePath/$babyId/care-records/$recordId',
        cacheTtl: _defaultCacheTtl,
      );

      return CareRecord.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 육아 기록 생성
  /// POST /api/v1/baby-care-ai/babies/{baby_id}/care-records
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
      final data = <String, dynamic>{
        'record_type': _careRecordTypeToString(recordType),
      };
      if (diaperType != null) {
        data['diaper_type'] = _diaperTypeToString(diaperType);
      }
      if (sleepStart != null) data['sleep_start'] = sleepStart;
      if (sleepEnd != null) data['sleep_end'] = sleepEnd;
      if (temperature != null) data['temperature'] = temperature;
      if (temperatureUnit != null) data['temperature_unit'] = temperatureUnit;
      if (medicineName != null) data['medicine_name'] = medicineName;
      if (medicineDosage != null) data['medicine_dosage'] = medicineDosage;
      if (notes != null) data['notes'] = notes;
      if (recordedAt != null) data['recorded_at'] = recordedAt;

      final response = await _apiClient.dio.post(
        '$_basePath/$babyId/care-records',
        data: data,
      );
      _apiClient.invalidateCacheByPrefix('$_basePath/$babyId/care-records');

      return CareRecord.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 육아 기록 수정
  /// PUT /api/v1/baby-care-ai/babies/{baby_id}/care-records/{record_id}
  Future<CareRecord> updateCareRecord(
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
      final data = <String, dynamic>{};
      if (recordType != null) {
        data['record_type'] = _careRecordTypeToString(recordType);
      }
      if (diaperType != null) {
        data['diaper_type'] = _diaperTypeToString(diaperType);
      }
      if (sleepStart != null) data['sleep_start'] = sleepStart;
      if (sleepEnd != null) data['sleep_end'] = sleepEnd;
      if (temperature != null) data['temperature'] = temperature;
      if (temperatureUnit != null) data['temperature_unit'] = temperatureUnit;
      if (medicineName != null) data['medicine_name'] = medicineName;
      if (medicineDosage != null) data['medicine_dosage'] = medicineDosage;
      if (notes != null) data['notes'] = notes;
      if (recordedAt != null) data['recorded_at'] = recordedAt;

      final response = await _apiClient.dio.put(
        '$_basePath/$babyId/care-records/$recordId',
        data: data,
      );
      _apiClient.invalidateCacheByPrefix('$_basePath/$babyId/care-records');

      return CareRecord.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 육아 기록 삭제
  /// DELETE /api/v1/baby-care-ai/babies/{baby_id}/care-records/{record_id}
  Future<void> deleteCareRecord(int babyId, int recordId) async {
    try {
      await _apiClient.dio.delete('$_basePath/$babyId/care-records/$recordId');
      _apiClient.invalidateCacheByPrefix('$_basePath/$babyId/care-records');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// CareRecordType Enum을 문자열로 변환
  String _careRecordTypeToString(CareRecordType type) {
    switch (type) {
      case CareRecordType.diaper:
        return 'diaper';
      case CareRecordType.sleep:
        return 'sleep';
      case CareRecordType.bath:
        return 'bath';
      case CareRecordType.medicine:
        return 'medicine';
      case CareRecordType.temperature:
        return 'temperature';
      case CareRecordType.other:
        return 'other';
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

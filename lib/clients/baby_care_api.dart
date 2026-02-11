import 'package:flutter/foundation.dart';
import 'api_client.dart';

/// Baby Care AI API 클라이언트
///
/// /api/v1/baby-care-ai 엔드포인트와 통신합니다.
/// ApiClient를 이용해 인증된 요청을 보냅니다.
class BabyCareApi {
  final ApiClient _apiClient;

  BabyCareApi(ApiClient apiClient) : _apiClient = apiClient;

  String get _basePath => '/api/v1/baby-care-ai';

  /// 아이 목록 조회
  /// GET /api/v1/baby-care-ai/babies
  Future<List<Map<String, dynamic>>> getBabies({
    bool? isActive,
    int limit = 50,
    int offset = 0,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    if (isActive != null) queryParams['is_active'] = isActive;

    final response = await _apiClient.dio.get(
      '$_basePath/babies',
      queryParameters: queryParams,
    );
    return List<Map<String, dynamic>>.from(
      (response.data as List).map((e) => Map<String, dynamic>.from(e as Map)),
    );
  }

  /// 아이 등록
  /// POST /api/v1/baby-care-ai/babies
  Future<Map<String, dynamic>> createBaby(Map<String, dynamic> data) async {
    debugPrint('🌐 BabyCareApi - POST 요청: $_basePath/babies');
    debugPrint('🌐 BabyCareApi - 요청 데이터: $data');
    final response = await _apiClient.dio.post('$_basePath/babies', data: data);
    debugPrint('🌐 BabyCareApi - 응답 상태: ${response.statusCode}');
    debugPrint('🌐 BabyCareApi - 응답 데이터: ${response.data}');
    return response.data as Map<String, dynamic>;
  }

  /// 아이 상세 조회
  /// GET /api/v1/baby-care-ai/babies/{baby_id}
  Future<Map<String, dynamic>> getBaby(int babyId) async {
    final response = await _apiClient.dio.get('$_basePath/babies/$babyId');
    return response.data as Map<String, dynamic>;
  }

  /// 대시보드 조회
  /// GET /api/v1/baby-care-ai/babies/{baby_id}/dashboard
  Future<Map<String, dynamic>> getDashboard(
    int babyId, {
    DateTime? date,
  }) async {
    final queryParams = date != null
        ? {'date': date.toIso8601String()}
        : null;
    final response = await _apiClient.dio.get(
      '$_basePath/babies/$babyId/dashboard',
      queryParameters: queryParams,
    );
    return response.data as Map<String, dynamic>;
  }

  /// 빠른 기록 추가
  /// POST /api/v1/baby-care-ai/babies/{baby_id}/quick-record
  Future<Map<String, dynamic>> createQuickRecord(
    int babyId,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.dio.post(
      '$_basePath/babies/$babyId/quick-record',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }
}

import 'package:dio/dio.dart';
import '../clients/api_client.dart';
import '../models/baby.dart';
import '../models/dashboard.dart';
import '../utils/api_exception.dart';

/// Baby API 서비스
/// 
/// Baby 프로필 CRUD 및 대시보드 조회 기능을 제공합니다.
class BabyApiService {
  final ApiClient _apiClient;
  static const String _basePath = '/api/v1/baby-care-ai/babies';

  BabyApiService(this._apiClient);

  /// 아이 목록 조회
  /// GET /api/v1/baby-care-ai/babies
  Future<List<Baby>> getBabies({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        _basePath,
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      return (response.data as List)
          .map((json) => Baby.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 아이 상세 조회
  /// GET /api/v1/baby-care-ai/babies/{baby_id}
  Future<Baby> getBaby(int babyId) async {
    try {
      final response = await _apiClient.dio.get('$_basePath/$babyId');
      return Baby.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 아이 프로필 생성
  /// POST /api/v1/baby-care-ai/babies
  Future<Baby> createBaby({
    required String name,
    required String birthDate,
    String? gender,
    String? photo,
    String? bloodType,
    Map<String, dynamic>? notes,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        _basePath,
        data: {
          'name': name,
          'birth_date': birthDate,
          if (gender != null) 'gender': gender,
          if (photo != null) 'photo': photo,
          if (bloodType != null) 'blood_type': bloodType,
          if (notes != null) 'notes': notes,
        },
      );

      return Baby.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 아이 정보 수정
  /// PUT /api/v1/baby-care-ai/babies/{baby_id}
  Future<Baby> updateBaby(
    int babyId, {
    String? name,
    String? birthDate,
    String? gender,
    String? photo,
    String? bloodType,
    Map<String, dynamic>? notes,
    bool? isActive,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (birthDate != null) data['birth_date'] = birthDate;
      if (gender != null) data['gender'] = gender;
      if (photo != null) data['photo'] = photo;
      if (bloodType != null) data['blood_type'] = bloodType;
      if (notes != null) data['notes'] = notes;
      if (isActive != null) data['is_active'] = isActive;

      final response = await _apiClient.dio.put(
        '$_basePath/$babyId',
        data: data,
      );

      return Baby.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 아이 삭제 (비활성화)
  /// DELETE /api/v1/baby-care-ai/babies/{baby_id}
  Future<void> deleteBaby(int babyId) async {
    try {
      await _apiClient.dio.delete('$_basePath/$babyId');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 대시보드 조회
  /// GET /api/v1/baby-care-ai/babies/{baby_id}/dashboard
  Future<Dashboard> getDashboard(int babyId) async {
    try {
      final response = await _apiClient.dio.get(
        '$_basePath/$babyId/dashboard',
      );

      return Dashboard.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

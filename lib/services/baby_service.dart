import 'package:flutter/foundation.dart';
import '../clients/baby_care_api.dart';
import '../models/baby.dart';

/// 아이 관리 서비스
class BabyService {
  final BabyCareApi _babyCareApi;

  BabyService(this._babyCareApi);

  /// 아이 목록 조회
  Future<List<Baby>> getBabies({
    bool? isActive,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _babyCareApi.getBabies(
        isActive: isActive,
        limit: limit,
        offset: offset,
      );
      return response.map((json) => Baby.fromJson(json)).toList();
    } catch (e) {
      throw Exception('아이 목록 조회 실패: $e');
    }
  }

  /// 아이 등록
  Future<Baby> createBaby({
    required String name,
    required DateTime birthDate,
    String? gender,
    String? photo,
    String? bloodType,
    double? birthHeight,
    double? birthWeight,
    String? notes,
  }) async {
    try {
      final data = {
        'name': name,
        'birth_date': birthDate.toIso8601String().split('T')[0],
        if (gender != null) 'gender': gender,
        if (photo != null) 'photo': photo,
        if (bloodType != null) 'blood_type': bloodType,
        if (birthHeight != null) 'birth_height': birthHeight,
        if (birthWeight != null) 'birth_weight': birthWeight,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      };

      debugPrint('📦 BabyService - 전송할 데이터: $data');
      final response = await _babyCareApi.createBaby(data);
      debugPrint('📦 BabyService - 응답 받음: $response');
      return Baby.fromJson(response);
    } catch (e) {
      debugPrint('📦 BabyService - 에러 발생: $e');
      throw Exception('아이 등록 실패: $e');
    }
  }

  /// 아이 상세 조회
  Future<Baby> getBaby(int babyId) async {
    try {
      final response = await _babyCareApi.getBaby(babyId);
      return Baby.fromJson(response);
    } catch (e) {
      throw Exception('아이 정보 조회 실패: $e');
    }
  }

  /// 대시보드 조회
  Future<Map<String, dynamic>> getDashboard(
    int babyId, {
    DateTime? date,
  }) async {
    try {
      return await _babyCareApi.getDashboard(babyId, date: date);
    } catch (e) {
      throw Exception('대시보드 조회 실패: $e');
    }
  }
}

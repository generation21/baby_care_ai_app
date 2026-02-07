# BabyCareAI Flutter 클라이언트 통합 가이드

## 개요
이 문서는 Flutter 앱에서 BabyCareAI API를 통합하는 방법을 설명합니다.

## 📋 목차
1. [환경 설정](#환경-설정)
2. [인증](#인증)
3. [API 클라이언트 구현](#api-클라이언트-구현)
4. [데이터 모델](#데이터-모델)
5. [API 엔드포인트](#api-엔드포인트)
6. [에러 처리](#에러-처리)
7. [베스트 프랙티스](#베스트-프랙티스)

---

## 환경 설정

### 필수 패키지 설치

`pubspec.yaml`에 다음 패키지를 추가하세요:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # HTTP 통신
  http: ^1.2.0
  dio: ^5.4.0  # 또는 http 패키지
  
  # 상태 관리
  provider: ^6.1.1  # 또는 riverpod, bloc 등
  
  # JSON 직렬화
  json_annotation: ^4.8.1
  
  # 로컬 저장소 (토큰 저장)
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.2

dev_dependencies:
  # JSON 코드 생성
  build_runner: ^2.4.8
  json_serializable: ^6.7.1
```

### API 기본 설정

```dart
// lib/config/api_config.dart

class ApiConfig {
  static const String baseUrl = 'https://your-api-domain.com/api/v1';
  
  // 개발 환경
  static const String devBaseUrl = 'http://localhost:8000/api/v1';
  
  // 프로덕션 환경
  static const String prodBaseUrl = 'https://api.fromnowon.com/api/v1';
  
  // 환경에 따라 자동 선택
  static String get apiBaseUrl {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    return env == 'prod' ? prodBaseUrl : devBaseUrl;
  }
  
  // 타임아웃 설정
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
```

---

## 인증

### Firebase Auth 통합

BabyCareAI API는 Firebase Authentication을 사용합니다.

```dart
// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  static const String _tokenKey = 'firebase_id_token';
  
  // 현재 사용자
  User? get currentUser => _auth.currentUser;
  
  // 로그인 상태 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // ID 토큰 가져오기
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    final user = currentUser;
    if (user == null) return null;
    
    try {
      final token = await user.getIdToken(forceRefresh);
      if (token != null) {
        await _storage.write(key: _tokenKey, value: token);
      }
      return token;
    } catch (e) {
      print('Error getting ID token: $e');
      return null;
    }
  }
  
  // 저장된 토큰 가져오기
  Future<String?> getCachedToken() async {
    return await _storage.read(key: _tokenKey);
  }
  
  // 이메일/비밀번호 로그인
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  // 회원가입
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  // 로그아웃
  Future<void> signOut() async {
    await _storage.delete(key: _tokenKey);
    await _auth.signOut();
  }
}
```

---

## API 클라이언트 구현

### Dio를 사용한 HTTP 클라이언트

```dart
// lib/services/api_client.dart

import 'package:dio/dio.dart';
import 'api_config.dart';
import 'auth_service.dart';

class ApiClient {
  late final Dio _dio;
  final AuthService _authService;
  
  ApiClient(this._authService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.apiBaseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    _dio.interceptors.add(AuthInterceptor(_authService));
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
  
  Dio get dio => _dio;
}

// 인증 인터셉터
class AuthInterceptor extends Interceptor {
  final AuthService _authService;
  
  AuthInterceptor(this._authService);
  
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // ID 토큰 추가
    final token = await _authService.getIdToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // 토큰 만료 시 재로그인 필요
      _authService.signOut();
    }
    handler.next(err);
  }
}
```

---

## 데이터 모델

### Baby 모델

```dart
// lib/models/baby.dart

import 'package:json_annotation/json_annotation.dart';

part 'baby.g.dart';

@JsonSerializable()
class Baby {
  final int id;
  final String name;
  @JsonKey(name: 'birth_date')
  final String birthDate;
  final String? gender;
  final String? photo;
  @JsonKey(name: 'blood_type')
  final String? bloodType;
  final Map<String, dynamic>? notes;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  
  Baby({
    required this.id,
    required this.name,
    required this.birthDate,
    this.gender,
    this.photo,
    this.bloodType,
    this.notes,
    required this.isActive,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory Baby.fromJson(Map<String, dynamic> json) => _$BabyFromJson(json);
  Map<String, dynamic> toJson() => _$BabyToJson(this);
  
  // 나이 계산
  int get ageInDays {
    final birthDateTime = DateTime.parse(birthDate);
    return DateTime.now().difference(birthDateTime).inDays;
  }
  
  int get ageInMonths => (ageInDays / 30).floor();
}
```

### FeedingRecord 모델

```dart
// lib/models/feeding_record.dart

import 'package:json_annotation/json_annotation.dart';

part 'feeding_record.g.dart';

enum FeedingType {
  @JsonValue('breast_milk')
  breastMilk,
  @JsonValue('formula')
  formula,
  @JsonValue('pumping')
  pumping,
  @JsonValue('solid_food')
  solidFood,
}

@JsonSerializable()
class FeedingRecord {
  final int id;
  @JsonKey(name: 'baby_id')
  final int babyId;
  @JsonKey(name: 'feeding_type')
  final FeedingType feedingType;
  final int? amount;
  final String? unit;
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;
  final String? side;
  final String? notes;
  @JsonKey(name: 'recorded_at')
  final String recordedAt;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  
  FeedingRecord({
    required this.id,
    required this.babyId,
    required this.feedingType,
    this.amount,
    this.unit,
    this.durationMinutes,
    this.side,
    this.notes,
    required this.recordedAt,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory FeedingRecord.fromJson(Map<String, dynamic> json) =>
      _$FeedingRecordFromJson(json);
  Map<String, dynamic> toJson() => _$FeedingRecordToJson(this);
}
```

### CareRecord 모델

```dart
// lib/models/care_record.dart

import 'package:json_annotation/json_annotation.dart';

part 'care_record.g.dart';

enum CareRecordType {
  @JsonValue('diaper')
  diaper,
  @JsonValue('sleep')
  sleep,
  @JsonValue('bath')
  bath,
  @JsonValue('medicine')
  medicine,
  @JsonValue('temperature')
  temperature,
  @JsonValue('other')
  other,
}

enum DiaperType {
  @JsonValue('wet')
  wet,
  @JsonValue('dirty')
  dirty,
  @JsonValue('both')
  both,
}

@JsonSerializable()
class CareRecord {
  final int id;
  @JsonKey(name: 'baby_id')
  final int babyId;
  @JsonKey(name: 'record_type')
  final CareRecordType recordType;
  @JsonKey(name: 'diaper_type')
  final DiaperType? diaperType;
  @JsonKey(name: 'sleep_start')
  final String? sleepStart;
  @JsonKey(name: 'sleep_end')
  final String? sleepEnd;
  final double? temperature;
  @JsonKey(name: 'temperature_unit')
  final String? temperatureUnit;
  @JsonKey(name: 'medicine_name')
  final String? medicineName;
  @JsonKey(name: 'medicine_dosage')
  final String? medicineDosage;
  final String? notes;
  @JsonKey(name: 'recorded_at')
  final String recordedAt;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  
  CareRecord({
    required this.id,
    required this.babyId,
    required this.recordType,
    this.diaperType,
    this.sleepStart,
    this.sleepEnd,
    this.temperature,
    this.temperatureUnit,
    this.medicineName,
    this.medicineDosage,
    this.notes,
    required this.recordedAt,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory CareRecord.fromJson(Map<String, dynamic> json) =>
      _$CareRecordFromJson(json);
  Map<String, dynamic> toJson() => _$CareRecordToJson(this);
  
  // 수면 시간 계산 (분)
  int? get sleepDurationMinutes {
    if (sleepStart == null || sleepEnd == null) return null;
    final start = DateTime.parse(sleepStart!);
    final end = DateTime.parse(sleepEnd!);
    return end.difference(start).inMinutes;
  }
}
```

### GPTConversation 모델

```dart
// lib/models/gpt_conversation.dart

import 'package:json_annotation/json_annotation.dart';

part 'gpt_conversation.g.dart';

@JsonSerializable()
class GPTConversation {
  final int id;
  @JsonKey(name: 'baby_id')
  final int babyId;
  final String question;
  final String answer;
  @JsonKey(name: 'context_data')
  final Map<String, dynamic>? contextData;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  
  GPTConversation({
    required this.id,
    required this.babyId,
    required this.question,
    required this.answer,
    this.contextData,
    required this.userId,
    required this.createdAt,
  });
  
  factory GPTConversation.fromJson(Map<String, dynamic> json) =>
      _$GPTConversationFromJson(json);
  Map<String, dynamic> toJson() => _$GPTConversationToJson(this);
}
```

### Dashboard 모델

```dart
// lib/models/dashboard.dart

import 'package:json_annotation/json_annotation.dart';
import 'feeding_record.dart';
import 'care_record.dart';

part 'dashboard.g.dart';

@JsonSerializable()
class Dashboard {
  @JsonKey(name: 'baby_info')
  final BabyInfo babyInfo;
  @JsonKey(name: 'latest_feeding')
  final FeedingRecord? latestFeeding;
  @JsonKey(name: 'latest_diaper')
  final CareRecord? latestDiaper;
  @JsonKey(name: 'latest_sleep')
  final CareRecord? latestSleep;
  @JsonKey(name: 'today_summary')
  final TodaySummary todaySummary;
  @JsonKey(name: 'weekly_summary')
  final WeeklySummary weeklySummary;
  
  Dashboard({
    required this.babyInfo,
    this.latestFeeding,
    this.latestDiaper,
    this.latestSleep,
    required this.todaySummary,
    required this.weeklySummary,
  });
  
  factory Dashboard.fromJson(Map<String, dynamic> json) =>
      _$DashboardFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardToJson(this);
}

@JsonSerializable()
class BabyInfo {
  final int id;
  final String name;
  @JsonKey(name: 'birth_date')
  final String birthDate;
  @JsonKey(name: 'age_in_days')
  final int ageInDays;
  
  BabyInfo({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.ageInDays,
  });
  
  factory BabyInfo.fromJson(Map<String, dynamic> json) =>
      _$BabyInfoFromJson(json);
  Map<String, dynamic> toJson() => _$BabyInfoToJson(this);
}

@JsonSerializable()
class TodaySummary {
  @JsonKey(name: 'feeding_count')
  final int feedingCount;
  @JsonKey(name: 'diaper_count')
  final int diaperCount;
  @JsonKey(name: 'sleep_hours')
  final double sleepHours;
  
  TodaySummary({
    required this.feedingCount,
    required this.diaperCount,
    required this.sleepHours,
  });
  
  factory TodaySummary.fromJson(Map<String, dynamic> json) =>
      _$TodaySummaryFromJson(json);
  Map<String, dynamic> toJson() => _$TodaySummaryToJson(this);
}

@JsonSerializable()
class WeeklySummary {
  @JsonKey(name: 'avg_feeding_per_day')
  final double avgFeedingPerDay;
  @JsonKey(name: 'avg_diaper_per_day')
  final double avgDiaperPerDay;
  @JsonKey(name: 'avg_sleep_hours_per_day')
  final double avgSleepHoursPerDay;
  
  WeeklySummary({
    required this.avgFeedingPerDay,
    required this.avgDiaperPerDay,
    required this.avgSleepHoursPerDay,
  });
  
  factory WeeklySummary.fromJson(Map<String, dynamic> json) =>
      _$WeeklySummaryFromJson(json);
  Map<String, dynamic> toJson() => _$WeeklySummaryToJson(this);
}
```

### 코드 생성

```bash
# JSON 직렬화 코드 생성
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## API 엔드포인트

### Baby API Service

```dart
// lib/services/baby_api_service.dart

import 'package:dio/dio.dart';
import '../models/baby.dart';
import '../models/dashboard.dart';
import 'api_client.dart';

class BabyApiService {
  final ApiClient _apiClient;
  
  BabyApiService(this._apiClient);
  
  // 아이 목록 조회
  Future<List<Baby>> getBabies({int limit = 50, int offset = 0}) async {
    try {
      final response = await _apiClient.dio.get(
        '/baby-care-ai/babies',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      
      return (response.data as List)
          .map((json) => Baby.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // 아이 상세 조회
  Future<Baby> getBaby(int babyId) async {
    try {
      final response = await _apiClient.dio.get(
        '/baby-care-ai/babies/$babyId',
      );
      
      return Baby.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // 아이 생성
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
        '/baby-care-ai/babies',
        data: {
          'name': name,
          'birth_date': birthDate,
          if (gender != null) 'gender': gender,
          if (photo != null) 'photo': photo,
          if (bloodType != null) 'blood_type': bloodType,
          if (notes != null) 'notes': notes,
        },
      );
      
      return Baby.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // 아이 정보 수정
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
      final response = await _apiClient.dio.put(
        '/baby-care-ai/babies/$babyId',
        data: {
          if (name != null) 'name': name,
          if (birthDate != null) 'birth_date': birthDate,
          if (gender != null) 'gender': gender,
          if (photo != null) 'photo': photo,
          if (bloodType != null) 'blood_type': bloodType,
          if (notes != null) 'notes': notes,
          if (isActive != null) 'is_active': isActive,
        },
      );
      
      return Baby.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // 아이 삭제 (비활성화)
  Future<void> deleteBaby(int babyId) async {
    try {
      await _apiClient.dio.delete('/baby-care-ai/babies/$babyId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // 대시보드 조회
  Future<Dashboard> getDashboard(int babyId) async {
    try {
      final response = await _apiClient.dio.get(
        '/baby-care-ai/babies/$babyId/dashboard',
      );
      
      return Dashboard.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  ApiException _handleError(DioException e) {
    if (e.response != null) {
      return ApiException(
        statusCode: e.response!.statusCode ?? 500,
        message: e.response!.data['error'] ?? 'Unknown error',
        details: e.response!.data['details'],
      );
    } else {
      return ApiException(
        statusCode: 0,
        message: 'Network error: ${e.message}',
      );
    }
  }
}
```

### FeedingRecord API Service

```dart
// lib/services/feeding_api_service.dart

import 'package:dio/dio.dart';
import '../models/feeding_record.dart';
import 'api_client.dart';

class FeedingApiService {
  final ApiClient _apiClient;
  
  FeedingApiService(this._apiClient);
  
  // 수유 기록 목록 조회
  Future<List<FeedingRecord>> getFeedingRecords(
    int babyId, {
    String? feedingType,
    String? startDate,
    String? endDate,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/baby-care-ai/babies/$babyId/feeding-records',
        queryParameters: {
          if (feedingType != null) 'feeding_type': feedingType,
          if (startDate != null) 'start_date': startDate,
          if (endDate != null) 'end_date': endDate,
          'limit': limit,
          'offset': offset,
        },
      );
      
      return (response.data as List)
          .map((json) => FeedingRecord.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // 수유 기록 생성
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
      final response = await _apiClient.dio.post(
        '/baby-care-ai/babies/$babyId/feeding-records',
        data: {
          'feeding_type': feedingType.name,
          if (amount != null) 'amount': amount,
          if (unit != null) 'unit': unit,
          if (durationMinutes != null) 'duration_minutes': durationMinutes,
          if (side != null) 'side': side,
          if (notes != null) 'notes': notes,
          if (recordedAt != null) 'recorded_at': recordedAt,
        },
      );
      
      return FeedingRecord.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // 수유 기록 수정
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
      final response = await _apiClient.dio.put(
        '/baby-care-ai/babies/$babyId/feeding-records/$recordId',
        data: {
          if (feedingType != null) 'feeding_type': feedingType.name,
          if (amount != null) 'amount': amount,
          if (unit != null) 'unit': unit,
          if (durationMinutes != null) 'duration_minutes': durationMinutes,
          if (side != null) 'side': side,
          if (notes != null) 'notes': notes,
          if (recordedAt != null) 'recorded_at': recordedAt,
        },
      );
      
      return FeedingRecord.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // 수유 기록 삭제
  Future<void> deleteFeedingRecord(int babyId, int recordId) async {
    try {
      await _apiClient.dio.delete(
        '/baby-care-ai/babies/$babyId/feeding-records/$recordId',
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  ApiException _handleError(DioException e) {
    if (e.response != null) {
      return ApiException(
        statusCode: e.response!.statusCode ?? 500,
        message: e.response!.data['error'] ?? 'Unknown error',
        details: e.response!.data['details'],
      );
    } else {
      return ApiException(
        statusCode: 0,
        message: 'Network error: ${e.message}',
      );
    }
  }
}
```

### GPT API Service

```dart
// lib/services/gpt_api_service.dart

import 'package:dio/dio.dart';
import '../models/gpt_conversation.dart';
import 'api_client.dart';

class GPTApiService {
  final ApiClient _apiClient;
  
  GPTApiService(this._apiClient);
  
  // GPT에게 질문하기
  Future<GPTConversation> askQuestion(
    int babyId, {
    required String question,
    int contextDays = 7,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/baby-care-ai/babies/$babyId/gpt-questions',
        data: {
          'question': question,
          'context_days': contextDays,
        },
      );
      
      return GPTConversation.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // GPT 대화 기록 목록
  Future<List<GPTConversation>> getConversations(
    int babyId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/baby-care-ai/babies/$babyId/gpt-conversations',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      
      return (response.data as List)
          .map((json) => GPTConversation.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // GPT 대화 기록 상세
  Future<GPTConversation> getConversation(
    int babyId,
    int conversationId,
  ) async {
    try {
      final response = await _apiClient.dio.get(
        '/baby-care-ai/babies/$babyId/gpt-conversations/$conversationId',
      );
      
      return GPTConversation.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  ApiException _handleError(DioException e) {
    if (e.response != null) {
      return ApiException(
        statusCode: e.response!.statusCode ?? 500,
        message: e.response!.data['error'] ?? 'Unknown error',
        details: e.response!.data['details'],
      );
    } else {
      return ApiException(
        statusCode: 0,
        message: 'Network error: ${e.message}',
      );
    }
  }
}

// API 예외 클래스
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic details;
  
  ApiException({
    required this.statusCode,
    required this.message,
    this.details,
  });
  
  @override
  String toString() => 'ApiException($statusCode): $message';
}
```

---

## 에러 처리

### 표준 에러 응답

모든 API 에러는 다음 형식으로 반환됩니다:

```json
{
  "error": "에러 메시지",
  "message": "상세 설명",
  "details": {
    // 추가 정보 (선택적)
  }
}
```

### HTTP 상태 코드

| 상태 코드 | 의미 | 설명 |
|---------|------|------|
| 200 | OK | 요청 성공 |
| 201 | Created | 리소스 생성 성공 |
| 204 | No Content | 삭제 성공 |
| 400 | Bad Request | 잘못된 요청 (비즈니스 로직 에러) |
| 401 | Unauthorized | 인증 실패 (토큰 없음/만료) |
| 403 | Forbidden | 권한 없음 |
| 404 | Not Found | 리소스를 찾을 수 없음 |
| 422 | Unprocessable Entity | 입력 데이터 검증 실패 |
| 500 | Internal Server Error | 서버 에러 |

### 에러 처리 예시

```dart
// lib/utils/error_handler.dart

class ErrorHandler {
  static String getErrorMessage(ApiException e) {
    switch (e.statusCode) {
      case 400:
        return e.message;
      case 401:
        return '로그인이 필요합니다.';
      case 403:
        return '접근 권한이 없습니다.';
      case 404:
        return '데이터를 찾을 수 없습니다.';
      case 422:
        return '입력 데이터를 확인해주세요.';
      case 500:
        return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
      default:
        return '네트워크 오류가 발생했습니다.';
    }
  }
  
  static void showErrorSnackbar(BuildContext context, ApiException e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(getErrorMessage(e)),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

---

## 베스트 프랙티스

### 1. 토큰 갱신

```dart
// Firebase ID 토큰은 1시간마다 자동 갱신됩니다
// 401 에러 발생 시 토큰 강제 갱신
try {
  await apiService.someMethod();
} catch (e) {
  if (e is ApiException && e.statusCode == 401) {
    // 토큰 갱신 후 재시도
    await authService.getIdToken(forceRefresh: true);
    await apiService.someMethod();
  }
}
```

### 2. 날짜/시간 처리

```dart
// ISO 8601 형식 사용
final now = DateTime.now().toIso8601String();

// 서버에서 받은 날짜 파싱
final recordedAt = DateTime.parse(record.recordedAt);

// 로컬 시간대로 변환
final localTime = recordedAt.toLocal();
```

### 3. 페이지네이션

```dart
// 무한 스크롤 구현
class FeedingListState extends ChangeNotifier {
  final List<FeedingRecord> _records = [];
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoading = false;
  
  Future<void> loadMore(int babyId) async {
    if (_isLoading || !_hasMore) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final newRecords = await feedingApiService.getFeedingRecords(
        babyId,
        limit: 20,
        offset: _offset,
      );
      
      _records.addAll(newRecords);
      _offset += newRecords.length;
      _hasMore = newRecords.length == 20;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### 4. 캐싱

```dart
// 간단한 메모리 캐싱
class BabyRepository {
  final Map<int, Baby> _cache = {};
  final BabyApiService _apiService;
  
  Future<Baby> getBaby(int babyId, {bool forceRefresh = false}) async {
    if (!forceRefresh && _cache.containsKey(babyId)) {
      return _cache[babyId]!;
    }
    
    final baby = await _apiService.getBaby(babyId);
    _cache[babyId] = baby;
    return baby;
  }
  
  void clearCache() => _cache.clear();
}
```

### 5. 로딩 상태 관리

```dart
// Provider 사용 예시
class BabyProvider extends ChangeNotifier {
  final BabyApiService _apiService;
  
  List<Baby> _babies = [];
  bool _isLoading = false;
  String? _error;
  
  List<Baby> get babies => _babies;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> loadBabies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _babies = await _apiService.getBabies();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

---

## 예시: 완전한 기능 구현

### 수유 기록 추가 화면

```dart
// lib/screens/add_feeding_screen.dart

class AddFeedingScreen extends StatefulWidget {
  final int babyId;
  
  const AddFeedingScreen({required this.babyId});
  
  @override
  State<AddFeedingScreen> createState() => _AddFeedingScreenState();
}

class _AddFeedingScreenState extends State<AddFeedingScreen> {
  final _formKey = GlobalKey<FormState>();
  FeedingType _feedingType = FeedingType.breastMilk;
  int? _amount;
  String? _side;
  bool _isLoading = false;
  
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final feedingService = context.read<FeedingApiService>();
      
      await feedingService.createFeedingRecord(
        widget.babyId,
        feedingType: _feedingType,
        amount: _amount,
        side: _side,
        recordedAt: DateTime.now().toIso8601String(),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('수유 기록이 추가되었습니다')),
        );
        Navigator.pop(context, true);
      }
    } on ApiException catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackbar(context, e);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('수유 기록 추가')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<FeedingType>(
              value: _feedingType,
              items: FeedingType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _feedingType = value!);
              },
              decoration: const InputDecoration(
                labelText: '수유 타입',
              ),
            ),
            if (_feedingType == FeedingType.formula)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '양 (ml)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '분유 수유는 양을 입력해야 합니다';
                  }
                  return null;
                },
                onChanged: (value) {
                  _amount = int.tryParse(value);
                },
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## API 문서

전체 API 문서는 다음 URL에서 확인할 수 있습니다:

- **Swagger UI**: `https://api.fromnowon.com/docs`
- **ReDoc**: `https://api.fromnowon.com/redoc`

---

## 지원

문제가 발생하거나 질문이 있으면 GitHub Issues를 통해 문의해주세요:
https://github.com/generation21/fromnowon-server/issues

# BabyCareAI API 참조 문서

## 기본 정보

**Base URL**: `/api/v1/baby-care-ai`

**인증**: Supabase Access Token (Bearer Token)

**Content-Type**: `application/json`

---

## 인증

모든 API 요청에는 Supabase Access Token이 필요합니다.
BabyCareAI는 **Supabase 익명 인증**을 사용하며, 앱 실행 시 자동으로 토큰이 발급됩니다.

```http
Authorization: Bearer <supabase_access_token>
```

자세한 인증 가이드: [authentication-api.md](authentication-api.md)

---

## 📋 목차

1. [Authentication & Users API](#authentication--users-api)
2. [Baby Profile API](#baby-profile-api)
3. [Feeding Record API](#feeding-record-api)
4. [Care Record API](#care-record-api)
5. [GPT Conversation API](#gpt-conversation-api)
6. [Dashboard API](#dashboard-api)
7. [에러 응답](#에러-응답)

---

## Authentication & Users API

### 인증 방식

BabyCareAI API는 **Supabase Anonymous Authentication** (기기 기반 인증)을 사용합니다.

- **인증 방식**: 앱 실행 시 Supabase 익명 사용자 자동 생성
- **사용자 입력**: 불필요 (이메일, 비밀번호, 소셜 로그인 없음)
- **토큰**:
  - Access Token (JWT 형식, 유효기간 1시간, 자동 갱신)
  - Refresh Token (자동 갱신용, 유효기간 30일)
- **서버 검증**: `supabase.auth.get_user(token)`으로 검증
- **향후 계획**: Google 계정 연동 (기기 변경 시 데이터 이전)

**자세한 인증 가이드**: [authentication-api.md](authentication-api.md)

---

### 디바이스 등록

앱 설치 후 첫 실행 시 또는 FCM 토큰 갱신 시 호출합니다.

```http
POST /api/v1/users/devices
Authorization: Bearer <supabase_access_token>
```

**Request Body**:
```json
{
  "device_token": "fcm_token_or_apns_token",
  "platform": "ios",
  "app_id": "com.fromnowon.babycare"
}
```

**Required Fields**:
- `device_token` (string): FCM/APNS 토큰
- `platform` (string): "ios" 또는 "android"
- `app_id` (string): 앱 번들 ID

**Response 200**:
```json
{
  "id": 1,
  "user_id": "user-123",
  "device_token": "fcm_token_or_apns_token",
  "platform": "ios",
  "app_id": "com.fromnowon.babycare",
  "is_active": true,
  "created_at": "2025-01-20T10:00:00Z"
}
```

**설명**:
- 같은 `device_token`이 이미 등록되어 있으면 업데이트
- 신규 `device_token`이면 새로 등록
- 푸시 알림 전송에 사용됨

---

### 로그인 이력 기록

로그인 성공 후 호출하여 로그인 이력을 기록합니다.

```http
POST /api/v1/users/login
Authorization: Bearer <supabase_access_token>
```

**Request Body**:
```json
{
  "device_token": "fcm_token_or_apns_token",
  "app_id": "com.fromnowon.babycare"
}
```

**Required Fields**:
- `device_token` (string): 디바이스 토큰
- `app_id` (string): 앱 ID

**Response 200**:
```json
{
  "message": "Login recorded successfully",
  "id": 123
}
```

**설명**:
- 사용자의 로그인 시간, IP, User-Agent 자동 기록
- 보안 감사 및 분석에 사용

---

### 사용자 디바이스 목록 조회

현재 사용자의 등록된 디바이스 목록을 조회합니다.

```http
GET /api/v1/users/{user_id}/devices
Authorization: Bearer <supabase_access_token>
```

**Path Parameters**:
- `user_id` (string, required): 사용자 ID

**Response 200**:
```json
[
  {
    "id": 1,
    "user_id": "user-123",
    "device_token": "fcm_token_1",
    "platform": "ios",
    "app_id": "com.fromnowon.babycare",
    "is_active": true,
    "created_at": "2025-01-20T10:00:00Z"
  },
  {
    "id": 2,
    "user_id": "user-123",
    "device_token": "fcm_token_2",
    "platform": "android",
    "app_id": "com.fromnowon.babycare",
    "is_active": true,
    "created_at": "2025-01-21T10:00:00Z"
  }
]
```

**Response 403**:
```json
{
  "detail": "Forbidden: You can only view your own devices"
}
```

**설명**:
- 사용자는 자신의 디바이스만 조회 가능
- 다중 디바이스 로그인 확인
- 디바이스 관리 기능에 사용

---

## Baby Profile API

### 아이 목록 조회

```http
GET /api/v1/baby-care-ai/babies
```

**Query Parameters:**
- `limit` (integer, optional): 조회 개수 (기본값: 50, 최대: 100)
- `offset` (integer, optional): 건너뛸 개수 (기본값: 0)

**Response 200:**
```json
[
  {
    "id": 1,
    "name": "아기 이름",
    "birth_date": "2025-01-15",
    "gender": "male",
    "photo": "https://example.com/photo.jpg",
    "blood_type": "A",
    "notes": {},
    "is_active": true,
    "user_id": "user-123",
    "created_at": "2025-01-20T10:00:00Z",
    "updated_at": "2025-01-20T10:00:00Z"
  }
]
```

---

### 아이 상세 조회

```http
GET /babies/{baby_id}
```

**Path Parameters:**
- `baby_id` (integer, required): 아이 ID

**Response 200:**
```json
{
  "id": 1,
  "name": "아기 이름",
  "birth_date": "2025-01-15",
  "gender": "male",
  "photo": "https://example.com/photo.jpg",
  "blood_type": "A",
  "notes": {},
  "is_active": true,
  "user_id": "user-123",
  "created_at": "2025-01-20T10:00:00Z",
  "updated_at": "2025-01-20T10:00:00Z"
}
```

**Response 404:**
```json
{
  "error": "Baby 1 not found"
}
```

---

### 아이 프로필 생성

```http
POST /babies
```

**Request Body:**
```json
{
  "name": "아기 이름",
  "birth_date": "2025-01-15",
  "gender": "male",
  "photo": "https://example.com/photo.jpg",
  "blood_type": "A",
  "notes": {}
}
```

**Required Fields:**
- `name` (string): 아이 이름
- `birth_date` (date): 생년월일 (YYYY-MM-DD)

**Optional Fields:**
- `gender` (string): 성별 ("male", "female", "unknown")
- `photo` (string): 사진 URL
- `blood_type` (string): 혈액형
- `notes` (object): 추가 메모

**Response 201:**
```json
{
  "id": 1,
  "name": "아기 이름",
  "birth_date": "2025-01-15",
  "gender": "male",
  "photo": "https://example.com/photo.jpg",
  "blood_type": "A",
  "notes": {},
  "is_active": true,
  "user_id": "user-123",
  "created_at": "2025-01-20T10:00:00Z",
  "updated_at": "2025-01-20T10:00:00Z"
}
```

**Response 400:**
```json
{
  "error": "Invalid birth_date",
  "details": {
    "error": "birth_date cannot be in the future",
    "provided": "2030-01-01"
  }
}
```

---

### 아이 정보 수정

```http
PUT /babies/{baby_id}
```

**Path Parameters:**
- `baby_id` (integer, required): 아이 ID

**Request Body:**
```json
{
  "name": "수정된 이름",
  "gender": "female"
}
```

**Response 200:**
```json
{
  "id": 1,
  "name": "수정된 이름",
  "birth_date": "2025-01-15",
  "gender": "female",
  ...
}
```

---

### 아이 삭제 (비활성화)

```http
DELETE /babies/{baby_id}
```

**Path Parameters:**
- `baby_id` (integer, required): 아이 ID

**Response 204:** No Content

---

## Feeding Record API

### 수유 기록 목록 조회

```http
GET /babies/{baby_id}/feeding-records
```

**Query Parameters:**
- `feeding_type` (string, optional): 수유 타입 필터 ("breast_milk", "formula", "pumping", "solid_food")
- `start_date` (datetime, optional): 시작 날짜/시간 (ISO 8601)
- `end_date` (datetime, optional): 종료 날짜/시간 (ISO 8601)
- `limit` (integer, optional): 조회 개수 (기본값: 50, 최대: 100)
- `offset` (integer, optional): 건너뛸 개수 (기본값: 0)

**Response 200:**
```json
[
  {
    "id": 1,
    "baby_id": 1,
    "feeding_type": "breast_milk",
    "amount": 100,
    "unit": "ml",
    "duration_minutes": 15,
    "side": "left",
    "notes": "잘 먹음",
    "recorded_at": "2025-01-20T10:00:00Z",
    "user_id": "user-123",
    "created_at": "2025-01-20T10:05:00Z",
    "updated_at": "2025-01-20T10:05:00Z"
  }
]
```

---

### 수유 기록 생성

```http
POST /babies/{baby_id}/feeding-records
```

**Request Body:**
```json
{
  "feeding_type": "breast_milk",
  "amount": 100,
  "unit": "ml",
  "duration_minutes": 15,
  "side": "left",
  "notes": "잘 먹음",
  "recorded_at": "2025-01-20T10:00:00Z"
}
```

**Required Fields:**
- `feeding_type` (string): 수유 타입

**Conditional Required:**
- `amount` (integer): 양 (formula, pumping 타입 시 필수)

**Optional Fields:**
- `unit` (string): 단위 (기본값: "ml")
- `duration_minutes` (integer): 수유 시간 (분)
- `side` (string): 수유 측면 ("left", "right", "both")
- `notes` (string): 메모
- `recorded_at` (datetime): 기록 시간 (기본값: 현재 시간)

**Response 201:**
```json
{
  "id": 1,
  "baby_id": 1,
  "feeding_type": "breast_milk",
  ...
}
```

**Response 400:**
```json
{
  "error": "Formula feeding requires amount",
  "details": {
    "error": "amount field is required for formula feeding"
  }
}
```

---

### 수유 기록 수정

```http
PUT /babies/{baby_id}/feeding-records/{record_id}
```

**Request Body:**
```json
{
  "amount": 120,
  "notes": "추가 메모"
}
```

**Response 200:**
```json
{
  "id": 1,
  "baby_id": 1,
  "amount": 120,
  "notes": "추가 메모",
  ...
}
```

---

### 수유 기록 삭제

```http
DELETE /babies/{baby_id}/feeding-records/{record_id}
```

**Response 204:** No Content

---

## Care Record API

### 육아 기록 목록 조회

```http
GET /babies/{baby_id}/care-records
```

**Query Parameters:**
- `record_type` (string, optional): 기록 타입 ("diaper", "sleep", "bath", "medicine", "temperature", "other")
- `start_date` (datetime, optional): 시작 날짜/시간
- `end_date` (datetime, optional): 종료 날짜/시간
- `limit` (integer, optional): 조회 개수
- `offset` (integer, optional): 건너뛸 개수

**Response 200:**
```json
[
  {
    "id": 1,
    "baby_id": 1,
    "record_type": "diaper",
    "diaper_type": "wet",
    "notes": null,
    "recorded_at": "2025-01-20T10:00:00Z",
    "user_id": "user-123",
    "created_at": "2025-01-20T10:05:00Z",
    "updated_at": "2025-01-20T10:05:00Z"
  },
  {
    "id": 2,
    "baby_id": 1,
    "record_type": "sleep",
    "sleep_start": "2025-01-20T22:00:00Z",
    "sleep_end": "2025-01-21T02:00:00Z",
    "notes": "잘 잠",
    "recorded_at": "2025-01-21T02:00:00Z",
    ...
  }
]
```

---

### 육아 기록 생성

```http
POST /babies/{baby_id}/care-records
```

**Request Body (기저귀):**
```json
{
  "record_type": "diaper",
  "diaper_type": "wet",
  "notes": "메모",
  "recorded_at": "2025-01-20T10:00:00Z"
}
```

**Request Body (수면):**
```json
{
  "record_type": "sleep",
  "sleep_start": "2025-01-20T22:00:00Z",
  "sleep_end": "2025-01-21T02:00:00Z",
  "notes": "잘 잠"
}
```

**Request Body (체온):**
```json
{
  "record_type": "temperature",
  "temperature": 36.5,
  "temperature_unit": "C",
  "notes": "정상"
}
```

**Request Body (약):**
```json
{
  "record_type": "medicine",
  "medicine_name": "타이레놀",
  "medicine_dosage": "5ml",
  "notes": "감기"
}
```

**Response 201:**
```json
{
  "id": 1,
  "baby_id": 1,
  "record_type": "diaper",
  ...
}
```

---

### 육아 기록 수정

```http
PUT /babies/{baby_id}/care-records/{record_id}
```

---

### 육아 기록 삭제

```http
DELETE /babies/{baby_id}/care-records/{record_id}
```

**Response 204:** No Content

---

## GPT Conversation API

### GPT에게 질문하기

```http
POST /babies/{baby_id}/gpt-questions
```

**Request Body:**
```json
{
  "question": "아이가 밤에 자주 깨는데 어떻게 해야 할까요?",
  "context_days": 7
}
```

**Required Fields:**
- `question` (string): 질문 내용 (1-2000자)

**Optional Fields:**
- `context_days` (integer): 컨텍스트로 사용할 최근 N일간의 기록 (기본값: 7, 범위: 1-30)

**Response 201:**
```json
{
  "id": 1,
  "baby_id": 1,
  "question": "아이가 밤에 자주 깨는데 어떻게 해야 할까요?",
  "answer": "최근 7일간의 기록을 분석한 결과...",
  "context_data": {
    "baby_info": {...},
    "feeding_records": [...],
    "care_records": [...]
  },
  "user_id": "user-123",
  "created_at": "2025-01-20T10:00:00Z"
}
```

**Response 400:**
```json
{
  "error": "Invalid question",
  "details": {
    "error": "question must be between 1 and 2000 characters",
    "provided_length": 2500
  }
}
```

---

### GPT 대화 기록 목록 조회

```http
GET /babies/{baby_id}/gpt-conversations
```

**Query Parameters:**
- `limit` (integer, optional): 조회 개수
- `offset` (integer, optional): 건너뛸 개수

**Response 200:**
```json
[
  {
    "id": 1,
    "baby_id": 1,
    "question": "질문 내용",
    "answer": "답변 내용",
    "context_data": {...},
    "user_id": "user-123",
    "created_at": "2025-01-20T10:00:00Z"
  }
]
```

---

### GPT 대화 기록 상세 조회

```http
GET /babies/{baby_id}/gpt-conversations/{conversation_id}
```

**Response 200:**
```json
{
  "id": 1,
  "baby_id": 1,
  "question": "질문 내용",
  "answer": "답변 내용",
  "context_data": {
    "baby_info": {
      "name": "아기 이름",
      "age_in_days": 45
    },
    "feeding_records": [...],
    "care_records": [...]
  },
  "user_id": "user-123",
  "created_at": "2025-01-20T10:00:00Z"
}
```

---

## Dashboard API

### 대시보드 조회

```http
GET /babies/{baby_id}/dashboard
```

**Response 200:**
```json
{
  "baby_info": {
    "id": 1,
    "name": "아기 이름",
    "birth_date": "2025-01-15",
    "age_in_days": 45
  },
  "latest_feeding": {
    "id": 100,
    "feeding_type": "breast_milk",
    "recorded_at": "2025-01-20T10:00:00Z",
    ...
  },
  "latest_diaper": {
    "id": 50,
    "diaper_type": "wet",
    "recorded_at": "2025-01-20T09:30:00Z",
    ...
  },
  "latest_sleep": {
    "id": 30,
    "sleep_start": "2025-01-20T22:00:00Z",
    "sleep_end": "2025-01-21T02:00:00Z",
    ...
  },
  "today_summary": {
    "feeding_count": 8,
    "diaper_count": 6,
    "sleep_hours": 12.5
  },
  "weekly_summary": {
    "avg_feeding_per_day": 7.8,
    "avg_diaper_per_day": 6.2,
    "avg_sleep_hours_per_day": 13.2
  }
}
```

**설명:**
- `baby_info`: 아이 기본 정보
- `latest_feeding`: 최근 수유 기록
- `latest_diaper`: 최근 기저귀 교체 기록
- `latest_sleep`: 최근 수면 기록
- `today_summary`: 오늘의 요약 통계
- `weekly_summary`: 최근 7일간의 평균 통계

---

## 에러 응답

### 에러 응답 형식

모든 에러는 다음 형식으로 반환됩니다:

```json
{
  "error": "에러 메시지",
  "message": "상세 설명 (선택적)",
  "details": {
    "추가": "정보 (선택적)"
  }
}
```

### HTTP 상태 코드

| 코드 | 의미 | 설명 |
|-----|------|------|
| 200 | OK | 요청 성공 |
| 201 | Created | 리소스 생성 성공 |
| 204 | No Content | 삭제 성공 (응답 본문 없음) |
| 400 | Bad Request | 잘못된 요청 (비즈니스 로직 에러) |
| 401 | Unauthorized | 인증 실패 (토큰 없음/만료) |
| 403 | Forbidden | 권한 없음 (다른 사용자의 리소스 접근) |
| 404 | Not Found | 리소스를 찾을 수 없음 |
| 422 | Unprocessable Entity | 입력 데이터 검증 실패 (Pydantic 에러) |
| 500 | Internal Server Error | 서버 내부 오류 |

### 에러 예시

**400 Bad Request:**
```json
{
  "error": "Invalid birth_date",
  "details": {
    "error": "birth_date cannot be in the future",
    "provided": "2030-01-01"
  }
}
```

**401 Unauthorized:**
```json
{
  "error": "Authentication required",
  "message": "Valid Firebase ID token is required"
}
```

**404 Not Found:**
```json
{
  "error": "Baby 999 not found"
}
```

**422 Unprocessable Entity:**
```json
{
  "error": "Validation error",
  "message": "Field 'name' is required; Field 'birth_date' must be a valid date",
  "details": [
    {
      "field": "body -> name",
      "message": "Field required",
      "type": "missing"
    },
    {
      "field": "body -> birth_date",
      "message": "Input should be a valid date",
      "type": "date_type"
    }
  ]
}
```

---

## 제약 조건

### 데이터 검증

**Baby:**
- `name`: 필수, 문자열
- `birth_date`: 필수, 과거 날짜, 10년 이내
- `gender`: 선택, "male", "female", "unknown" 중 하나

**FeedingRecord:**
- `feeding_type`: 필수, "breast_milk", "formula", "pumping", "solid_food" 중 하나
- `amount`: formula/pumping 타입 시 필수
- `side`: breast_milk 타입 시 선택 ("left", "right", "both")

**CareRecord:**
- `record_type`: 필수
- `diaper_type`: diaper 타입 시 필수 ("wet", "dirty", "both")
- `sleep_start`, `sleep_end`: sleep 타입 시 필수
- `temperature`: temperature 타입 시 필수
- `medicine_name`: medicine 타입 시 필수

**GPTConversation:**
- `question`: 1-2000자
- `context_days`: 1-30일

### 페이지네이션

- 기본 `limit`: 50
- 최대 `limit`: 100
- `offset`: 0부터 시작

### 날짜/시간

- ISO 8601 형식 사용: `2025-01-20T10:00:00Z`
- UTC 시간대 권장
- 날짜만 필요한 경우: `2025-01-20`

---

## 성능 목표

- **대시보드 API**: < 300ms
- **일반 API**: < 200ms
- **GPT 질문 API**: < 5초 (외부 AI API 의존)

---

## 버전 정보

- **API Version**: v1
- **Last Updated**: 2026-02-07

---

## 자동 생성 문서

더 자세한 API 문서는 FastAPI 자동 생성 문서를 참고하세요:

- **Swagger UI**: `https://api.fromnowon.com/docs`
- **ReDoc**: `https://api.fromnowon.com/redoc`

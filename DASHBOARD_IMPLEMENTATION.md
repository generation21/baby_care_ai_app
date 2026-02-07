# Dashboard 구현 완료 보고서

## 구현 내용

### 1. 새로운 Dashboard API 통합
새로운 통합 API 엔드포인트를 사용하여 메인 화면을 구성했습니다.

#### API 엔드포인트
- `GET /baby-care/dashboard/{baby_id}` - Dashboard 데이터 조회
- `POST /baby-care/dashboard/records` - 기록 추가 (통합 API)
- `PUT /baby-care/dashboard/records/{record_type}/{record_id}` - 기록 수정
- `DELETE /baby-care/dashboard/records/{record_type}/{record_id}` - 기록 삭제

### 2. 생성된 파일

#### 모델 (lib/models/)
- `dashboard.dart` - Dashboard 관련 모델 클래스
  - `BabyDashboard` - 메인 Dashboard 데이터
  - `LatestRecords` - 최근 기록 정보
  - `TodayStats` - 오늘의 통계
  - `TimelineItem` - 타임라인 아이템
  - `CreateDashboardRecordRequest` - 기록 추가 요청
  - `UpdateDashboardRecordRequest` - 기록 수정 요청

#### 서비스 (lib/services/)
- `dashboard_service.dart` - Dashboard 비즈니스 로직
  - Dashboard 데이터 로드 및 새로고침
  - 모유/분유/이유식 기록 추가
  - 기저귀/수면/유축 기록 추가
  - 기록 수정 및 삭제

#### 화면 (lib/screens/)
- `dashboard_screen.dart` - 새로운 메인 Dashboard 화면
  - 아기 정보 헤더
  - 빠른 기록 버튼 (6개: 모유, 분유, 이유식, 기저귀, 수면, 유축)
  - 최근 기록 요약 (마지막 기저귀, 수유, 수면)
  - 오늘의 통계 (밤/낮 수면 시간)
  - 타임라인 (시간순 기록 목록)

#### API 클라이언트 (lib/clients/)
- `baby_api_client.dart` 수정
  - Dashboard API 메서드 추가
  - `getDashboard()`, `createDashboardRecord()`, `updateDashboardRecord()`, `deleteDashboardRecord()`

#### 위젯 (lib/widgets/)
- `quick_record_dialog.dart` 수정
  - Dashboard API와 통합
  - 새로운 기록 타입 지원 (baby_food)

### 3. 라우터 설정 (lib/router.dart)
- 새로운 Dashboard 라우트 추가: `/dashboard/:babyId`
- 기존 Dashboard를 레거시로 변경: `/dashboard-old/:babyId`
- 초기 경로를 `/dashboard/1`로 설정
- `AppRouter` 헬퍼 메서드 추가
  - `goDashboard(context, babyId)`
  - `pushDashboard(context, babyId)`

### 4. 의존성 주입 (lib/main.dart)
- `BabyApiClient` Provider 추가
- `DashboardService` Provider 추가
- 모든 Provider를 MultiProvider로 통합

## UI 구성

```
┌─────────────────────────┐
│  [☰]  아기이름  [↻] [⋮] │  ← AppBar (메뉴, 새로고침, 더보기)
│       84일              │  ← 출생 후 경과 일수
├─────────────────────────┤
│ 🩷   💛   💙   🤎   💜   🩷 │  ← 빠른 기록 버튼
│ 모유 분유 이유식 기저귀 수면 유축│
├─────────────────────────┤
│ 마지막 기저귀     10:24  │  ← 최근 기록 요약
│              [1시간 50분전]│
├─────────────────────────┤
│ 마지막 수유      08:10  │
│              [4시간 4분전]│
├─────────────────────────┤
│ 마지막 수면      04:15  │
│              [8시간 0분전]│
├─────────────────────────┤
│ 1월 25일 (일)            │  ← 오늘의 통계
│ 🌙 7시간 43분  ☀️ 1시간 10분│
├─────────────────────────┤
│ 12:00 PM 🛏️ 낮잠  0분   │  ← 타임라인
│ 11:15 AM 🛏️ 낮잠  25분  │
│ 11:02 AM 🥄 소변         │
│ 10:24 AM 🩷 모유  0분    │
│ 09:26 AM 🛏️ 낮잠  45분  │
│ 08:27 AM 🥄 소변         │
│ 08:10 AM 🩷 모유  0분    │
│ 04:15 AM 🛏️ 밤잠        │
└─────────────────────────┘
```

## 주요 기능

### 1. Dashboard 데이터 로드
- 아기 정보, 최근 기록, 오늘의 통계, 타임라인을 한 번에 조회
- Pull-to-Refresh 지원

### 2. 빠른 기록 추가
- 6가지 기록 타입 지원
  - 🩷 모유: 수유 시간, 수유 측 선택
  - 💛 분유: 수유량(ml)
  - 💙 이유식: 메모
  - 🤎 기저귀: 소변/대변/둘다 선택
  - 💜 수면: 시작/종료 시간
  - 🩷 유축: 유축량(ml)

### 3. 타임라인
- 시간순으로 정렬된 기록 목록
- 각 기록에 대한 수정/삭제 기능
- 아이콘과 이모지로 시각적 구분

### 4. 실시간 업데이트
- 기록 추가 시 자동 새로고침
- 기록 삭제 시 타임라인에서 즉시 제거

## 사용 방법

### Dashboard 화면으로 이동
```dart
// 방법 1: 직접 이동
context.go('/dashboard/1');

// 방법 2: 헬퍼 메서드 사용
AppRouter.goDashboard(context, babyId);

// 방법 3: Push
AppRouter.pushDashboard(context, babyId);
```

### 기록 추가
```dart
// DashboardService 사용
final service = context.read<DashboardService>();

// 모유 수유 기록
await service.addBreastMilkRecord(
  babyId: 1,
  durationMinutes: 15,
  notes: '왼쪽 젖',
);

// 분유 수유 기록
await service.addFormulaRecord(
  babyId: 1,
  amountMl: 120.0,
  notes: '분유',
);

// 기저귀 기록
await service.addDiaperRecord(
  babyId: 1,
  diaperType: 'wet',  // 'wet', 'dirty', 'both'
);

// 수면 기록
await service.addSleepRecord(
  babyId: 1,
  sleepType: 'nap',  // 'night', 'nap'
  sleepStart: '2026-01-25T10:00:00',
  sleepEnd: '2026-01-25T11:00:00',
);
```

### 기록 수정/삭제
```dart
// 기록 수정
await service.updateRecord(
  recordType: 'feeding',
  recordId: 123,
  request: UpdateDashboardRecordRequest(
    durationMinutes: 20,
    notes: '수정된 메모',
  ),
);

// 기록 삭제
await service.deleteRecord(
  recordType: 'feeding',
  recordId: 123,
);
```

## API 요청/응답 예시

### Dashboard 조회
```dart
// 요청
GET /baby-care/dashboard/1

// 응답
{
  "baby": {
    "id": 1,
    "name": "김민준",
    "birthDate": "2025-11-02",
    // ... 기타 필드
  },
  "daysOld": 84,
  "latestRecords": {
    "lastFeedingTime": "08:10",
    "timeSinceLastFeeding": "4시간 4분전",
    "lastDiaperTime": "10:24",
    "timeSinceLastDiaper": "1시간 50분전",
    "lastSleepTime": "04:15",
    "timeSinceLastSleep": "8시간 0분전"
  },
  "todayStats": {
    "date": "1월 25일 (일)",
    "nightSleepMinutes": 463,
    "daySleepMinutes": 70,
    "totalSleepMinutes": 533,
    "feedingCount": 6,
    "diaperCount": 4
  },
  "timeline": [
    {
      "id": 1,
      "recordType": "sleep",
      "time": "12:00 PM",
      "recordedAt": "2026-01-25T12:00:00",
      "icon": "🛏️",
      "title": "낮잠",
      "detail": "0분",
      "sleepType": "nap",
      "durationMinutes": 0
    },
    // ... 더 많은 타임라인 아이템
  ]
}
```

### 기록 추가
```dart
// 요청
POST /baby-care/dashboard/records
{
  "babyId": 1,
  "recordType": "feeding",
  "feedingType": "breast_milk",
  "durationMinutes": 15
}

// 응답 (새로 생성된 타임라인 아이템)
{
  "id": 456,
  "recordType": "feeding",
  "time": "02:30 PM",
  "recordedAt": "2026-01-25T14:30:00",
  "icon": "🩷",
  "title": "모유",
  "detail": "15분",
  "feedingType": "breast_milk",
  "durationMinutes": 15
}
```

## 테스트 체크리스트

### 기본 기능
- [ ] Dashboard 화면 로드
- [ ] Pull-to-Refresh
- [ ] 새로고침 버튼

### 빠른 기록
- [ ] 모유 기록 추가
- [ ] 분유 기록 추가
- [ ] 이유식 기록 추가
- [ ] 기저귀 기록 추가
- [ ] 수면 기록 추가
- [ ] 유축 기록 추가

### 타임라인
- [ ] 기록 목록 표시
- [ ] 기록 수정
- [ ] 기록 삭제

### 에러 처리
- [ ] 네트워크 에러 처리
- [ ] 로딩 상태 표시
- [ ] 에러 메시지 표시

## 추가 개선 사항 (향후)

1. **오프라인 지원**
   - 로컬 캐싱
   - 동기화 기능

2. **통계 차트**
   - 수유량 그래프
   - 수면 패턴 차트
   - 성장 곡선

3. **알림 기능**
   - 수유 시간 알림
   - 기저귀 교체 알림

4. **다중 아기 지원**
   - 아기 선택 메뉴
   - 프로필 전환

5. **데이터 내보내기**
   - PDF 보고서
   - 엑셀 파일

## 문제 해결

### API 연결 실패
```dart
// .env 파일 확인
API_BASE_URL=http://your-api-server.com
```

### 초기 로딩 실패
- 아기 ID가 유효한지 확인
- 네트워크 연결 상태 확인
- API 서버 상태 확인

## 관련 파일

### 모델
- `lib/models/dashboard.dart`
- `lib/models/baby.dart`
- `lib/models/feeding_record.dart`
- `lib/models/care_record.dart`

### 서비스
- `lib/services/dashboard_service.dart`
- `lib/clients/baby_api_client.dart`

### 화면 & 위젯
- `lib/screens/dashboard_screen.dart`
- `lib/widgets/quick_record_dialog.dart`

### 설정
- `lib/router.dart`
- `lib/main.dart`

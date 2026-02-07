# Mock 데이터 모드 설정 가이드

## 개요
API 서버 없이 앱을 테스트할 수 있도록 Mock 데이터 모드를 추가했습니다.

## 설정 방법

### 1. .env 파일 수정
```env
# Mock 데이터 사용 (API 없이 테스트)
USE_MOCK_SERVICE=true

# 실제 API 사용
# USE_MOCK_SERVICE=false
# API_BASE_URL=http://your-server.com
```

### 2. Mock 모드 동작

#### ✅ Mock 모드 ON (USE_MOCK_SERVICE=true)
- API 호출 없이 로컬 Mock 데이터 사용
- 네트워크 지연 시뮬레이션 (500ms)
- 모든 기능 정상 작동

#### 🌐 Mock 모드 OFF (USE_MOCK_SERVICE=false)
- 실제 API 서버와 통신
- API 실패 시 자동으로 Mock 데이터로 폴백
- 인증 에러 발생 시에도 Mock 데이터 사용

## Mock 데이터 내용

### Dashboard 데이터
```dart
- 아기 이름: 김민준
- 출생 후 경과: 84일
- 최근 기록:
  * 마지막 수유: 08:10 (4시간 4분전)
  * 마지막 기저귀: 10:24 (1시간 50분전)
  * 마지막 수면: 04:15 (8시간 0분전)
- 오늘의 통계:
  * 밤 수면: 7시간 43분
  * 낮 수면: 1시간 10분
  * 수유 횟수: 6회
  * 기저귀: 4회
```

### 타임라인 (8개 기록)
1. 12:00 PM - 낮잠 (0분)
2. 11:15 AM - 낮잠 (25분)
3. 11:02 AM - 소변
4. 10:24 AM - 모유 (0분)
5. 09:26 AM - 낮잠 (45분)
6. 08:27 AM - 소변
7. 08:10 AM - 모유 (0분)
8. 04:15 AM - 밤잠

## 지원 기능

### ✅ Mock 모드에서 작동하는 기능
- Dashboard 데이터 로드
- 새로고침 (Pull-to-Refresh)
- 기록 추가 (모든 타입)
  - 🩷 모유
  - 💛 분유
  - 💙 이유식
  - 🤎 기저귀
  - 💜 수면
  - 🩷 유축
- 기록 삭제
- UI 인터랙션

### ⚠️ Mock 모드 제한사항
- 앱 재시작 시 추가한 기록 초기화
- 기록 수정 기능 미지원 (API 필요)
- 다중 아기 지원 미지원 (단일 Mock 아기만)

## 사용 예시

### Dashboard 화면 테스트
```dart
// Mock 모드에서 실행
// 1. .env에서 USE_MOCK_SERVICE=true 확인
// 2. 앱 실행
// 3. Dashboard 자동 로드 (Mock 데이터)
// 4. 모든 UI 테스트 가능
```

### 기록 추가 테스트
```dart
// 1. 빠른 기록 버튼 클릭 (예: 모유 🩷)
// 2. 다이얼로그에서 정보 입력
// 3. 저장 버튼 클릭
// 4. 타임라인에 즉시 추가됨
// 5. ✅ "모유 수유 기록을 추가했습니다" 메시지 표시
```

### 기록 삭제 테스트
```dart
// 1. 타임라인 아이템 메뉴(⋮) 클릭
// 2. "삭제" 선택
// 3. 확인 다이얼로그에서 "삭제" 클릭
// 4. 타임라인에서 즉시 제거됨
```

## 실제 API로 전환

### 1. API 서버 준비
```bash
# API 서버 실행 확인
curl http://localhost:8000/baby-care/dashboard/1
```

### 2. .env 파일 수정
```env
USE_MOCK_SERVICE=false
API_BASE_URL=http://localhost:8000
```

### 3. 앱 재시작
```bash
# 앱 종료 후 재시작
flutter run
```

### 4. 인증 설정
```env
# Supabase 인증 사용 시
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

## 자동 폴백

API 호출 실패 시 자동으로 Mock 데이터로 폴백됩니다:

```dart
try {
  // 실제 API 호출 시도
  _dashboard = await _apiClient.getDashboard(babyId);
} catch (e) {
  // API 실패 시 Mock 데이터로 폴백
  debugPrint('🔄 Mock 데이터로 폴백...');
  _dashboard = _getMockDashboard(babyId);
}
```

## 디버깅

### Mock 모드 확인
```dart
// 콘솔에서 확인
flutter: 🔄 Mock 데이터로 폴백...
```

### API 모드 확인
```dart
// 콘솔에서 API 요청 로그 확인
flutter: 🚀 Request: GET http://localhost:8000/baby-care/dashboard/1
flutter: ✅ Response: 200 http://localhost:8000/baby-care/dashboard/1
```

## 문제 해결

### Mock 데이터가 표시되지 않는 경우
1. `.env` 파일 확인
   ```env
   USE_MOCK_SERVICE=true
   ```
2. 앱 완전히 종료 후 재시작
3. 핫 리로드가 아닌 전체 재시작 필요

### API 에러가 계속 발생하는 경우
1. `.env` 파일에서 Mock 모드로 전환
2. API 서버 상태 확인
3. 네트워크 연결 확인

## 추가 정보

### Mock 데이터 수정
Mock 데이터를 변경하려면 다음 파일 수정:
```
lib/services/dashboard_service.dart
└── _getMockDashboard() 메서드
```

### 새로운 기록 타입 추가
```dart
// _getIconForRecordType() 메서드에 추가
case 'new_type': return '🆕';

// _getTitleForRecordType() 메서드에 추가
case 'new_type': return '새 기록';
```

## 요약

✅ **Mock 모드 사용**
- 빠른 프로토타이핑
- UI/UX 테스트
- 오프라인 개발

✅ **API 모드 사용**
- 실제 데이터 저장
- 다중 사용자 지원
- 프로덕션 배포

✅ **자동 폴백**
- API 실패 시에도 앱 작동
- 개발/테스트 편의성

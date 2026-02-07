# Dashboard 인터랙션 기능 구현 완료

## 개요
Dashboard 화면의 모든 버튼과 요소를 클릭 가능하도록 구현했습니다.

## 구현된 기능

### 1. AppBar 버튼

#### ☰ 메뉴 버튼 (왼쪽)
**기능:** 메인 메뉴 Bottom Sheet 표시

**메뉴 항목:**
- **아기 목록** (`/babies` 이동)
  - 아기 전환 및 관리
  - 다중 아기 지원

- **통계** (준비 중)
  - 성장 기록 및 분석
  - 차트 및 그래프

- **캘린더** (준비 중)
  - 일별 기록 보기
  - 월간 통계

- **설정** (`/settings` 이동)
  - 앱 설정 및 환경설정

```dart
void _showMenuDrawer(BuildContext context) {
  showModalBottomSheet(
    // Bottom Sheet로 메뉴 표시
  );
}
```

#### ↻ 새로고침 버튼 (오른쪽 첫 번째)
**기능:** Dashboard 데이터 새로고침

```dart
onPressed: () {
  context.read<DashboardService>().refreshDashboard(widget.babyId);
}
```

#### ⋮ 더보기 버튼 (오른쪽 두 번째)
**기능:** 추가 옵션 Bottom Sheet 표시

**메뉴 항목:**
- **아기 정보 수정** (`/babies/{id}/edit` 이동)
  - 아기 이름, 생년월일 등 수정

- **데이터 내보내기** (준비 중)
  - PDF, Excel 형식으로 내보내기

- **공유하기** (준비 중)
  - 가족과 기록 공유

- **앱 정보**
  - 버전 정보
  - 개발자 정보

```dart
void _showMoreMenu(BuildContext context) {
  showModalBottomSheet(
    // 더보기 메뉴 표시
  );
}
```

### 2. 헤더 (아기 이름)

**기능:** 아기 상세 정보 화면으로 이동

```dart
onTap: () => context.go('/babies/${dashboard.baby.id}')
```

**시각적 표시:**
- 아기 이름 옆에 → 화살표 아이콘
- 클릭 시 잉크 효과

```
┌─────────────────────────┐
│   김민준 →              │  ← 클릭 가능
│   84일                  │
└─────────────────────────┘
```

### 3. 빠른 기록 버튼 (6개)

모든 버튼이 클릭 가능하며, 각 타입에 맞는 기록 다이얼로그를 표시합니다.

| 버튼 | 아이콘 | 색상 | 기능 |
|------|--------|------|------|
| 모유 | `Icons.child_care` | 핑크 | 모유 수유 기록 |
| 분유 | `Icons.local_drink` | 앰버 | 분유 수유 기록 |
| 이유식 | `Icons.restaurant` | 시안 | 이유식 기록 |
| 기저귀 | `Icons.baby_changing_station` | 브라운 | 기저귀 교체 기록 |
| 수면 | `Icons.bedtime` | 딥퍼플 | 수면 기록 |
| 유축 | `Icons.water_drop` | 핑크 | 유축 기록 |

```dart
onTap: () => _showQuickRecordDialog(context, 'breast_milk')
```

### 4. 최근 기록 요약 카드

각 카드 클릭 시 해당 타입의 기록 추가 다이얼로그 표시

**마지막 기저귀 카드:**
```dart
onTap: () => _showQuickRecordDialog(context, 'diaper')
```

**마지막 수유 카드:**
```dart
onTap: () => _showQuickRecordDialog(context, 'breast_milk')
```

**마지막 수면 카드:**
```dart
onTap: () => _showQuickRecordDialog(context, 'sleep')
```

**시각적 개선:**
- 오른쪽에 `+` 아이콘 추가
- 클릭 가능함을 시각적으로 표시

```
┌─────────────────────────┐
│ [👶] 마지막 기저귀  10:24 │
│              [1시간 50분전]│
│                      [+] │  ← 추가 아이콘
└─────────────────────────┘
```

### 5. 타임라인 아이템

각 아이템의 메뉴(⋮)에서 수정/삭제 가능

**수정:**
```dart
onEdit: () => _editRecord(context, item)
// 현재는 준비 중 메시지 표시
```

**삭제:**
```dart
onDelete: () => _deleteRecord(context, item)
// 확인 다이얼로그 → 삭제 실행
```

## UI/UX 개선 사항

### 1. Bottom Sheet 디자인
```dart
shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
)
```

**상단 핸들:**
```dart
Container(
  width: 40,
  height: 4,
  decoration: BoxDecoration(
    color: Colors.grey[300],
    borderRadius: BorderRadius.circular(2),
  ),
)
```

### 2. InkWell 효과
모든 클릭 가능한 요소에 잉크 효과 적용:
```dart
InkWell(
  onTap: onTap,
  borderRadius: BorderRadius.circular(12),
  child: ...,
)
```

### 3. AppBar Title
아기 이름을 AppBar 중앙에 표시:
```dart
title: Consumer<DashboardService>(
  builder: (context, service, child) {
    final babyName = service.dashboard?.baby.name ?? '아기';
    return Text(babyName);
  },
),
centerTitle: true,
```

## 사용 예시

### 메뉴 열기
```dart
// 왼쪽 상단 ☰ 버튼 클릭
→ Bottom Sheet 표시
→ "아기 목록" 선택
→ /babies 화면으로 이동
```

### 기록 추가
```dart
// 방법 1: 빠른 기록 버튼
→ 모유 버튼 클릭
→ 다이얼로그 표시
→ 정보 입력 후 저장
→ 타임라인에 추가

// 방법 2: 최근 기록 카드
→ "마지막 수유" 카드 클릭
→ 다이얼로그 표시
→ 정보 입력 후 저장
```

### 아기 정보 보기
```dart
// 헤더의 아기 이름 클릭
→ 아기 상세 화면으로 이동
→ 성장 정보, 프로필 확인
```

### 더보기 메뉴
```dart
// 오른쪽 상단 ⋮ 버튼 클릭
→ "아기 정보 수정" 선택
→ 수정 화면으로 이동
```

## 화면 흐름도

```
Dashboard
├─ ☰ 메뉴
│  ├─ 아기 목록 → /babies
│  ├─ 통계 (준비 중)
│  ├─ 캘린더 (준비 중)
│  └─ 설정 → /settings
│
├─ 아기 이름 → /babies/{id}
│
├─ ↻ 새로고침
│
├─ ⋮ 더보기
│  ├─ 아기 정보 수정 → /babies/{id}/edit
│  ├─ 데이터 내보내기 (준비 중)
│  ├─ 공유하기 (준비 중)
│  └─ 앱 정보
│
├─ 빠른 기록 버튼 (6개)
│  └─ 각각 기록 다이얼로그 표시
│
├─ 최근 기록 카드 (3개)
│  └─ 클릭 시 해당 기록 추가
│
└─ 타임라인
   └─ 각 아이템 수정/삭제
```

## 완료 체크리스트

### ✅ 구현 완료
- [x] 메뉴 버튼 (☰)
- [x] 새로고침 버튼 (↻)
- [x] 더보기 버튼 (⋮)
- [x] 아기 이름 헤더 클릭
- [x] 빠른 기록 버튼 (6개)
- [x] 최근 기록 카드 (3개)
- [x] 타임라인 아이템 메뉴
- [x] 앱 정보 다이얼로그

### 🚧 준비 중
- [ ] 통계 화면
- [ ] 캘린더 화면
- [ ] 데이터 내보내기
- [ ] 공유하기
- [ ] 기록 수정 기능

## 코드 요약

### 추가된 메서드

```dart
// 메뉴 관련
void _showMenuDrawer(BuildContext context)
void _showMoreMenu(BuildContext context)
void _showAboutDialog(BuildContext context)

// 기록 관련
void _showQuickRecordDialog(BuildContext context, String recordType)
void _editRecord(BuildContext context, TimelineItem item)
void _deleteRecord(BuildContext context, TimelineItem item)
```

### 수정된 위젯

```dart
// AppBar
leading: IconButton(icon: Icons.menu, onPressed: _showMenuDrawer)
title: Text(babyName)  // 추가
actions: [refresh, more]

// 헤더
InkWell(onTap: goToBabyDetail, child: ...)

// 최근 기록 카드
_LatestRecordCard(
  ...,
  onTap: _showQuickRecordDialog,  // 추가
)
```

## 테스트 항목

### 기능 테스트
- [x] 메뉴 버튼 클릭
- [x] 각 메뉴 항목 선택
- [x] 새로고침 버튼
- [x] 더보기 버튼 클릭
- [x] 각 더보기 항목 선택
- [x] 아기 이름 클릭
- [x] 빠른 기록 버튼 (6개)
- [x] 최근 기록 카드 (3개)
- [x] 타임라인 수정/삭제

### UI 테스트
- [x] Bottom Sheet 애니메이션
- [x] InkWell 효과
- [x] 다이얼로그 표시
- [x] 네비게이션 전환

## 다음 단계

### 우선순위 높음
1. **기록 수정 기능**
   - 수정 다이얼로그 구현
   - API 연동

2. **통계 화면**
   - 차트 라이브러리 추가
   - 일별/주별/월별 통계

3. **캘린더 화면**
   - 달력 위젯
   - 날짜별 기록 표시

### 우선순위 중간
4. **데이터 내보내기**
   - PDF 생성
   - Excel 내보내기

5. **공유 기능**
   - 이미지로 공유
   - 텍스트로 공유

### 우선순위 낮음
6. **알림 기능**
   - 수유 시간 알림
   - 기저귀 교체 알림

## 결론

Dashboard의 모든 주요 버튼과 요소가 클릭 가능하도록 구현되었습니다. 사용자는 직관적으로 모든 기능에 접근할 수 있으며, 일관된 UI/UX를 제공합니다.

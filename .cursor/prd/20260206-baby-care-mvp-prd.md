# PRD: 육아·수유 기록 앱 MVP (대시보드 중심)

**작성일**: 2026-02-06
**버전**: 2.0
**상태**: 수정본 (대시보드 중심)

---

## 1. 제품 개요

### 1.1 제품 목적
**하나의 대시보드에서 모든 육아·수유 기록을 통합 관리**하고, 기록된 데이터를 기반으로 GPT에게 질문하여 아이의 상태와 육아 조언을 받을 수 있는 MVP 앱입니다.

### 1.2 핵심 가치 제안
- **통합 대시보드**: 수유, 수면, 기저귀 등 모든 육아 활동을 한 화면에서 확인하고 관리
- **실시간 상태 표시**: 마지막 기록 시간, 현재 진행 중인 활동, 일별 통계를 즉시 확인
- **빠른 기록**: 대시보드에서 원클릭으로 기록 추가 및 수정
- **AI 기반 조언**: 기록된 데이터를 컨텍스트로 활용하여 GPT에게 아이의 상태와 육아 조언 요청

### 1.3 목표 사용자
- 신생아를 키우는 부모
- 수유 패턴과 아이의 상태를 체계적으로 관리하고 싶은 부모
- **하나의 화면에서 모든 육아 기록을 확인하고 관리하고 싶은 부모**
- 육아 관련 전문적인 조언이 필요한 부모

### 1.4 핵심 사용자 경험
1. **대시보드 중심 워크플로우**:
   - 앱을 열면 대시보드가 첫 화면
   - 모든 활동의 최신 상태를 한눈에 확인
   - 필요한 기록을 대시보드에서 바로 추가

2. **실시간 상태 인식**:
   - "마지막 수유 4분전" 같은 상대 시간 표시로 직관적 이해
   - 진행 중인 수유 타이머로 현재 활동 추적

3. **빠른 기록 입력**:
   - 복잡한 폼 없이 핵심 정보만 입력하여 빠르게 기록
   - 대시보드에서 원클릭으로 기록 추가

---

## 2. MVP 범위

### 2.1 포함 기능 (Must Have)

#### 2.1.1 통합 대시보드 (핵심 기능)
- **대시보드 조회**: 모든 활동의 현재 상태를 한 번에 조회
  - 아이 프로필 정보 (이름, 나이)
  - 각 활동별 마지막 기록 시간 및 상태 요약
    - 모유: 마지막 수유 시간, 진행 중인 수유 타이머
    - 분유: 마지막 수유 시간, 수유량
    - 이유식: 마지막 수유 시간
    - 기저귀: 마지막 교체 시간, 종류 (젖음/대변/둘 다)
    - 수면: 마지막 수면 시간, 상태 (잠듦/깸)
    - 유축: 마지막 유축 시간
  - 현재 진행 중인 활동 (예: 수유 타이머)
  - 일별 통계 요약 (총 수유량, 수유 시간, 수면 시간 등)
- **빠른 기록 추가**: 대시보드에서 직접 기록 생성
- **진행 중인 활동 관리**: 수유 타이머 시작/일시정지/완료

#### 2.1.2 아이 프로필 관리
- 아이 정보 등록/조회/수정
  - 이름, 생년월일, 성별, 출생 체중/신장
  - 여러 아이 관리 지원 (향후 확장)

#### 2.1.3 수유 기록
- 수유 기록 생성/조회/수정/삭제
  - 수유 유형: 모유, 분유, 혼합, 이유식, 유축
  - 수유량 (ml 또는 g)
  - 수유 시간 (분) - 모유 수유의 경우
  - 좌/우/양쪽 - 모유 수유의 경우
  - 기록 시간 (기본값: 현재 시간, 수정 가능)
  - **진행 중인 수유 타이머**: 모유 수유 시작/일시정지/완료

#### 2.1.4 육아 기록
- 육아 기록 생성/조회/수정/삭제
  - 기록 유형: 수면, 기저귀, 체온, 약물, 활동, 기타
  - 수면: 시작 시간, 종료 시간, 수면 시간, 상태 (잠듦/깸)
  - 기저귀: 젖음/대변/둘 다/건조
  - 체온: 체온 (°C)
  - 약물: 약물명, 용량
  - 활동/기타: 설명, 메모
  - 기록 시간 (기본값: 현재 시간, 수정 가능)

#### 2.1.5 GPT 질문 기능
- GPT에게 질문하기
  - 질문 입력
  - 최근 기록 데이터를 컨텍스트로 자동 포함
  - 아이의 기본 정보 (이름, 생년월일 등) 포함
  - GPT 응답 저장 및 조회
  - 대화 기록 목록 조회

### 2.2 제외 기능 (Out of Scope for MVP)
- 차트/그래프 시각화 (통계는 텍스트로 제공)
- 알림/리마인더 (UI에 표시만, 푸시 알림 없음)
- 사진 첨부
- **가족 초대 및 다중 사용자 공유** (향후 기능으로 계획됨)
- 데이터 내보내기/백업
- 모바일 앱 (웹 API만 제공)

---

## 3. 기능 상세 명세

### 3.1 통합 대시보드 (핵심 기능)

**대시보드의 핵심 가치**:
- **한 화면에서 모든 정보 확인**: 수유, 수면, 기저귀 등 모든 활동의 최신 상태를 한 번에 확인
- **실시간 상태 표시**: 마지막 기록 시간을 상대 시간으로 표시 (예: "4분전", "2시간 전")
- **진행 중인 활동 관리**: 현재 진행 중인 수유 타이머를 실시간으로 추적
- **일별 통계 요약**: 선택한 날짜의 총 수유량, 수유 시간, 수면 시간 등을 한눈에 확인
- **빠른 기록 추가**: 대시보드에서 바로 기록 추가 가능

#### 3.1.1 대시보드 조회
**엔드포인트**: `GET /api/v1/baby-care/babies/{baby_id}/dashboard`

**쿼리 파라미터**:
- `date`: 조회할 날짜 (ISO 8601, 기본값: 오늘)

**응답 구조**:
```json
{
  "baby": {
    "id": 1,
    "name": "홍길동",
    "birth_date": "2025-12-01",
    "age_days": 67,
    "age_months": 2,
    "age_display": "7개월 8일"
  },
  "last_records": {
    "breast_milk": {
      "last_time": "2026-02-06T14:26:00Z",
      "time_ago_minutes": 4,
      "time_ago_display": "4분전",
      "duration_minutes": 15,
      "side": "left",
      "is_active": false
    },
    "formula": {
      "last_time": "2026-02-06T10:04:00Z",
      "time_ago_minutes": 266,
      "time_ago_display": "4시간 22분전",
      "amount": 85
    },
    "solid": {
      "last_time": null,
      "time_ago_display": "기록 없음"
    },
    "diaper": {
      "last_time": "2026-02-06T12:27:00Z",
      "time_ago_minutes": 123,
      "time_ago_display": "2시간 3분전",
      "type": "dirty",
      "type_display": "대변"
    },
    "sleep": {
      "last_time": "2026-02-06T11:28:00Z",
      "time_ago_minutes": 178,
      "time_ago_display": "2시간 52분전",
      "status": "awake",
      "status_display": "낮잠 깸",
      "duration_minutes": 90
    },
    "pumping": {
      "last_time": null,
      "time_ago_display": "기록 없음"
    }
  },
  "active_feeding": {
    "is_active": true,
    "started_at": "2026-02-06T12:11:00Z",
    "elapsed_minutes": 255,
    "elapsed_display": "04:23",
    "left_breast": {
      "started_at": "2026-02-06T14:25:00Z",
      "elapsed_minutes": 1,
      "elapsed_display": "01:20",
      "status": "feeding",
      "status_display": "수유중"
    },
    "right_breast": {
      "started_at": null,
      "elapsed_minutes": 182,
      "elapsed_display": "03:02",
      "status": "waiting",
      "status_display": "시작 대기"
    }
  },
  "daily_summary": {
    "date": "2026-02-06",
    "date_display": "6월 29일 (수, 220일)",
    "feeding": {
      "total_amount_ml": 110,
      "total_duration_minutes": 25,
      "breast_milk_duration_minutes": 25,
      "formula_amount_ml": 110,
      "formula_breakdown": [85, 25],
      "display": "110ml(85+25)+25분"
    },
    "sleep": {
      "total_minutes": 600,
      "total_display": "10시간"
    },
    "diaper": {
      "count": 6
    }
  }
}
```

**주요 기능**:
- 모든 활동의 마지막 기록 시간을 상대 시간으로 표시 (예: "4분전", "2시간 3분전")
- 진행 중인 수유 타이머 정보 제공 (좌/우 유방별 시간 추적)
- 선택한 날짜의 일별 통계 요약 (총 수유량, 수유 시간, 수면 시간 등)
- 기록이 없는 활동은 "기록 없음"으로 표시

**사용 시나리오**:
1. 사용자가 대시보드를 열면 모든 활동의 최신 상태를 즉시 확인
2. "마지막 수유 4분전"을 보고 다음 수유 시간을 예상
3. "마지막 기저귀 2시간 3분전"을 보고 기저귀 교체 필요 여부 판단
4. 진행 중인 수유 타이머를 확인하여 좌/우 전환 시점 결정
5. 일별 통계를 확인하여 하루 수유량이 충분한지 판단

#### 3.1.2 빠른 기록 추가
**엔드포인트**: `POST /api/v1/baby-care/babies/{baby_id}/quick-record`

**요청 본문 예시 (모유)**:
```json
{
  "record_type": "breast_milk",
  "data": {
    "side": "left",
    "duration_minutes": 15,
    "notes": "잘 먹었어요"
  },
  "recorded_at": "2026-02-06T14:30:00Z"
}
```

**요청 본문 예시 (분유)**:
```json
{
  "record_type": "formula",
  "data": {
    "amount": 85
  }
}
```

**요청 본문 예시 (이유식)**:
```json
{
  "record_type": "solid",
  "data": {
    "amount": 50,
    "notes": "쌀미음"
  }
}
```

**요청 본문 예시 (기저귀)**:
```json
{
  "record_type": "diaper",
  "data": {
    "diaper_type": "both"
  }
}
```

**요청 본문 예시 (유축)**:
```json
{
  "record_type": "pumping",
  "data": {
    "amount": 120,
    "side": "both"
  }
}
```

**record_type 옵션**:
- `breast_milk`: 모유
- `formula`: 분유
- `solid`: 이유식
- `diaper`: 기저귀
- `pumping`: 유축

**응답**: 생성된 기록 정보 및 업데이트된 대시보드 상태

#### 3.1.3 수유 타이머 시작
**엔드포인트**: `POST /api/v1/baby-care/babies/{baby_id}/feeding-timer/start`

**요청 본문**:
```json
{
  "side": "left",  // "left", "right"
  "started_at": "2026-02-06T14:30:00Z"  // 선택사항
}
```

**응답**: 시작된 타이머 정보

#### 3.1.4 수유 타이머 전환 (좌↔우)
**엔드포인트**: `POST /api/v1/baby-care/babies/{baby_id}/feeding-timer/switch`

**요청 본문**:
```json
{
  "from_side": "left",
  "to_side": "right",
  "from_duration_minutes": 15,  // 이전 유방의 수유 시간
  "switched_at": "2026-02-06T14:45:00Z"
}
```

**응답**: 업데이트된 타이머 정보

#### 3.1.5 수유 타이머 완료
**엔드포인트**: `POST /api/v1/baby-care/babies/{baby_id}/feeding-timer/complete`

**요청 본문**:
```json
{
  "left_duration_minutes": 15,
  "right_duration_minutes": 20,
  "notes": "잘 먹었어요",
  "completed_at": "2026-02-06T15:00:00Z"
}
```

**동작**:
1. 진행 중인 타이머 종료
2. 수유 기록 생성 (좌/우 시간 포함)
3. 응답: 생성된 기록 및 업데이트된 대시보드

**응답**: 생성된 수유 기록 및 업데이트된 대시보드 상태

#### 3.1.6 수면 기록 시작/종료
**엔드포인트**: `POST /api/v1/baby-care/babies/{baby_id}/sleep/start`
**엔드포인트**: `POST /api/v1/baby-care/babies/{baby_id}/sleep/end`

**시작 요청**:
```json
{
  "started_at": "2026-02-06T20:00:00Z",
  "sleep_type": "night"  // "night", "nap"
}
```

**동작**:
- 진행 중인 수면 기록이 없으면 새로 생성
- 진행 중인 수면 기록이 있으면 기존 기록 업데이트

**종료 요청**:
```json
{
  "ended_at": "2026-02-07T06:00:00Z"
}
```

**동작**:
- 가장 최근의 진행 중인 수면 기록을 찾아 종료 시간 업데이트
- 수면 시간 자동 계산

**응답**: 생성/업데이트된 수면 기록 및 업데이트된 대시보드 상태

---

### 3.2 아이 프로필 관리

#### 3.1.1 아이 등록
**엔드포인트**: `POST /api/v1/baby-care/babies`

**요청 본문**:
```json
{
  "name": "홍길동",
  "birth_date": "2025-12-01",
  "gender": "male",
  "birth_weight": 3.2,
  "birth_height": 50.5,
  "notes": "첫째 아이"
}
```

**응답**: 생성된 아이 정보 (ID 포함)

#### 3.1.2 아이 목록 조회
**엔드포인트**: `GET /api/v1/baby-care/babies`

**응답**: 사용자의 모든 아이 목록

#### 3.1.3 아이 상세 조회
**엔드포인트**: `GET /api/v1/baby-care/babies/{baby_id}`

**응답**: 특정 아이의 상세 정보

#### 3.1.4 아이 정보 수정
**엔드포인트**: `PUT /api/v1/baby-care/babies/{baby_id}`

**요청 본문**: 수정할 필드만 포함

#### 3.1.5 아이 삭제
**엔드포인트**: `DELETE /api/v1/baby-care/babies/{baby_id}`

**주의**: 관련된 모든 기록(수유, 육아, GPT 대화)도 함께 삭제됨 (CASCADE)

---

### 3.2 수유 기록

#### 3.2.1 수유 기록 생성
**엔드포인트**: `POST /api/v1/baby-care/babies/{baby_id}/feeding-records`

**요청 본문**:
```json
{
  "feeding_type": "breast_milk",
  "amount": null,
  "duration_minutes": 15,
  "side": "left",
  "notes": "잘 먹었어요",
  "recorded_at": "2026-02-06T14:30:00Z"
}
```

**feeding_type 옵션**:
- `breast_milk`: 모유
- `formula`: 분유
- `mixed`: 혼합
- `solid`: 이유식
- `pumping`: 유축

**side 옵션** (모유 수유의 경우):
- `left`: 왼쪽
- `right`: 오른쪽
- `both`: 양쪽

#### 3.2.2 수유 기록 목록 조회
**엔드포인트**: `GET /api/v1/baby-care/babies/{baby_id}/feeding-records`

**쿼리 파라미터**:
- `limit`: 페이지 크기 (기본값: 50, 최대: 100)
- `offset`: 페이지 오프셋 (기본값: 0)
- `start_date`: 시작 날짜 (ISO 8601)
- `end_date`: 종료 날짜 (ISO 8601)

**응답**: 수유 기록 목록 (최신순)

#### 3.2.3 수유 기록 상세 조회
**엔드포인트**: `GET /api/v1/baby-care/babies/{baby_id}/feeding-records/{record_id}`

#### 3.2.4 수유 기록 수정
**엔드포인트**: `PUT /api/v1/baby-care/babies/{baby_id}/feeding-records/{record_id}`

#### 3.2.5 수유 기록 삭제
**엔드포인트**: `DELETE /api/v1/baby-care/babies/{baby_id}/feeding-records/{record_id}`

---

### 3.3 육아 기록

#### 3.3.1 육아 기록 생성
**엔드포인트**: `POST /api/v1/baby-care/babies/{baby_id}/care-records`

**요청 본문 예시 (수면)**:
```json
{
  "record_type": "sleep",
  "sleep_start": "2026-02-06T20:00:00Z",
  "sleep_end": "2026-02-07T06:00:00Z",
  "sleep_duration_minutes": 600,
  "recorded_at": "2026-02-06T20:00:00Z"
}
```

**요청 본문 예시 (기저귀)**:
```json
{
  "record_type": "diaper",
  "diaper_type": "both",
  "recorded_at": "2026-02-06T15:30:00Z"
}
```

**요청 본문 예시 (체온)**:
```json
{
  "record_type": "temperature",
  "temperature": 36.5,
  "recorded_at": "2026-02-06T16:00:00Z"
}
```

**요청 본문 예시 (약물)**:
```json
{
  "record_type": "medicine",
  "medicine_name": "타이레놀",
  "medicine_dosage": "2.5ml",
  "recorded_at": "2026-02-06T17:00:00Z"
}
```

**record_type 옵션**:
- `sleep`: 수면
- `diaper`: 기저귀
- `temperature`: 체온
- `medicine`: 약물
- `activity`: 활동
- `pumping`: 유축
- `other`: 기타

**diaper_type 옵션**:
- `wet`: 젖음
- `dirty`: 대변
- `both`: 둘 다
- `dry`: 건조

#### 3.3.2 육아 기록 목록 조회
**엔드포인트**: `GET /api/v1/baby-care/babies/{baby_id}/care-records`

**쿼리 파라미터**:
- `limit`: 페이지 크기 (기본값: 50, 최대: 100)
- `offset`: 페이지 오프셋 (기본값: 0)
- `record_type`: 기록 유형 필터
- `start_date`: 시작 날짜 (ISO 8601)
- `end_date`: 종료 날짜 (ISO 8601)

#### 3.3.3 육아 기록 상세 조회
**엔드포인트**: `GET /api/v1/baby-care/babies/{baby_id}/care-records/{record_id}`

#### 3.3.4 육아 기록 수정
**엔드포인트**: `PUT /api/v1/baby-care/babies/{baby_id}/care-records/{record_id}`

#### 3.3.5 육아 기록 삭제
**엔드포인트**: `DELETE /api/v1/baby-care/babies/{baby_id}/care-records/{record_id}`

---

### 3.4 GPT 질문 기능

#### 3.4.1 GPT에게 질문하기
**엔드포인트**: `POST /api/v1/baby-care/babies/{baby_id}/gpt-questions`

**요청 본문**:
```json
{
  "question": "아이가 최근 수유량이 줄었는데 괜찮을까요?",
  "context_days": 7
}
```

**동작 방식**:
1. 최근 N일간의 기록 데이터를 자동으로 수집 (기본값: 7일)
2. 아이의 기본 정보와 함께 컨텍스트 구성
3. GPT API 호출 (프롬프트에 컨텍스트 포함)
4. 질문과 응답을 데이터베이스에 저장
5. 응답 반환

**컨텍스트 데이터 포함 내용**:
- 아이 정보: 이름, 생년월일, 성별, 출생 체중/신장
- 최근 수유 기록 요약: 일일 평균 수유량, 수유 횟수, 수유 패턴
- 최근 육아 기록 요약: 수면 패턴, 기저귀 교체 빈도, 체온 기록 등
- 특이사항: 비정상적인 패턴이나 주의할 점

**프롬프트 예시**:
```
당신은 육아 전문가입니다. 다음 정보를 바탕으로 사용자의 질문에 답변해주세요.

[아이 정보]
이름: 홍길동
생년월일: 2025-12-01
성별: 남성
출생 체중: 3.2kg
출생 신장: 50.5cm
현재 나이: 약 2개월

[최근 7일간 기록 요약]
- 평균 일일 수유 횟수: 8회
- 평균 일일 수유량: 600ml
- 평균 수면 시간: 14시간
- 기저귀 교체 빈도: 하루 6-8회

[사용자 질문]
아이가 최근 수유량이 줄었는데 괜찮을까요?

[지침]
1. 제공된 기록 데이터를 바탕으로 답변하세요.
2. 전문적이지만 이해하기 쉬운 언어를 사용하세요.
3. 필요시 병원 방문을 권장하세요.
4. 구체적이고 실용적인 조언을 제공하세요.
```

**응답**:
```json
{
  "id": 1,
  "question": "아이가 최근 수유량이 줄었는데 괜찮을까요?",
  "answer": "2개월 된 아이의 경우...",
  "context_data": {
    "summary": {
      "feeding_summary": {...},
      "care_summary": {...}
    },
    "context_days": 7
  },
  "created_at": "2026-02-06T18:00:00Z"
}
```

#### 3.4.2 GPT 대화 기록 목록 조회
**엔드포인트**: `GET /api/v1/baby-care/babies/{baby_id}/gpt-conversations`

**쿼리 파라미터**:
- `limit`: 페이지 크기 (기본값: 20, 최대: 100)
- `offset`: 페이지 오프셋 (기본값: 0)

**응답**: GPT 대화 기록 목록 (최신순)

#### 3.4.3 GPT 대화 기록 상세 조회
**엔드포인트**: `GET /api/v1/baby-care/babies/{baby_id}/gpt-conversations/{conversation_id}`

---

### 3.5 가족 초대 및 공유 기능 (Phase 2 - 향후 구현)

#### 3.5.1 개요
아이의 육아 기록을 배우자(남편/아내) 및 가족 멤버와 공유할 수 있는 기능입니다. 초대받은 가족 멤버는 아이의 기록을 조회하고, 권한에 따라 기록을 추가/수정할 수 있습니다.

#### 3.5.2 가족 멤버 초대
**엔드포인트**: `POST /api/v1/baby-care/babies/{baby_id}/family/invite`

**요청 본문**:
```json
{
  "email": "spouse@example.com",
  "role": "parent",  // "parent", "caregiver", "viewer"
  "permissions": {
    "can_view": true,
    "can_create_records": true,
    "can_edit_records": true,
    "can_delete_records": false,
    "can_invite_others": false,
    "can_manage_baby_profile": false
  },
  "message": "아이의 육아 기록을 함께 관리해요!"
}
```

**역할 (role) 옵션**:
- `parent`: 부모 (모든 권한)
- `caregiver`: 보육자 (기록 추가/수정 가능)
- `viewer`: 조회자 (읽기 전용)

**동작**:
1. 초대 이메일 발송 (초대 링크 포함)
2. 초대 기록 생성 (상태: `pending`)
3. 초대 수락 시 가족 멤버로 추가

**응답**:
```json
{
  "invitation_id": "inv_123",
  "email": "spouse@example.com",
  "status": "pending",
  "expires_at": "2026-02-13T00:00:00Z",
  "created_at": "2026-02-06T18:00:00Z"
}
```

#### 3.5.3 초대 수락
**엔드포인트**: `POST /api/v1/baby-care/invitations/{invitation_token}/accept`

**요청 본문**:
```json
{
  "user_id": "user_uuid"  // 초대 수락하는 사용자의 ID
}
```

**동작**:
1. 초대 토큰 검증
2. 초대 상태를 `accepted`로 변경
3. `baby_family_members` 테이블에 멤버 추가
4. 초대한 사용자에게 알림 (선택사항)

#### 3.5.4 초대 거절
**엔드포인트**: `POST /api/v1/baby-care/invitations/{invitation_token}/reject`

**동작**:
1. 초대 토큰 검증
2. 초대 상태를 `rejected`로 변경

#### 3.5.5 가족 멤버 목록 조회
**엔드포인트**: `GET /api/v1/baby-care/babies/{baby_id}/family/members`

**응답**:
```json
{
  "members": [
    {
      "user_id": "user_uuid_1",
      "email": "parent1@example.com",
      "role": "parent",
      "permissions": {
        "can_view": true,
        "can_create_records": true,
        "can_edit_records": true,
        "can_delete_records": true,
        "can_invite_others": true,
        "can_manage_baby_profile": true
      },
      "joined_at": "2025-12-01T00:00:00Z",
      "is_owner": true
    },
    {
      "user_id": "user_uuid_2",
      "email": "spouse@example.com",
      "role": "parent",
      "permissions": {
        "can_view": true,
        "can_create_records": true,
        "can_edit_records": true,
        "can_delete_records": false,
        "can_invite_others": false,
        "can_manage_baby_profile": false
      },
      "joined_at": "2026-02-06T18:00:00Z",
      "is_owner": false
    }
  ],
  "pending_invitations": [
    {
      "invitation_id": "inv_123",
      "email": "grandma@example.com",
      "role": "viewer",
      "status": "pending",
      "invited_at": "2026-02-06T19:00:00Z",
      "expires_at": "2026-02-13T00:00:00Z"
    }
  ]
}
```

#### 3.5.6 가족 멤버 권한 수정
**엔드포인트**: `PUT /api/v1/baby-care/babies/{baby_id}/family/members/{member_id}`

**요청 본문**:
```json
{
  "role": "caregiver",
  "permissions": {
    "can_view": true,
    "can_create_records": true,
    "can_edit_records": true,
    "can_delete_records": false,
    "can_invite_others": false,
    "can_manage_baby_profile": false
  }
}
```

**권한 요구사항**: 소유자(owner)만 다른 멤버의 권한을 수정할 수 있음

#### 3.5.7 가족 멤버 제거
**엔드포인트**: `DELETE /api/v1/baby-care/babies/{baby_id}/family/members/{member_id}`

**권한 요구사항**: 소유자(owner)만 멤버를 제거할 수 있음

**동작**:
1. 멤버 제거
2. 제거된 멤버에게 알림 (선택사항)

#### 3.5.8 초대 취소
**엔드포인트**: `DELETE /api/v1/baby-care/babies/{baby_id}/family/invitations/{invitation_id}`

**권한 요구사항**: 초대를 보낸 사용자 또는 소유자만 취소 가능

#### 3.5.9 권한 검증
모든 기록 관련 API에서 가족 멤버 권한을 검증:
- `can_view`: 기록 조회 권한
- `can_create_records`: 기록 생성 권한
- `can_edit_records`: 기록 수정 권한
- `can_delete_records`: 기록 삭제 권한
- `can_manage_baby_profile`: 아이 프로필 관리 권한

**예시**: 기록 생성 시
```python
# 권한 검증 로직
if not member_permissions.can_create_records:
    raise PermissionDenied("기록 생성 권한이 없습니다.")
```

#### 3.5.10 데이터베이스 스키마 (향후 추가)

**baby_family_members 테이블**:
```sql
CREATE TABLE IF NOT EXISTS public.baby_family_members (
    id BIGSERIAL PRIMARY KEY,
    baby_id BIGINT NOT NULL REFERENCES public.babies(id) ON DELETE CASCADE,
    user_id UUID NOT NULL, -- references auth.users(id)
    role VARCHAR(20) NOT NULL, -- 'parent', 'caregiver', 'viewer'
    permissions JSONB NOT NULL, -- 권한 정보
    is_owner BOOLEAN DEFAULT false,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(baby_id, user_id)
);

CREATE INDEX idx_baby_family_members_baby_id ON public.baby_family_members(baby_id);
CREATE INDEX idx_baby_family_members_user_id ON public.baby_family_members(user_id);
```

**baby_family_invitations 테이블**:
```sql
CREATE TABLE IF NOT EXISTS public.baby_family_invitations (
    id BIGSERIAL PRIMARY KEY,
    baby_id BIGINT NOT NULL REFERENCES public.babies(id) ON DELETE CASCADE,
    inviter_user_id UUID NOT NULL, -- 초대한 사용자
    email VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    permissions JSONB NOT NULL,
    invitation_token VARCHAR(255) UNIQUE NOT NULL,
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'accepted', 'rejected', 'expired'
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    accepted_at TIMESTAMP WITH TIME ZONE,
    rejected_at TIMESTAMP WITH TIME ZONE,
    message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_baby_family_invitations_baby_id ON public.baby_family_invitations(baby_id);
CREATE INDEX idx_baby_family_invitations_token ON public.baby_family_invitations(invitation_token);
CREATE INDEX idx_baby_family_invitations_email ON public.baby_family_invitations(email);
CREATE INDEX idx_baby_family_invitations_status ON public.baby_family_invitations(status);
```

**RLS 정책**:
- 가족 멤버는 자신이 속한 아이의 데이터만 조회 가능
- 권한에 따라 기록 생성/수정/삭제 가능
- 소유자는 모든 권한 보유

---

## 4. 기술 스택 및 아키텍처

### 4.1 기술 스택
- **백엔드**: FastAPI (Python 3.11+)
- **데이터베이스**: Supabase (PostgreSQL)
- **인증**: Supabase Auth (JWT)
- **AI 서비스**: OpenAI GPT-4o-mini 또는 Gemini 2.0 Flash (설정 가능)

### 4.2 프로젝트 구조
프로젝트는 모듈식 멀티 프로젝트 아키텍처를 따릅니다:

```
app/
├── projects/
│   └── baby_care/          # Baby Care 프로젝트
│       ├── router.py       # 프로젝트 라우터
│       ├── api/
│       │   └── endpoints.py
│       ├── services/
│       │   ├── baby_service.py
│       │   ├── feeding_record_service.py
│       │   ├── care_record_service.py
│       │   ├── gpt_conversation_service.py
│       │   └── family_service.py  # 향후 추가 (Phase 2)
│       ├── repositories/
│       │   ├── baby_repository.py
│       │   ├── feeding_record_repository.py
│       │   ├── care_record_repository.py
│       │   ├── gpt_conversation_repository.py
│       │   └── family_repository.py  # 향후 추가 (Phase 2)
│       └── schemas/
│           └── baby_care.py
├── core/                   # 공통 모듈
│   ├── auth/              # 인증
│   ├── config.py
│   ├── database.py
│   └── dependencies.py
└── main.py
```

### 4.3 API 경로 구조
- **Base Path**: `/api/v1`
- **Project Prefix**: `/baby-care`
- **최종 경로 예시**:
  - `GET /api/v1/baby-care/babies/{baby_id}/dashboard` (핵심: 통합 대시보드)
  - `POST /api/v1/baby-care/babies/{baby_id}/quick-record` (핵심: 빠른 기록)
  - `POST /api/v1/baby-care/babies/{baby_id}/feeding-timer/start` (핵심: 수유 타이머)
  - `GET /api/v1/baby-care/babies`
  - `POST /api/v1/baby-care/babies/{baby_id}/feeding-records`
  - `POST /api/v1/baby-care/babies/{baby_id}/gpt-questions`

### 4.4 데이터베이스 스키마
이미 `sql/baby_care_schema.sql`에 정의된 테이블 사용:
- `babies`: 아이 정보
- `feeding_records`: 수유 기록
- `baby_care_records`: 육아 기록
- `gpt_conversations`: GPT 대화 기록

**추가 고려사항**:
- 진행 중인 수유 타이머 상태는 `feeding_records` 테이블의 `is_active` 필드 또는 별도 세션 테이블로 관리
- 대시보드 조회 성능을 위해 인덱스 최적화 필요

**향후 추가 예정 (Phase 2)**:
- `baby_family_members`: 가족 멤버 정보 및 권한
- `baby_family_invitations`: 가족 초대 기록

---

## 5. 인증 및 보안

### 5.1 인증 방식
- Supabase Auth JWT 토큰 사용
- 모든 엔드포인트는 인증 필수
- `Authorization: Bearer <token>` 헤더 사용

### 5.2 권한 관리
- Row Level Security (RLS) 활성화
- 사용자는 자신의 데이터만 접근 가능
- `user_id` 기반 데이터 격리

**향후 확장 (Phase 2)**:
- 가족 멤버 권한 관리
- 역할 기반 접근 제어 (RBAC)
- 세분화된 권한 설정 (조회/생성/수정/삭제)

### 5.3 데이터 검증
- Pydantic 스키마를 통한 요청/응답 검증
- 필수 필드 검증
- 데이터 타입 및 범위 검증

---

## 6. 에러 처리

### 6.1 에러 응답 형식
```json
{
  "detail": "에러 메시지",
  "code": "ERROR_CODE"
}
```

### 6.2 주요 에러 케이스
- `401 Unauthorized`: 인증 실패
- `403 Forbidden`: 권한 없음
- `404 Not Found`: 리소스를 찾을 수 없음
- `422 Unprocessable Entity`: 요청 데이터 검증 실패
- `500 Internal Server Error`: 서버 오류

---

## 7. 성능 요구사항

### 7.1 응답 시간
- 대시보드 API: 300ms 이하 (여러 테이블 조인 및 집계 포함)
- 일반 API: 200ms 이하
- 빠른 기록 API: 200ms 이하
- GPT 질문 API: 5초 이하 (GPT API 응답 시간 포함)

### 7.2 동시성
- 최소 10명의 동시 사용자 지원 (MVP)

### 7.3 데이터 제한
- 페이지네이션: 기본 50개, 최대 100개
- GPT 컨텍스트: 최근 7일간 기록 (기본값)

---

## 8. 우선순위

### Phase 1: 핵심 기능 (MVP) - 대시보드 중심
1. ✅ **통합 대시보드 조회** (최우선)
   - 모든 활동의 마지막 기록 시간 및 상태 표시
   - 진행 중인 수유 타이머 표시
   - 일별 통계 요약
2. ✅ **빠른 기록 추가** (대시보드에서 직접 기록)
3. ✅ **수유 타이머 관리** (시작/전환/완료)
4. ✅ 아이 프로필 관리 (CRUD)
5. ✅ 수유 기록 (CRUD)
6. ✅ 육아 기록 (CRUD)
7. ✅ GPT 질문 기능 (질문하기, 대화 기록 조회)

### Phase 2: 향후 개선 (Post-MVP)
- **가족 초대 및 공유 기능** (우선순위 높음)
  - 가족 멤버 초대 (이메일/전화번호)
  - 초대 수락/거절
  - 권한 관리 (읽기 전용/읽기+쓰기)
  - 가족 멤버별 기록 추가/수정 권한
  - 가족 멤버 목록 조회
  - 멤버 제거
- 차트/그래프 시각화
- 알림/리마인더 (푸시 알림)
- 데이터 내보내기/백업

---

## 9. 성공 지표

### 9.1 기능 완성도
- [ ] 모든 MVP 기능 구현 완료
- [ ] API 문서화 완료 (Swagger/ReDoc)
- [ ] 기본 에러 처리 구현

### 9.2 품질 지표
- [ ] API 응답 시간 목표 달성
- [ ] 에러율 1% 미만
- [ ] 데이터 검증 100% 통과

### 9.3 사용성
- [ ] API 호출 성공률 95% 이상
- [ ] GPT 응답 품질 만족도

---

## 10. 제약사항 및 가정

### 10.1 제약사항
- 웹 API만 제공 (프론트엔드 별도 개발 필요)
- GPT API 비용 고려 필요
- Supabase 무료 플랜 제한 고려

### 10.2 가정
- 사용자는 Supabase Auth로 인증됨
- 한 사용자는 여러 아이를 관리할 수 있음
- 기록 데이터는 실시간으로 입력됨
- GPT API는 안정적으로 동작함
- **향후**: 가족 멤버는 Supabase Auth 계정을 보유하고 있어야 초대 수락 가능

---

## 11. 참고 자료

### 11.1 프로젝트 문서
- `.cursor/rules/multi-project-modular-architecture.mdc`: 프로젝트 구조 가이드
- `sql/baby_care_schema.sql`: 데이터베이스 스키마
- `README.md`: 프로젝트 개요

### 11.2 외부 문서
- [FastAPI 공식 문서](https://fastapi.tiangolo.com/)
- [Supabase 문서](https://supabase.com/docs)
- [OpenAI API 문서](https://platform.openai.com/docs)

---

## 12. 변경 이력

| 버전 | 날짜 | 변경 내용 | 작성자 |
|------|------|----------|--------|
| 1.0 | 2026-02-06 | 초안 작성 | - |
| 2.0 | 2026-02-06 | 대시보드 중심으로 재작성<br>- 통합 대시보드 API 추가<br>- 빠른 기록 추가 API 추가<br>- 수유 타이머 관리 API 추가<br>- 일별 통계 요약 기능 추가 | - |
| 2.1 | 2026-02-06 | 가족 초대 기능 추가<br>- 가족 멤버 초대/수락/거절 API 설계<br>- 권한 관리 시스템 설계<br>- 데이터베이스 스키마 설계 (향후 구현) | - |

---

**다음 단계**:
1. 이 PRD를 기반으로 Implementation Plan 작성
2. 개발 시작
3. API 문서화 및 테스트

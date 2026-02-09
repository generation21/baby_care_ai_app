---
goal: 육아·수유 기록 앱 MVP 구현 - 대시보드 중심 Flutter 앱 개발
version: 1.0
date_created: 2026-02-08
last_updated: 2026-02-08
owner: Development Team
status: 'Planned'
tags: ['feature', 'mvp', 'dashboard', 'flutter', 'baby-care']
---

# Introduction

![Status: Planned](https://img.shields.io/badge/status-Planned-blue)

본 계획은 육아·수유 기록 앱 MVP를 Flutter로 구현하기 위한 전체 실행 계획입니다. 
PRD 문서에 명시된 대로, **통합 대시보드를 중심**으로 모든 육아 활동을 한 화면에서 관리하고, 
실시간 상태 표시 및 빠른 기록 추가 기능을 제공하며, GPT를 활용한 AI 조언 기능을 포함합니다.

## 1. Requirements & Constraints

### 기능 요구사항

- **REQ-001**: 통합 대시보드에서 모든 육아 활동(수유, 수면, 기저귀 등)의 최신 상태를 한 번에 조회
- **REQ-002**: 대시보드에서 원클릭으로 빠른 기록 추가 기능 제공
- **REQ-003**: 진행 중인 수유 타이머를 실시간으로 표시하고 관리
- **REQ-004**: 마지막 기록 시간을 상대 시간으로 표시 (예: "4분전", "2시간 전")
- **REQ-005**: 일별 통계 요약 표시 (총 수유량, 수유 시간, 수면 시간 등)
- **REQ-006**: 아이 프로필 관리 (생성, 조회, 수정, 삭제)
- **REQ-007**: 수유 기록 관리 (모유, 분유, 혼합, 이유식, 유축)
- **REQ-008**: 육아 기록 관리 (수면, 기저귀, 체온, 약물, 활동, 기타)
- **REQ-009**: GPT에게 질문하고 최근 기록 데이터를 컨텍스트로 활용하여 조언 받기
- **REQ-010**: 모든 기록의 생성, 조회, 수정, 삭제 기능 제공

### 인증 및 보안 요구사항

- **SEC-001**: Firebase Authentication을 사용한 사용자 인증
- **SEC-002**: 모든 API 요청에 Firebase ID Token 포함
- **SEC-003**: 사용자는 자신의 데이터만 접근 가능 (RLS 적용)
- **SEC-004**: 민감한 정보(API Key, 토큰)는 안전한 저장소에 보관

### 기술 제약사항

- **CON-001**: Flutter SDK 최신 안정 버전 사용
- **CON-002**: 백엔드 API는 FastAPI로 구현되어 있으며 `/api/v1/baby-care-ai` 경로 사용
- **CON-003**: 대시보드 API 응답 시간 300ms 이하, 일반 API 200ms 이하 목표
- **CON-004**: 페이지네이션 기본 50개, 최대 100개로 제한
- **CON-005**: ISO 8601 날짜/시간 형식 사용

### 프로젝트 가이드라인

- **GUD-001**: Provider 패턴을 사용한 상태 관리
- **GUD-002**: GoRouter를 사용한 라우팅 관리
- **GUD-003**: 모든 파일명은 snake_case 사용
- **GUD-004**: 클래스명은 PascalCase 사용
- **GUD-005**: JSON 직렬화를 위한 `json_serializable` 패키지 사용
- **GUD-006**: Material Design 3 가이드라인 준수
- **GUD-007**: 다크 모드 지원 고려

### 아키텍처 패턴

- **PAT-001**: Clean Architecture 원칙 준수 (Models, Services, Screens, Widgets 분리)
- **PAT-002**: Repository 패턴을 통한 데이터 접근 추상화
- **PAT-003**: Service 계층에서 비즈니스 로직 처리
- **PAT-004**: 단일 책임 원칙(SRP)을 따르는 위젯 설계
- **PAT-005**: 에러 처리는 중앙화된 ErrorHandler 사용

## 2. Implementation Steps

### Implementation Phase 1: 프로젝트 초기 설정 및 구조화

- GOAL-001: Flutter 프로젝트 기본 구조를 설정하고 필수 패키지를 설치하여 개발 환경을 구축한다.

| Task     | Description                                                                                               | Completed | Date |
| -------- | --------------------------------------------------------------------------------------------------------- | --------- | ---- |
| TASK-001 | `pubspec.yaml`에 필수 패키지 추가 (http/dio, provider, json_annotation, firebase_auth, flutter_secure_storage 등) |           |      |
| TASK-002 | `lib/config/api_config.dart` 생성 - API Base URL 및 타임아웃 설정                                                  |           |      |
| TASK-003 | `lib/utils/constants.dart` 생성 - 앱 전역 상수 정의                                                                |           |      |
| TASK-004 | `.env` 파일 생성 및 `flutter_dotenv` 설정 - 환경 변수 관리                                                            |           |      |
| TASK-005 | 프로젝트 디렉토리 구조 생성 (models, services, screens, widgets, states, clients, utils, theme)                       |           |      |
| TASK-006 | Firebase 프로젝트 설정 및 Flutter 앱에 연동 (Android/iOS)                                                            |           |      |

### Implementation Phase 2: 인증 시스템 구축

- GOAL-002: Firebase Authentication을 통합하고 사용자 인증 및 토큰 관리 시스템을 구현한다.

| Task     | Description                                                                             | Completed | Date |
| -------- | --------------------------------------------------------------------------------------- | --------- | ---- |
| TASK-007 | `lib/services/auth_service.dart` 생성 - Firebase Auth 로그인/로그아웃 구현                         |           |      |
| TASK-008 | `lib/clients/api_client.dart` 생성 - Dio HTTP 클라이언트 및 인증 인터셉터 구현                        |           |      |
| TASK-009 | `lib/states/auth_state.dart` 생성 - 인증 상태 관리 Provider 구현                                 |           |      |
| TASK-010 | `lib/screens/auth/login_screen.dart` 생성 - 로그인 화면 구현                                     |           |      |
| TASK-011 | `lib/screens/auth/signup_screen.dart` 생성 - 회원가입 화면 구현                                   |           |      |
| TASK-012 | `lib/utils/error_handler.dart` 생성 - 중앙화된 에러 처리 유틸리티 구현                                  |           |      |
| TASK-013 | Firebase ID Token 자동 갱신 로직 구현 (401 에러 발생 시 재로그인)                                        |           |      |

### Implementation Phase 3: 데이터 모델 정의

- GOAL-003: API 응답에 맞는 데이터 모델을 정의하고 JSON 직렬화 코드를 생성한다.

| Task     | Description                                                                               | Completed | Date |
| -------- | ----------------------------------------------------------------------------------------- | --------- | ---- |
| TASK-014 | `lib/models/baby.dart` 생성 - Baby 모델 및 JSON 직렬화 코드                                          |           |      |
| TASK-015 | `lib/models/feeding_record.dart` 생성 - FeedingRecord 모델 및 Enum (FeedingType) 정의           |           |      |
| TASK-016 | `lib/models/care_record.dart` 생성 - CareRecord 모델 및 Enum (CareRecordType, DiaperType) 정의 |           |      |
| TASK-017 | `lib/models/gpt_conversation.dart` 생성 - GPTConversation 모델                               |           |      |
| TASK-018 | `lib/models/dashboard.dart` 생성 - Dashboard, BabyInfo, TodaySummary, WeeklySummary 모델     |           |      |
| TASK-019 | `flutter pub run build_runner build` 실행 - JSON 직렬화 코드 자동 생성                              |           |      |

### Implementation Phase 4: API 서비스 레이어 구현

- GOAL-004: 백엔드 API와 통신하는 서비스 레이어를 구현하여 데이터 CRUD 기능을 제공한다.

| Task     | Description                                                                | Completed | Date |
| -------- | -------------------------------------------------------------------------- | --------- | ---- |
| TASK-020 | `lib/services/baby_api_service.dart` 생성 - Baby CRUD 및 대시보드 조회 API           |           |      |
| TASK-021 | `lib/services/feeding_api_service.dart` 생성 - FeedingRecord CRUD API        |           |      |
| TASK-022 | `lib/services/care_api_service.dart` 생성 - CareRecord CRUD API              |           |      |
| TASK-023 | `lib/services/gpt_api_service.dart` 생성 - GPT 질문 및 대화 기록 조회 API             |           |      |
| TASK-024 | `lib/services/dashboard_api_service.dart` 생성 - 빠른 기록 추가 및 타이머 관리 API       |           |      |
| TASK-025 | 모든 API 서비스에 에러 핸들링 및 ApiException 클래스 적용                                  |           |      |

### Implementation Phase 5: 상태 관리 구현

- GOAL-005: Provider 패턴을 사용하여 앱의 상태를 관리하고 화면과 데이터를 동기화한다.

| Task     | Description                                                                          | Completed | Date |
| -------- | ------------------------------------------------------------------------------------ | --------- | ---- |
| TASK-026 | `lib/states/baby_state.dart` 생성 - Baby 목록 및 선택된 Baby 상태 관리                          |           |      |
| TASK-027 | `lib/states/dashboard_state.dart` 생성 - 대시보드 데이터 및 로딩 상태 관리                          |           |      |
| TASK-028 | `lib/states/feeding_state.dart` 생성 - FeedingRecord 목록 및 페이지네이션 상태 관리                |           |      |
| TASK-029 | `lib/states/care_state.dart` 생성 - CareRecord 목록 및 페이지네이션 상태 관리                      |           |      |
| TASK-030 | `lib/states/gpt_state.dart` 생성 - GPT 대화 상태 및 로딩 상태 관리                                |           |      |
| TASK-031 | `lib/states/timer_state.dart` 생성 - 수유 타이머 상태 관리 (시작/일시정지/완료)                        |           |      |
| TASK-032 | 모든 상태 Provider를 `lib/main.dart`의 MultiProvider에 등록                                 |           |      |

### Implementation Phase 6: 라우팅 설정

- GOAL-006: GoRouter를 사용하여 앱의 라우팅을 설정하고 화면 전환을 구현한다.

| Task     | Description                                                                           | Completed | Date |
| -------- | ------------------------------------------------------------------------------------- | --------- | ---- |
| TASK-033 | `lib/router.dart` 생성 - GoRouter 설정 및 라우트 정의                                           |           |      |
| TASK-034 | 인증 상태에 따른 리다이렉트 로직 구현 (미인증 시 로그인 화면으로 이동)                                            |           |      |
| TASK-035 | 라우트 경로 정의: `/`, `/login`, `/signup`, `/dashboard`, `/babies`, `/baby/:id`, `/settings` |           |      |
| TASK-036 | 라우트 파라미터 전달 및 추출 로직 구현 (예: babyId)                                                   |           |      |

### Implementation Phase 7: 통합 대시보드 화면 구현 (핵심 기능)

- GOAL-007: 대시보드 화면을 구현하여 모든 육아 활동의 최신 상태를 한 번에 표시하고 빠른 기록 추가 기능을 제공한다.

| Task     | Description                                                                              | Completed | Date |
| -------- | ---------------------------------------------------------------------------------------- | --------- | ---- |
| TASK-037 | `lib/screens/dashboard/dashboard_screen.dart` 생성 - 메인 대시보드 화면                            |           |      |
| TASK-038 | `lib/widgets/dashboard/baby_info_card.dart` 생성 - 아이 프로필 정보 카드 위젯                         |           |      |
| TASK-039 | `lib/widgets/dashboard/last_records_section.dart` 생성 - 최근 기록 섹션 위젯 (모유, 분유, 기저귀, 수면 등) |           |      |
| TASK-040 | `lib/widgets/dashboard/active_feeding_timer.dart` 생성 - 진행 중인 수유 타이머 위젯                   |           |      |
| TASK-041 | `lib/widgets/dashboard/daily_summary_card.dart` 생성 - 일별 통계 요약 카드 위젯                      |           |      |
| TASK-042 | `lib/widgets/dashboard/quick_add_button.dart` 생성 - 빠른 기록 추가 플로팅 버튼                       |           |      |
| TASK-043 | 마지막 기록 시간을 상대 시간으로 표시하는 유틸리티 함수 구현 (`lib/utils/time_utils.dart`)                       |           |      |
| TASK-044 | 대시보드 자동 갱신 로직 구현 (Pull to Refresh)                                                      |           |      |
| TASK-045 | 로딩 상태 및 에러 상태 UI 구현                                                                      |           |      |

### Implementation Phase 8: 빠른 기록 추가 기능 구현

- GOAL-008: 대시보드에서 원클릭으로 기록을 추가할 수 있는 기능을 구현한다.

| Task     | Description                                                                               | Completed | Date |
| -------- | ----------------------------------------------------------------------------------------- | --------- | ---- |
| TASK-046 | `lib/screens/quick_add/quick_add_modal.dart` 생성 - 빠른 기록 추가 모달 바텀시트                        |           |      |
| TASK-047 | `lib/widgets/quick_add/record_type_selector.dart` 생성 - 기록 유형 선택 위젯 (모유, 분유, 기저귀 등)      |           |      |
| TASK-048 | `lib/widgets/quick_add/breast_milk_form.dart` 생성 - 모유 수유 빠른 입력 폼                          |           |      |
| TASK-049 | `lib/widgets/quick_add/formula_form.dart` 생성 - 분유 수유 빠른 입력 폼                              |           |      |
| TASK-050 | `lib/widgets/quick_add/diaper_form.dart` 생성 - 기저귀 교체 빠른 입력 폼                              |           |      |
| TASK-051 | `lib/widgets/quick_add/solid_form.dart` 생성 - 이유식 빠른 입력 폼                                  |           |      |
| TASK-052 | `lib/widgets/quick_add/pumping_form.dart` 생성 - 유축 빠른 입력 폼                                 |           |      |
| TASK-053 | 빠른 기록 추가 시 대시보드 자동 갱신 로직 구현                                                               |           |      |

### Implementation Phase 9: 수유 타이머 기능 구현

- GOAL-009: 진행 중인 수유 타이머를 실시간으로 추적하고 관리하는 기능을 구현한다.

| Task     | Description                                                                             | Completed | Date |
| -------- | --------------------------------------------------------------------------------------- | --------- | ---- |
| TASK-054 | `lib/screens/feeding/feeding_timer_screen.dart` 생성 - 수유 타이머 전체 화면                       |           |      |
| TASK-055 | `lib/widgets/feeding/timer_display.dart` 생성 - 타이머 시간 표시 위젯 (분:초 형식)                    |           |      |
| TASK-056 | `lib/widgets/feeding/breast_side_selector.dart` 생성 - 좌/우 유방 선택 위젯                       |           |      |
| TASK-057 | `lib/widgets/feeding/timer_controls.dart` 생성 - 시작/일시정지/전환/완료 버튼 위젯                     |           |      |
| TASK-058 | 타이머 시작 API 호출 및 로컬 상태 동기화                                                               |           |      |
| TASK-059 | 타이머 전환(좌↔우) API 호출 및 UI 업데이트                                                            |           |      |
| TASK-060 | 타이머 완료 API 호출 및 수유 기록 생성                                                                |           |      |
| TASK-061 | 타이머 실시간 업데이트 로직 구현 (1초마다 경과 시간 업데이트)                                                   |           |      |

### Implementation Phase 10: 아이 프로필 관리 화면 구현

- GOAL-010: 아이 프로필을 생성, 조회, 수정, 삭제할 수 있는 화면을 구현한다.

| Task     | Description                                                                       | Completed | Date |
| -------- | --------------------------------------------------------------------------------- | --------- | ---- |
| TASK-062 | `lib/screens/baby/baby_list_screen.dart` 생성 - 아이 목록 화면                           |           |      |
| TASK-063 | `lib/screens/baby/baby_detail_screen.dart` 생성 - 아이 상세 정보 화면                      |           |      |
| TASK-064 | `lib/screens/baby/add_baby_screen.dart` 생성 - 아이 추가 화면 (폼 입력)                     |           |      |
| TASK-065 | `lib/screens/baby/edit_baby_screen.dart` 생성 - 아이 정보 수정 화면                        |           |      |
| TASK-066 | `lib/widgets/baby/baby_card.dart` 생성 - 아이 정보 카드 위젯 (목록용)                         |           |      |
| TASK-067 | `lib/widgets/baby/baby_form.dart` 생성 - 아이 정보 입력 폼 위젯 (재사용 가능)                    |           |      |
| TASK-068 | 아이 삭제 확인 다이얼로그 구현 (관련 기록도 함께 삭제 경고)                                             |           |      |
| TASK-069 | 나이 계산 및 표시 로직 구현 (일, 개월 표시)                                                     |           |      |

### Implementation Phase 11: 수유 기록 관리 화면 구현

- GOAL-011: 수유 기록을 조회, 생성, 수정, 삭제할 수 있는 화면을 구현한다.

| Task     | Description                                                                        | Completed | Date |
| -------- | ---------------------------------------------------------------------------------- | --------- | ---- |
| TASK-070 | `lib/screens/feeding/feeding_list_screen.dart` 생성 - 수유 기록 목록 화면 (무한 스크롤)         |           |      |
| TASK-071 | `lib/screens/feeding/feeding_detail_screen.dart` 생성 - 수유 기록 상세 화면                |           |      |
| TASK-072 | `lib/screens/feeding/add_feeding_screen.dart` 생성 - 수유 기록 추가 화면 (상세 입력)           |           |      |
| TASK-073 | `lib/screens/feeding/edit_feeding_screen.dart` 생성 - 수유 기록 수정 화면                  |           |      |
| TASK-074 | `lib/widgets/feeding/feeding_record_card.dart` 생성 - 수유 기록 카드 위젯                   |           |      |
| TASK-075 | `lib/widgets/feeding/feeding_type_filter.dart` 생성 - 수유 타입 필터 위젯 (모유/분유/이유식 등)   |           |      |
| TASK-076 | 날짜 범위 필터 구현 (startDate, endDate)                                                  |           |      |
| TASK-077 | 페이지네이션 구현 (무한 스크롤, offset 기반)                                                     |           |      |
| TASK-078 | 수유 기록 삭제 확인 다이얼로그 구현                                                              |           |      |

### Implementation Phase 12: 육아 기록 관리 화면 구현

- GOAL-012: 육아 기록(수면, 기저귀, 체온, 약물 등)을 조회, 생성, 수정, 삭제할 수 있는 화면을 구현한다.

| Task     | Description                                                                     | Completed | Date |
| -------- | ------------------------------------------------------------------------------- | --------- | ---- |
| TASK-079 | `lib/screens/care/care_list_screen.dart` 생성 - 육아 기록 목록 화면 (무한 스크롤)            |           |      |
| TASK-080 | `lib/screens/care/care_detail_screen.dart` 생성 - 육아 기록 상세 화면                   |           |      |
| TASK-081 | `lib/screens/care/add_care_screen.dart` 생성 - 육아 기록 추가 화면 (타입별 다른 폼)          |           |      |
| TASK-082 | `lib/screens/care/edit_care_screen.dart` 생성 - 육아 기록 수정 화면                     |           |      |
| TASK-083 | `lib/widgets/care/care_record_card.dart` 생성 - 육아 기록 카드 위젯                      |           |      |
| TASK-084 | `lib/widgets/care/care_type_filter.dart` 생성 - 기록 타입 필터 위젯 (수면/기저귀/체온 등)      |           |      |
| TASK-085 | `lib/widgets/care/diaper_form.dart` 생성 - 기저귀 교체 입력 폼                           |           |      |
| TASK-086 | `lib/widgets/care/sleep_form.dart` 생성 - 수면 기록 입력 폼 (시작/종료 시간)                 |           |      |
| TASK-087 | `lib/widgets/care/temperature_form.dart` 생성 - 체온 기록 입력 폼                       |           |      |
| TASK-088 | `lib/widgets/care/medicine_form.dart` 생성 - 약물 기록 입력 폼                          |           |      |
| TASK-089 | 수면 시간 자동 계산 로직 구현 (시작/종료 시간 차이)                                               |           |      |

### Implementation Phase 13: 수면 기록 시작/종료 기능 구현

- GOAL-013: 수면 기록을 시작하고 종료하는 기능을 구현한다.

| Task     | Description                                                          | Completed | Date |
| -------- | -------------------------------------------------------------------- | --------- | ---- |
| TASK-090 | `lib/screens/sleep/sleep_tracker_screen.dart` 생성 - 수면 추적 화면         |           |      |
| TASK-091 | `lib/widgets/sleep/sleep_timer_display.dart` 생성 - 수면 타이머 표시 위젯     |           |      |
| TASK-092 | `lib/widgets/sleep/sleep_controls.dart` 생성 - 수면 시작/종료 버튼 위젯        |           |      |
| TASK-093 | 수면 시작 API 호출 및 상태 동기화                                              |           |      |
| TASK-094 | 수면 종료 API 호출 및 수면 시간 자동 계산                                         |           |      |
| TASK-095 | 진행 중인 수면 상태를 대시보드에 표시                                              |           |      |

### Implementation Phase 14: GPT 질문 및 대화 기록 화면 구현

- GOAL-014: GPT에게 질문하고 대화 기록을 조회할 수 있는 화면을 구현한다.

| Task     | Description                                                                        | Completed | Date |
| -------- | ---------------------------------------------------------------------------------- | --------- | ---- |
| TASK-096 | `lib/screens/gpt/gpt_question_screen.dart` 생성 - GPT 질문 입력 화면                      |           |      |
| TASK-097 | `lib/screens/gpt/gpt_conversation_list_screen.dart` 생성 - GPT 대화 기록 목록 화면         |           |      |
| TASK-098 | `lib/screens/gpt/gpt_conversation_detail_screen.dart` 생성 - GPT 대화 상세 화면          |           |      |
| TASK-099 | `lib/widgets/gpt/question_input.dart` 생성 - 질문 입력 위젯 (멀티라인 텍스트필드)                 |           |      |
| TASK-100 | `lib/widgets/gpt/context_days_selector.dart` 생성 - 컨텍스트 기간 선택 위젯 (1-30일)         |           |      |
| TASK-101 | `lib/widgets/gpt/conversation_card.dart` 생성 - 대화 기록 카드 위젯                         |           |      |
| TASK-102 | GPT 질문 API 호출 시 로딩 인디케이터 표시 (최대 5초)                                             |           |      |
| TASK-103 | GPT 응답을 마크다운 형식으로 렌더링 (flutter_markdown 패키지 사용)                                 |           |      |
| TASK-104 | 질문/응답 복사하기 기능 구현                                                                 |           |      |

### Implementation Phase 15: 테마 및 디자인 시스템 구현

- GOAL-015: Material Design 3 기반의 일관된 디자인 시스템을 구축하고 다크 모드를 지원한다.

| Task     | Description                                                             | Completed | Date |
| -------- | ----------------------------------------------------------------------- | --------- | ---- |
| TASK-105 | `lib/theme/app_theme.dart` 생성 - 라이트/다크 테마 정의                           |           |      |
| TASK-106 | `lib/theme/app_colors.dart` 생성 - 앱 전역 색상 팔레트 정의                        |           |      |
| TASK-107 | `lib/theme/app_text_styles.dart` 생성 - 타이포그래피 스타일 정의 (Google Fonts 사용) |           |      |
| TASK-108 | `lib/theme/app_dimensions.dart` 생성 - 여백, 패딩, 크기 등 상수 정의               |           |      |
| TASK-109 | Material Design 3 컴포넌트 커스터마이징 (Button, Card, AppBar 등)                 |           |      |
| TASK-110 | 다크 모드 자동 전환 로직 구현 (시스템 설정 따라가기)                                       |           |      |
| TASK-111 | 다크 모드 수동 전환 기능 구현 (설정 화면)                                              |           |      |

### Implementation Phase 16: 유틸리티 및 공통 위젯 구현

- GOAL-016: 앱 전반에서 재사용 가능한 유틸리티 함수 및 공통 위젯을 구현한다.

| Task     | Description                                                                     | Completed | Date |
| -------- | ------------------------------------------------------------------------------- | --------- | ---- |
| TASK-112 | `lib/utils/time_utils.dart` 생성 - 날짜/시간 포맷팅 및 상대 시간 계산 함수                      |           |      |
| TASK-113 | `lib/utils/validation_utils.dart` 생성 - 입력 데이터 검증 함수                           |           |      |
| TASK-114 | `lib/widgets/common/loading_indicator.dart` 생성 - 로딩 인디케이터 위젯                   |           |      |
| TASK-115 | `lib/widgets/common/error_message.dart` 생성 - 에러 메시지 표시 위젯                      |           |      |
| TASK-116 | `lib/widgets/common/empty_state.dart` 생성 - 빈 상태 표시 위젯                          |           |      |
| TASK-117 | `lib/widgets/common/custom_button.dart` 생성 - 커스텀 버튼 위젯                         |           |      |
| TASK-118 | `lib/widgets/common/custom_text_field.dart` 생성 - 커스텀 텍스트 필드 위젯               |           |      |
| TASK-119 | `lib/widgets/common/date_time_picker.dart` 생성 - 날짜/시간 선택 위젯                   |           |      |
| TASK-120 | `lib/widgets/common/confirmation_dialog.dart` 생성 - 확인 다이얼로그 위젯               |           |      |

### Implementation Phase 17: 권한 관리 및 설정 화면 구현

- GOAL-017: 앱 권한을 관리하고 사용자 설정을 변경할 수 있는 화면을 구현한다.

| Task     | Description                                                              | Completed | Date |
| -------- | ------------------------------------------------------------------------ | --------- | ---- |
| TASK-121 | `lib/services/permission_service.dart` 생성 - permission_handler를 사용한 권한 관리 |           |      |
| TASK-122 | `lib/screens/settings/settings_screen.dart` 생성 - 설정 화면                   |           |      |
| TASK-123 | `lib/screens/settings/profile_screen.dart` 생성 - 프로필 설정 화면               |           |      |
| TASK-124 | 앱 시작 시 필수 권한 요청 로직 구현 (알림, 사진 등)                                       |           |      |
| TASK-125 | 테마 모드 전환 설정 구현 (라이트/다크/자동)                                              |           |      |
| TASK-126 | 알림 설정 구현 (향후 확장)                                                         |           |      |
| TASK-127 | 로그아웃 기능 구현                                                               |           |      |
| TASK-128 | 앱 버전 정보 표시                                                               |           |      |

### Implementation Phase 18: 에러 처리 및 로깅

- GOAL-018: 중앙화된 에러 처리 및 로깅 시스템을 구축하여 디버깅과 사용자 경험을 개선한다.

| Task     | Description                                                        | Completed | Date |
| -------- | ------------------------------------------------------------------ | --------- | ---- |
| TASK-129 | ApiException 클래스 확장 - HTTP 상태 코드별 에러 메시지 정의                      |           |      |
| TASK-130 | ErrorHandler 확장 - 사용자 친화적인 에러 메시지 변환                              |           |      |
| TASK-131 | 전역 에러 핸들러 구현 (runZonedGuarded 사용)                                 |           |      |
| TASK-132 | 로깅 서비스 구현 (`lib/services/logging_service.dart`) - 개발/프로덕션 환경 분리 |           |      |
| TASK-133 | 네트워크 오류 시 재시도 로직 구현                                                |           |      |
| TASK-134 | 오프라인 상태 감지 및 사용자에게 알림                                             |           |      |

### Implementation Phase 19: 성능 최적화

- GOAL-019: 앱의 성능을 최적화하여 빠른 로딩 시간과 부드러운 사용자 경험을 제공한다.

| Task     | Description                                                 | Completed | Date |
| -------- | ----------------------------------------------------------- | --------- | ---- |
| TASK-135 | 이미지 캐싱 구현 (cached_network_image 패키지 사용)                     |           |      |
| TASK-136 | API 응답 캐싱 구현 (메모리 캐시, 5분 TTL)                              |           |      |
| TASK-137 | 무한 스크롤 최적화 (ListView.builder 사용)                            |           |      |
| TASK-138 | 불필요한 위젯 리빌드 방지 (const 생성자, Consumer/Selector 사용)            |           |      |
| TASK-139 | 대시보드 API 응답 시간 측정 및 최적화 (목표: 300ms 이하)                     |           |      |
| TASK-140 | 스플래시 화면 구현 (flutter_native_splash 사용)                       |           |      |

### Implementation Phase 20: 국제화 (i18n) 지원

- GOAL-020: 다국어 지원을 위한 국제화 시스템을 구축한다.

| Task     | Description                                                    | Completed | Date |
| -------- | -------------------------------------------------------------- | --------- | ---- |
| TASK-141 | `lib/l10n/app_ko.arb` 생성 - 한국어 번역 파일                          |           |      |
| TASK-142 | `lib/l10n/app_en.arb` 생성 - 영어 번역 파일                           |           |      |
| TASK-143 | `flutter_localizations` 패키지 설정 및 MaterialApp에 적용             |           |      |
| TASK-144 | 모든 사용자 대면 텍스트를 다국어 키로 변환                                     |           |      |
| TASK-145 | 날짜/시간 포맷을 로케일에 맞게 조정 (intl 패키지 사용)                          |           |      |
| TASK-146 | 언어 선택 기능 구현 (설정 화면)                                           |           |      |

### Implementation Phase 21: 테스트 작성

- GOAL-021: 단위 테스트와 위젯 테스트를 작성하여 코드 품질을 보장한다.

| Task     | Description                                                | Completed | Date |
| -------- | ---------------------------------------------------------- | --------- | ---- |
| TASK-147 | `test/models/` 디렉토리 생성 및 모델 단위 테스트 작성                     |           |      |
| TASK-148 | `test/services/` 디렉토리 생성 및 API 서비스 단위 테스트 작성 (Mock 사용)   |           |      |
| TASK-149 | `test/utils/` 디렉토리 생성 및 유틸리티 함수 단위 테스트 작성                |           |      |
| TASK-150 | `test/widget_test/` 디렉토리 생성 및 주요 위젯 테스트 작성               |           |      |
| TASK-151 | 인증 흐름 통합 테스트 작성                                            |           |      |
| TASK-152 | 대시보드 화면 위젯 테스트 작성                                          |           |      |
| TASK-153 | 빠른 기록 추가 기능 통합 테스트 작성                                      |           |      |
| TASK-154 | 테스트 커버리지 80% 이상 달성 확인                                      |           |      |

### Implementation Phase 22: 문서화 및 최종 검토

- GOAL-022: 프로젝트 문서를 작성하고 최종 점검을 수행하여 배포 준비를 완료한다.

| Task     | Description                                            | Completed | Date |
| -------- | ------------------------------------------------------ | --------- | ---- |
| TASK-155 | README.md 업데이트 - 프로젝트 개요, 설치 방법, 실행 방법 작성             |           |      |
| TASK-156 | API_INTEGRATION.md 작성 - Flutter 앱에서 API 사용 방법 문서화    |           |      |
| TASK-157 | CHANGELOG.md 작성 - 버전별 변경 사항 기록                        |           |      |
| TASK-158 | 코드 주석 및 문서화 주석 작성 (Dart Doc 형식)                       |           |      |
| TASK-159 | 모든 화면 스크린샷 촬영 및 문서에 추가                                |           |      |
| TASK-160 | 코드 린트 오류 수정 (flutter analyze)                          |           |      |
| TASK-161 | 불필요한 코드 및 주석 제거                                        |           |      |
| TASK-162 | 최종 기능 테스트 및 버그 수정                                      |           |      |

### Implementation Phase 23: 빌드 및 배포 준비

- GOAL-023: Android 및 iOS 앱을 빌드하고 배포 준비를 완료한다.

| Task     | Description                                                      | Completed | Date |
| -------- | ---------------------------------------------------------------- | --------- | ---- |
| TASK-163 | Android 빌드 설정 (build.gradle, AndroidManifest.xml)              |           |      |
| TASK-164 | iOS 빌드 설정 (Info.plist, Podfile)                                |           |      |
| TASK-165 | 앱 아이콘 생성 및 설정 (Android/iOS)                                     |           |      |
| TASK-166 | 스플래시 화면 이미지 생성 및 설정                                            |           |      |
| TASK-167 | ProGuard 설정 (Android 코드 난독화)                                   |           |      |
| TASK-168 | 앱 번들 및 APK 빌드 (Android)                                         |           |      |
| TASK-169 | IPA 빌드 (iOS)                                                     |           |      |
| TASK-170 | Google Play Console 및 App Store Connect 설정                      |           |      |
| TASK-171 | 앱 스토어 메타데이터 작성 (설명, 스크린샷, 키워드)                                 |           |      |
| TASK-172 | 베타 테스트 배포 (TestFlight, Firebase App Distribution)              |           |      |

## 3. Alternatives

대안 접근 방식 및 기술 선택에 대한 고려 사항:

- **ALT-001**: 상태 관리 - Provider 대신 Riverpod 또는 Bloc 패턴 사용
  - **선택하지 않은 이유**: Provider는 프로젝트 가이드라인에 명시되어 있고, 팀의 숙련도가 높으며, MVP에 충분한 기능을 제공함
  
- **ALT-002**: HTTP 클라이언트 - Dio 대신 http 패키지 사용
  - **선택하지 않은 이유**: Dio는 인터셉터, 타임아웃, 에러 처리 등 더 많은 기능을 제공하며 대규모 앱에 적합함
  
- **ALT-003**: 라우팅 - GoRouter 대신 Navigator 2.0 직접 사용
  - **선택하지 않은 이유**: GoRouter는 프로젝트 가이드라인에 명시되어 있고, 선언적 라우팅을 간단하게 구현할 수 있음
  
- **ALT-004**: JSON 직렬화 - json_serializable 대신 Freezed 패키지 사용
  - **선택하지 않은 이유**: Freezed는 더 많은 기능을 제공하지만 MVP에는 json_serializable로 충분하며, 학습 곡선이 낮음
  
- **ALT-005**: 대시보드 API - 단일 API 호출 대신 여러 API를 병렬로 호출
  - **선택하지 않은 이유**: PRD에 명시된 대로 통합 대시보드 API가 이미 제공되며, 성능 목표(300ms 이하)를 만족함

## 4. Dependencies

프로젝트 구현에 필요한 외부 의존성:

- **DEP-001**: Flutter SDK (최신 안정 버전) - 크로스 플랫폼 모바일 앱 개발 프레임워크
- **DEP-002**: Firebase Authentication - 사용자 인증 및 토큰 관리
- **DEP-003**: 백엔드 API 서버 - FastAPI 기반, `/api/v1/baby-care-ai` 경로로 제공
- **DEP-004**: Dio 패키지 - HTTP 통신 및 인터셉터
- **DEP-005**: Provider 패키지 - 상태 관리
- **DEP-006**: GoRouter 패키지 - 선언적 라우팅
- **DEP-007**: json_serializable & build_runner - JSON 직렬화 코드 생성
- **DEP-008**: flutter_secure_storage - 토큰 안전한 저장
- **DEP-009**: intl 패키지 - 국제화 및 날짜/시간 포맷팅
- **DEP-010**: google_fonts 패키지 - Google Fonts 사용
- **DEP-011**: cached_network_image - 이미지 캐싱
- **DEP-012**: permission_handler - 앱 권한 관리
- **DEP-013**: flutter_markdown - 마크다운 렌더링 (GPT 응답)
- **DEP-014**: flutter_native_splash - 스플래시 화면

## 5. Files

구현 과정에서 생성 및 수정될 주요 파일 목록:

### 설정 파일
- **FILE-001**: `pubspec.yaml` - 패키지 의존성 및 프로젝트 설정
- **FILE-002**: `.env` - 환경 변수 (API Base URL, Firebase Config 등)
- **FILE-003**: `analysis_options.yaml` - Dart 코드 분석 설정

### 설정 및 유틸리티
- **FILE-004**: `lib/config/api_config.dart` - API 설정
- **FILE-005**: `lib/utils/constants.dart` - 앱 전역 상수
- **FILE-006**: `lib/utils/time_utils.dart` - 날짜/시간 유틸리티
- **FILE-007**: `lib/utils/validation_utils.dart` - 입력 검증 유틸리티
- **FILE-008**: `lib/utils/error_handler.dart` - 에러 처리 유틸리티

### 인증 및 API
- **FILE-009**: `lib/services/auth_service.dart` - Firebase Auth 서비스
- **FILE-010**: `lib/clients/api_client.dart` - Dio HTTP 클라이언트
- **FILE-011**: `lib/services/baby_api_service.dart` - Baby API 서비스
- **FILE-012**: `lib/services/feeding_api_service.dart` - Feeding API 서비스
- **FILE-013**: `lib/services/care_api_service.dart` - Care API 서비스
- **FILE-014**: `lib/services/gpt_api_service.dart` - GPT API 서비스
- **FILE-015**: `lib/services/dashboard_api_service.dart` - Dashboard API 서비스

### 데이터 모델
- **FILE-016**: `lib/models/baby.dart` - Baby 모델
- **FILE-017**: `lib/models/feeding_record.dart` - FeedingRecord 모델
- **FILE-018**: `lib/models/care_record.dart` - CareRecord 모델
- **FILE-019**: `lib/models/gpt_conversation.dart` - GPTConversation 모델
- **FILE-020**: `lib/models/dashboard.dart` - Dashboard 모델

### 상태 관리
- **FILE-021**: `lib/states/auth_state.dart` - 인증 상태
- **FILE-022**: `lib/states/baby_state.dart` - Baby 상태
- **FILE-023**: `lib/states/dashboard_state.dart` - Dashboard 상태
- **FILE-024**: `lib/states/feeding_state.dart` - Feeding 상태
- **FILE-025**: `lib/states/care_state.dart` - Care 상태
- **FILE-026**: `lib/states/gpt_state.dart` - GPT 상태
- **FILE-027**: `lib/states/timer_state.dart` - Timer 상태

### 라우팅
- **FILE-028**: `lib/router.dart` - GoRouter 설정

### 화면 (Screens)
- **FILE-029**: `lib/screens/auth/login_screen.dart` - 로그인 화면
- **FILE-030**: `lib/screens/auth/signup_screen.dart` - 회원가입 화면
- **FILE-031**: `lib/screens/dashboard/dashboard_screen.dart` - 대시보드 화면
- **FILE-032**: `lib/screens/baby/baby_list_screen.dart` - 아이 목록 화면
- **FILE-033**: `lib/screens/baby/add_baby_screen.dart` - 아이 추가 화면
- **FILE-034**: `lib/screens/feeding/feeding_list_screen.dart` - 수유 기록 목록 화면
- **FILE-035**: `lib/screens/feeding/feeding_timer_screen.dart` - 수유 타이머 화면
- **FILE-036**: `lib/screens/care/care_list_screen.dart` - 육아 기록 목록 화면
- **FILE-037**: `lib/screens/gpt/gpt_question_screen.dart` - GPT 질문 화면
- **FILE-038**: `lib/screens/settings/settings_screen.dart` - 설정 화면

### 위젯 (Widgets)
- **FILE-039**: `lib/widgets/dashboard/baby_info_card.dart` - 아이 정보 카드
- **FILE-040**: `lib/widgets/dashboard/last_records_section.dart` - 최근 기록 섹션
- **FILE-041**: `lib/widgets/dashboard/active_feeding_timer.dart` - 진행 중인 수유 타이머
- **FILE-042**: `lib/widgets/dashboard/daily_summary_card.dart` - 일별 통계 카드
- **FILE-043**: `lib/widgets/quick_add/quick_add_modal.dart` - 빠른 기록 추가 모달
- **FILE-044**: `lib/widgets/feeding/feeding_record_card.dart` - 수유 기록 카드
- **FILE-045**: `lib/widgets/care/care_record_card.dart` - 육아 기록 카드
- **FILE-046**: `lib/widgets/common/loading_indicator.dart` - 로딩 인디케이터

### 테마
- **FILE-047**: `lib/theme/app_theme.dart` - 앱 테마
- **FILE-048**: `lib/theme/app_colors.dart` - 색상 팔레트
- **FILE-049**: `lib/theme/app_text_styles.dart` - 타이포그래피

### 국제화
- **FILE-050**: `lib/l10n/app_ko.arb` - 한국어 번역
- **FILE-051**: `lib/l10n/app_en.arb` - 영어 번역

### 메인
- **FILE-052**: `lib/main.dart` - 앱 엔트리 포인트

## 6. Testing

테스트 전략 및 구현할 테스트 목록:

### 단위 테스트 (Unit Tests)
- **TEST-001**: `test/models/baby_test.dart` - Baby 모델 직렬화/역직렬화 테스트
- **TEST-002**: `test/models/feeding_record_test.dart` - FeedingRecord 모델 테스트
- **TEST-003**: `test/models/care_record_test.dart` - CareRecord 모델 테스트
- **TEST-004**: `test/services/baby_api_service_test.dart` - Baby API 서비스 Mock 테스트
- **TEST-005**: `test/services/feeding_api_service_test.dart` - Feeding API 서비스 Mock 테스트
- **TEST-006**: `test/utils/time_utils_test.dart` - 시간 유틸리티 함수 테스트
- **TEST-007**: `test/utils/validation_utils_test.dart` - 입력 검증 함수 테스트

### 위젯 테스트 (Widget Tests)
- **TEST-008**: `test/widget_test/dashboard_screen_test.dart` - 대시보드 화면 렌더링 테스트
- **TEST-009**: `test/widget_test/baby_info_card_test.dart` - 아이 정보 카드 위젯 테스트
- **TEST-010**: `test/widget_test/quick_add_modal_test.dart` - 빠른 기록 추가 모달 테스트
- **TEST-011**: `test/widget_test/feeding_timer_test.dart` - 수유 타이머 위젯 테스트
- **TEST-012**: `test/widget_test/loading_indicator_test.dart` - 로딩 인디케이터 위젯 테스트

### 통합 테스트 (Integration Tests)
- **TEST-013**: `integration_test/auth_flow_test.dart` - 로그인/로그아웃 흐름 테스트
- **TEST-014**: `integration_test/dashboard_flow_test.dart` - 대시보드 조회 및 빠른 기록 추가 흐름 테스트
- **TEST-015**: `integration_test/feeding_timer_flow_test.dart` - 수유 타이머 시작/전환/완료 흐름 테스트
- **TEST-016**: `integration_test/gpt_question_flow_test.dart` - GPT 질문 및 응답 조회 흐름 테스트

### 성능 테스트
- **TEST-017**: 대시보드 API 응답 시간 측정 (목표: 300ms 이하)
- **TEST-018**: 일반 API 응답 시간 측정 (목표: 200ms 이하)
- **TEST-019**: 무한 스크롤 성능 측정 (목록 화면)
- **TEST-020**: 앱 시작 시간 측정 (목표: 3초 이내)

## 7. Risks & Assumptions

### 위험 요소 (Risks)
- **RISK-001**: Firebase Authentication 설정 오류로 인한 인증 실패
  - **완화 방안**: Firebase 콘솔에서 설정 확인 및 문서 참고, 테스트 계정으로 사전 검증
  
- **RISK-002**: 백엔드 API 응답 시간 초과 (특히 대시보드 API)
  - **완화 방안**: API 성능 모니터링, 필요 시 캐싱 전략 강화, 로딩 인디케이터로 사용자 경험 개선
  
- **RISK-003**: JSON 직렬화 코드 생성 오류
  - **완화 방안**: build_runner 실행 전 모델 정의 검증, 에러 로그 확인 및 수정
  
- **RISK-004**: 상태 관리 복잡도 증가로 인한 버그 발생
  - **완화 방안**: Provider 패턴 베스트 프랙티스 준수, 명확한 상태 분리, 단위 테스트 작성
  
- **RISK-005**: 다국어 지원 시 번역 누락
  - **완화 방안**: ARB 파일 자동 검증 스크립트 작성, 모든 텍스트를 다국어 키로 변환
  
- **RISK-006**: Android/iOS 빌드 오류
  - **완화 방안**: 플랫폼별 설정 가이드 참고, 빌드 오류 로그 분석, 커뮤니티 지원 활용

### 가정 사항 (Assumptions)
- **ASSUMPTION-001**: 백엔드 API가 정상적으로 동작하고 있으며, PRD에 명시된 엔드포인트를 모두 제공함
- **ASSUMPTION-002**: Firebase Authentication 프로젝트가 사전에 설정되어 있음
- **ASSUMPTION-003**: 사용자는 안정적인 인터넷 연결 환경에서 앱을 사용함
- **ASSUMPTION-004**: 사용자는 최신 버전의 Android (API 21+) 또는 iOS (13.0+) 기기를 사용함
- **ASSUMPTION-005**: 백엔드 API는 Row Level Security (RLS)를 통해 데이터 접근을 제어함
- **ASSUMPTION-006**: GPT API 응답 시간은 평균 3-5초 이내임
- **ASSUMPTION-007**: 페이지네이션은 offset 기반으로 동작하며, 최대 100개까지 조회 가능함

## 8. Related Specifications / Further Reading

### 프로젝트 문서
- [PRD: 육아·수유 기록 앱 MVP](.cursor/prd/20260206-baby-care-mvp-prd.md)
- [API Reference](docs/api-reference.md)
- [Flutter Integration Guide](docs/flutter-integration-guide.md)
- [Project Guidelines](.cursor/rules/project-guidedline.mdc)

### 외부 문서
- [Flutter 공식 문서](https://flutter.dev/docs)
- [Provider 패키지](https://pub.dev/packages/provider)
- [GoRouter 패키지](https://pub.dev/packages/go_router)
- [Dio 패키지](https://pub.dev/packages/dio)
- [Firebase Authentication Flutter](https://firebase.google.com/docs/auth/flutter/start)
- [Material Design 3](https://m3.material.io/)
- [Flutter 국제화](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

### 참고 자료
- [Clean Architecture in Flutter](https://medium.com/ruangguru/an-introduction-to-flutter-clean-architecture-ae00154001b0)
- [Flutter 상태 관리 가이드](https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro)
- [Flutter 성능 최적화](https://flutter.dev/docs/perf/rendering-performance)

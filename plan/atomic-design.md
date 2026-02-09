# Baby Care MVP Atomic Design System

이 문서는 Baby Care MVP 앱의 UI/UX를 위한 아토믹 디자인 시스템(Atomic Design System) 정의서입니다.
PRD와 API 명세를 기반으로 작성되었으며, 실제 구현에 필요한 모든 디자인 스펙을 포함합니다.

---

## 목차
1. [Design Tokens](#1-design-tokens-style-guide)
2. [Foundation](#2-foundation)
3. [Atoms](#3-atoms-원자)
4. [Molecules](#4-molecules-분자)
5. [Organisms](#5-organisms-유기체)
6. [Templates](#6-templates-템플릿)
7. [Pages](#7-pages-페이지)
8. [Implementation Guidelines](#8-implementation-guidelines)

---

## 1. Design Tokens (Style Guide)

### 1.1 Color System

#### Primary Palette
```
Primary (Soft Blue)
├─ Primary-50:  #E3F2FD  (배경, 호버 상태)
├─ Primary-100: #BBDEFB  (비활성 상태)
├─ Primary-500: #4A90E2  (기본 Primary Color) ★
├─ Primary-700: #3478C8  (눌림 상태)
└─ Primary-900: #1E5FA0  (강조)
```

#### Secondary Palette
```
Secondary (Soft Pink/Red)
├─ Secondary-50:  #FFEBEE
├─ Secondary-100: #FFCDD2
├─ Secondary-500: #FF8A80  ★
├─ Secondary-700: #E64A45
└─ Secondary-900: #C62828
```

#### Accent Palette
```
Accent (Soft Orange)
├─ Accent-50:  #FFF3E0
├─ Accent-100: #FFE0B2
├─ Accent-500: #F5A623  ★
├─ Accent-700: #E6941B
└─ Accent-900: #D17D00
```

#### Semantic Colors
```
Success (Green)
├─ Success-50:  #E8F5E9
├─ Success-100: #C8E6C9
├─ Success-500: #66BB6A  ★
├─ Success-700: #4CAF50
└─ Success-900: #2E7D32

Warning (Orange)
├─ Warning-50:  #FFF8E1
├─ Warning-500: #FFA726  ★
└─ Warning-900: #EF6C00

Error (Red)
├─ Error-50:  #FFEBEE
├─ Error-500: #EF5350  ★
└─ Error-900: #C62828

Info (Light Blue)
├─ Info-50:  #E1F5FE
├─ Info-500: #29B6F6  ★
└─ Info-900: #01579B
```

#### Neutral Palette
```
Background
├─ Background-Primary:   #F9F9F9  (메인 배경)
├─ Background-Secondary: #EEEEEE  (섹션 구분)
└─ Background-Tertiary:  #E0E0E0  (비활성 영역)

Surface
├─ Surface-Primary:   #FFFFFF  (카드, 모달)
├─ Surface-Secondary: #FAFAFA  (하위 카드)
└─ Surface-Tertiary:  #F5F5F5  (입력 필드 배경)

Text
├─ Text-Primary:   #212121  (주요 텍스트)
├─ Text-Secondary: #757575  (보조 텍스트)
├─ Text-Tertiary:  #9E9E9E  (비활성 텍스트)
└─ Text-Disabled:  #BDBDBD  (비활성화된 요소)

Border
├─ Border-Default: #E0E0E0  (기본 테두리)
├─ Border-Light:   #F0F0F0  (미묘한 구분선)
└─ Border-Strong:  #BDBDBD  (강조 테두리)
```

#### Usage Guidelines
- **Primary**: 주요 액션 버튼, 활성 상태, 중요 정보 강조
- **Secondary**: 경고성 액션, 타이머 표시, 사랑스러운 요소
- **Accent**: 주의가 필요한 정보, 중간 단계 강조
- **Semantic**: 피드백 메시지, 상태 뱃지
- **Do**: Primary 버튼은 화면당 1-2개만 사용
- **Don't**: 같은 화면에 너무 많은 색상 혼용 금지

---

### 1.2 Typography System

#### Font Families
```
Primary:   'Pretendard' (Korean), 'SF Pro Display' (iOS), 'Roboto' (Android)
Secondary: 'Pretendard' (Korean), 'SF Pro Text' (iOS), 'Roboto' (Android)
Monospace: 'SF Mono' (iOS), 'Roboto Mono' (Android)
```

#### Type Scale
| Token | Size | Weight | Line Height | Letter Spacing | Usage |
|-------|------|--------|-------------|----------------|-------|
| `display-large` | 32sp | 700 (Bold) | 40sp (1.25) | -0.5% | 온보딩 타이틀 |
| `display-medium` | 28sp | 700 (Bold) | 36sp (1.29) | -0.5% | 섹션 대제목 |
| `headline` | 24sp | 600 (SemiBold) | 32sp (1.33) | -0.25% | 페이지 타이틀 |
| `title` | 20sp | 600 (SemiBold) | 28sp (1.40) | 0% | 카드 제목 |
| `body-large` | 16sp | 400 (Regular) | 24sp (1.50) | 0.5% | 주요 본문 |
| `body-medium` | 14sp | 400 (Regular) | 20sp (1.43) | 0.25% | 보조 본문 |
| `caption-large` | 13sp | 500 (Medium) | 18sp (1.38) | 0.4% | 레이블, 메타 정보 |
| `caption` | 12sp | 400 (Regular) | 16sp (1.33) | 0.4% | 힌트, 작은 정보 |
| `overline` | 11sp | 500 (Medium) | 16sp (1.45) | 1.5% | 섹션 라벨(대문자) |

#### Font Weights
```
Light:     300
Regular:   400  (기본)
Medium:    500  (강조)
SemiBold:  600  (제목)
Bold:      700  (헤드라인)
ExtraBold: 800  (특별 강조 - 제한적 사용)
```

#### Usage Guidelines
- **Headline**: 화면당 1개, 주요 화면 타이틀
- **Title**: 카드/섹션 제목
- **Body-Large**: 중요한 내용, 폼 입력값
- **Body-Medium**: 일반 본문, 설명
- **Caption**: 메타 정보, 타임스탬프, 보조 설명
- **Do**: 계층 구조 명확히 (제목 → 본문 → 캡션)
- **Don't**: 한 화면에 3개 이상의 폰트 크기 혼용 지양

---

### 1.3 Spacing System

#### Base Unit
```
기본 단위: 4dp (1 space unit)
```

#### Spacing Scale
| Token | Value | Usage |
|-------|-------|-------|
| `space-0` | 0dp | 붙어있는 요소 |
| `space-1` | 4dp | 매우 가까운 관계 (아이콘↔텍스트) |
| `space-2` | 8dp | 가까운 관계 (리스트 아이템 내부) |
| `space-3` | 12dp | 관련 그룹 (버튼 그룹) |
| `space-4` | 16dp | 기본 간격 (카드 패딩, 리스트 아이템 간격) |
| `space-5` | 20dp | 중간 간격 |
| `space-6` | 24dp | 섹션 간격 (화면 주요 섹션 구분) |
| `space-8` | 32dp | 큰 섹션 간격 (화면 패딩) |
| `space-10` | 40dp | 매우 큰 간격 |
| `space-12` | 48dp | 특별 간격 |
| `space-16` | 64dp | 최대 간격 |

#### Padding Guidelines
```
Screen Horizontal Padding:  16dp (모바일 기본)
Screen Vertical Padding:    24dp
Card Padding:               16dp
Button Padding:             12dp(V) × 24dp(H)
Icon Button Padding:        8dp
Input Field Padding:        12dp(V) × 16dp(H)
List Item Padding:          12dp(V) × 16dp(H)
Modal Padding:              24dp
```

#### Gap/Margin Guidelines
```
Inline Elements Gap:        4-8dp   (아이콘 + 텍스트)
Form Field Gap:             16dp    (라벨 ↔ 입력 필드)
List Item Gap:              8-12dp
Section Gap:                24dp    (화면 내 섹션 구분)
Card Grid Gap:              12-16dp
Button Group Gap:           12dp
```

---

### 1.4 Border Radius System

| Token | Value | Usage |
|-------|-------|-------|
| `radius-none` | 0dp | 테이블, 엄격한 UI |
| `radius-xs` | 2dp | 작은 뱃지 내부 |
| `radius-sm` | 4dp | 작은 뱃지, 칩 |
| `radius-md` | 8dp | 버튼, 입력 필드 |
| `radius-lg` | 12dp | 작은 카드 |
| `radius-xl` | 16dp | 카드, 모달 |
| `radius-2xl` | 20dp | 큰 카드, 시트 |
| `radius-3xl` | 24dp | 바텀 시트 상단 |
| `radius-round` | 9999dp | 원형 (아바타, FAB) |
| `radius-pill` | 높이의 50% | 알약 형태 (태그, 상태 뱃지) |

#### Usage by Component
```
Avatar:          radius-round
Button:          radius-md (8dp)
Input Field:     radius-md (8dp)
Card:            radius-xl (16dp)
Status Badge:    radius-pill
Icon Button:     radius-md (8dp)
Modal:           radius-xl (16dp)
Bottom Sheet:    radius-3xl (top only, 24dp)
FAB:             radius-round
Chip/Tag:        radius-sm (4dp) or radius-pill
```

---

### 1.5 Elevation & Shadow System

#### Shadow Levels
```
Level 0 (Flat)
├─ Elevation: 0dp
└─ Shadow: none
└─ Usage: 기본 화면 배경, 입력 필드

Level 1 (Subtle)
├─ Elevation: 2dp
├─ Shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.08)
└─ Usage: 카드, 리스트 아이템

Level 2 (Raised)
├─ Elevation: 4dp
├─ Shadow: 0 3px 6px rgba(0,0,0,0.12), 0 2px 4px rgba(0,0,0,0.08)
└─ Usage: 활성 카드, 드롭다운

Level 3 (Floating)
├─ Elevation: 8dp
├─ Shadow: 0 10px 20px rgba(0,0,0,0.12), 0 3px 6px rgba(0,0,0,0.08)
└─ Usage: FAB, 모달, 툴팁

Level 4 (Modal)
├─ Elevation: 16dp
├─ Shadow: 0 15px 30px rgba(0,0,0,0.15), 0 5px 10px rgba(0,0,0,0.10)
└─ Usage: 다이얼로그, 바텀 시트

Level 5 (Overlay)
├─ Elevation: 24dp
├─ Shadow: 0 20px 40px rgba(0,0,0,0.18), 0 8px 16px rgba(0,0,0,0.12)
└─ Usage: 최상위 오버레이
```

---

### 1.6 Icon System

#### Icon Sizes
| Token | Size | Usage |
|-------|------|-------|
| `icon-xs` | 12dp | 인라인 아이콘 (텍스트 옆) |
| `icon-sm` | 16dp | 작은 버튼, 칩 |
| `icon-md` | 24dp | 기본 아이콘 (버튼, 네비게이션) |
| `icon-lg` | 32dp | 큰 아이콘 (상태 카드) |
| `icon-xl` | 48dp | 히어로 아이콘 (빈 상태) |
| `icon-2xl` | 64dp | 특별 상황 (온보딩) |

#### Icon Families
- **Material Symbols Rounded**: 기본 아이콘 세트
- **Lucide**: 대체 아이콘 세트
- **Custom**: 특정 도메인 아이콘 (젖병, 기저귀 등)

#### Icon Usage by Context
```
Navigation:          icon-md (24dp)
Button Primary:      icon-md (24dp)
Button Small:        icon-sm (16dp)
List Item:           icon-md (24dp)
Status Card:         icon-lg (32dp)
Input Trailing:      icon-sm (16dp)
Badge:               icon-xs (12dp)
AppBar Action:       icon-md (24dp)
FAB:                 icon-md (24dp)
Empty State:         icon-xl (48dp)
```

---

### 1.7 Grid & Layout System

#### Mobile Grid (375dp base)
```
Columns:        4 (유연한 레이아웃)
Gutter:         16dp
Margin:         16dp (좌우)
Max Width:      600dp (태블릿 이상)
```

#### Breakpoints
```
Mobile Small:   < 360dp
Mobile:         360dp - 599dp
Tablet:         600dp - 839dp
Tablet Large:   840dp - 1279dp
Desktop:        > 1280dp
```

#### Safe Areas
```
Top Safe Area:       Status Bar 영역 (44dp on iOS, varies on Android)
Bottom Safe Area:    Home Indicator 영역 (34dp on iOS)
Screen Edge Margin:  16dp (좌우 최소 여백)
```

---

### 1.8 Animation & Transitions

#### Duration
```
Instant:    100ms   (매우 빠른 피드백)
Quick:      200ms   (버튼 눌림, 체크박스)
Normal:     300ms   (기본 전환, 페이드)
Slow:       400ms   (모달 열림/닫힘)
Slower:     500ms   (드로어, 바텀 시트)
```

#### Easing Curves
```
Standard:       cubic-bezier(0.4, 0.0, 0.2, 1)  (기본)
Decelerate:     cubic-bezier(0.0, 0.0, 0.2, 1)  (등장)
Accelerate:     cubic-bezier(0.4, 0.0, 1, 1)    (사라짐)
Sharp:          cubic-bezier(0.4, 0.0, 0.6, 1)  (탭 전환)
```

#### Motion Patterns
- **Fade**: 모달, 오버레이 (300ms)
- **Slide**: 페이지 전환, 드로어 (300ms)
- **Scale**: FAB, 툴팁 (200ms)
- **Expand/Collapse**: 아코디언, 드롭다운 (300ms)

---

### 1.9 Z-Index System

```
Z-Index Scale:
├─ z-0:    0       기본 레이어
├─ z-10:   10      카드, 리스트 아이템
├─ z-20:   20      스티키 헤더, 툴팁
├─ z-30:   30      드롭다운, 팝오버
├─ z-40:   40      모달 배경
├─ z-50:   50      모달 컨텐츠
└─ z-100:  100     토스트, 스낵바
```

---

## 2. Foundation

### 2.1 Accessibility

#### Touch Targets
- **최소 크기**: 44dp × 44dp (Apple HIG)
- **권장 크기**: 48dp × 48dp (Material Design)
- **간격**: 최소 8dp 이상

#### Contrast Ratios
- **일반 텍스트**: 4.5:1 (WCAG AA)
- **큰 텍스트** (18sp 이상): 3:1 (WCAG AA)
- **아이콘**: 3:1

#### Focus Indicators
- **Focus Ring**: 2dp, Primary-700
- **Padding**: 2dp outside element

---

### 2.2 Responsive Behavior

#### Scaling Strategy
```
< 360dp:  축소된 간격, 작은 폰트
360-599dp: 기본 모바일 레이아웃
600-839dp: 2-column 그리드, 큰 카드
> 840dp:   3-column, 사이드바 표시
```

---

## 3. Atoms (원자)
*가장 기본적인 UI 빌딩 블록*

### 3.1 Buttons

#### 3.1.1 PrimaryButton
**용도**: 주요 액션 (저장, 시작, 완료)

**스펙**:
```
Height:          48dp
Padding:         12dp(V) × 24dp(H)
Border Radius:   radius-md (8dp)
Font:            body-large (16sp, SemiBold)
Min Width:       64dp
```

**상태**:
- **Default**: Background `$primary`, Text `#FFFFFF`
- **Hover**: Background `$primary-700`, Elevation `level-1`
- **Pressed**: Background `$primary-900`, Elevation `level-0`
- **Disabled**: Background `$text-disabled`, Text `#FFFFFF`, Opacity `0.6`
- **Loading**: Spinner + Disabled 스타일

**변형**:
- `PrimaryButton.Large`: Height 56dp, Padding 16dp × 32dp
- `PrimaryButton.Small`: Height 36dp, Padding 8dp × 16dp, Font 14sp

#### 3.1.2 SecondaryButton
**용도**: 보조 액션 (취소, 이전, 닫기)

**스펙**:
```
Height:          48dp
Padding:         12dp(V) × 24dp(H)
Border Radius:   radius-md (8dp)
Border:          1dp, $primary
Font:            body-large (16sp, Medium)
Background:      Transparent or $primary-50
```

**상태**:
- **Default**: Border `$primary`, Text `$primary`
- **Hover**: Background `$primary-50`
- **Pressed**: Background `$primary-100`
- **Disabled**: Border `$border-default`, Text `$text-disabled`

#### 3.1.3 IconButton
**용도**: 아이콘 단독 액션 (닫기, 메뉴, 더보기)

**스펙**:
```
Size:            40dp × 40dp
Icon Size:       24dp (icon-md)
Border Radius:   radius-md (8dp)
Background:      Transparent
```

**상태**:
- **Default**: Icon `$text-primary`, Background `transparent`
- **Hover**: Background `$background-secondary`
- **Pressed**: Background `$background-tertiary`
- **Disabled**: Icon `$text-disabled`

**변형**:
- `IconButton.Small`: 32dp × 32dp, Icon 16dp
- `IconButton.Large`: 48dp × 48dp, Icon 32dp

#### 3.1.4 FloatingActionButton (FAB)
**용도**: 주요 생성 액션 (기록 추가)

**스펙**:
```
Size:            56dp × 56dp
Icon Size:       24dp (icon-md)
Border Radius:   radius-round
Elevation:       level-3
Background:      $primary
```

**상태**:
- **Default**: Elevation `level-3`
- **Hover**: Elevation `level-4`
- **Pressed**: Elevation `level-2`, Scale `0.95`

**변형**:
- `FAB.Mini`: 40dp × 40dp
- `FAB.Extended`: Fit width, Padding 16dp(H), Text included

---

### 3.2 Input Fields

#### 3.2.1 TextField
**용도**: 일반 텍스트 입력

**스펙**:
```
Height:          48dp (single line) / auto (multiline)
Padding:         12dp(V) × 16dp(H)
Border Radius:   radius-md (8dp)
Border:          1dp, $border-default
Font:            body-large (16sp)
```

**상태**:
- **Default**: Border `$border-default`, Background `$surface-tertiary`
- **Focused**: Border `$primary` (2dp), Background `$surface-primary`
- **Error**: Border `$error` (2dp), Helper text red
- **Disabled**: Background `$background-tertiary`, Text `$text-disabled`

**구성 요소**:
- Label (caption-large, 13sp)
- Input Field
- Helper Text / Error Text (caption, 12sp)
- Leading Icon (optional, icon-sm)
- Trailing Icon (optional, icon-sm)

#### 3.2.2 NumberField
**용도**: 숫자 입력 (수유량, 시간)

**스펙**: TextField와 동일

**추가 기능**:
- Keyboard Type: Numeric
- Unit Suffix: "ml", "분", "°C" 등
- +/- Stepper (optional)

#### 3.2.3 DropdownField
**용도**: 옵션 선택 (수유 타입, 기저귀 상태)

**스펙**:
```
Height:          48dp
Padding:         12dp(V) × 16dp(H)
Border Radius:   radius-md (8dp)
Trailing Icon:   expand_more (icon-sm)
```

**드롭다운 메뉴**:
```
Max Height:      280dp (6.5 items visible)
Border Radius:   radius-lg (12dp)
Elevation:       level-3
Item Height:     48dp
Item Padding:    12dp(V) × 16dp(H)
```

#### 3.2.4 DateTimePicker
**용도**: 날짜/시간 선택

**스펙**: TextField와 동일
**Trailing Icon**: calendar_today (icon-sm)
**Picker 스타일**: Material Design Date/Time Picker

---

### 3.3 Display Elements

#### 3.3.1 AppText
**용도**: 모든 텍스트 표시 (스타일 적용된 Text 컴포넌트)

**변형**:
- `AppText.displayLarge`: 32sp, Bold
- `AppText.headline`: 24sp, SemiBold
- `AppText.title`: 20sp, SemiBold
- `AppText.bodyLarge`: 16sp, Regular
- `AppText.bodyMedium`: 14sp, Regular
- `AppText.caption`: 12sp, Regular

#### 3.3.2 AppIcon
**용도**: 벡터 아이콘 표시

**아이콘 세트**:
- Material Symbols Rounded (기본)
- Custom Icons (baby bottle, diaper, etc.)

**크기 변형**: icon-xs ~ icon-2xl

#### 3.3.3 Avatar
**용도**: 아기 프로필 사진

**스펙**:
```
Size:            48dp × 48dp (default)
Border Radius:   radius-round
Border:          2dp, $border-light (optional)
Background:      $background-secondary (placeholder)
```

**변형**:
- `Avatar.Small`: 32dp × 32dp
- `Avatar.Large`: 64dp × 64dp
- `Avatar.XLarge`: 96dp × 96dp

**Placeholder**: Baby icon 또는 이니셜

#### 3.3.4 StatusBadge
**용도**: 상태 표시 칩 ("수유중", "4분전", "대변")

**스펙**:
```
Height:          24dp (fit-content)
Padding:         4dp(V) × 8dp(H)
Border Radius:   radius-pill
Font:            caption (12sp, Medium)
```

**타입별 스타일**:
```
Success:  Background $success-50,  Text $success-900
Warning:  Background $warning-50,  Text $warning-900
Error:    Background $error-50,    Text $error-900
Info:     Background $info-50,     Text $info-900
Primary:  Background $primary-50,  Text $primary-900
Neutral:  Background $background-secondary, Text $text-primary
```

#### 3.3.5 Divider
**용도**: 구분선

**스펙**:
```
Horizontal:
├─ Height: 1dp
└─ Color:  $border-light

Vertical:
├─ Width:  1dp
└─ Color:  $border-light

With Inset:
└─ Margin: 16dp (start)
```

#### 3.3.6 Chip
**용도**: 선택 가능한 태그, 필터

**스펙**:
```
Height:          32dp
Padding:         6dp(V) × 12dp(H)
Border Radius:   radius-md (8dp)
Font:            caption-large (13sp, Medium)
Gap:             4dp (icon ↔ text)
```

**상태**:
- **Default**: Background `$surface-tertiary`, Border `$border-default`
- **Selected**: Background `$primary-50`, Border `$primary`, Text `$primary-900`
- **Disabled**: Opacity `0.5`

---

### 3.4 Feedback Elements

#### 3.4.1 ProgressBar
**용도**: 진행 상태 표시

**스펙**:
```
Linear:
├─ Height:     4dp
├─ Background: $background-secondary
├─ Foreground: $primary
└─ Radius:     radius-sm (4dp)

Circular:
├─ Size:       24dp / 48dp
├─ Thickness:  3dp / 4dp
└─ Color:      $primary
```

#### 3.4.2 Spinner (Loading Indicator)
**용도**: 로딩 상태

**스펙**:
```
Size:     24dp (default), 16dp (small), 48dp (large)
Color:    $primary (colored) or $text-secondary (neutral)
```

#### 3.4.3 Skeleton Loader
**용도**: 콘텐츠 로딩 플레이스홀더

**스펙**:
```
Background:     $background-secondary
Animation:      Shimmer (1.5s infinite)
Border Radius:  radius-md (8dp)
```

---

## 4. Molecules (분자)
*Atoms를 조합하여 기능적인 단위 구성*

### 4.1 Form Elements

#### 4.1.1 LabeledInput
**구성**: Label (AppText.caption-large) + TextField

**스펙**:
```
Layout:          Vertical
Gap:             4dp
Label Color:     $text-secondary
Required Mark:   Red asterisk (*)
```

**변형**:
- `LabeledInput.Required`: 라벨에 * 표시
- `LabeledInput.Optional`: 라벨에 (선택) 표시
- `LabeledInput.WithHelper`: 하단 헬퍼 텍스트 포함

#### 4.1.2 UnitInputField
**구성**: NumberField + Unit Label

**스펙**:
```
Layout:          Horizontal (Input Field + Unit Text)
Unit Position:   Trailing (inside or outside)
Unit Font:       body-medium (14sp, Medium)
Unit Color:      $text-secondary
Gap (outside):   8dp
```

**예시**:
```
[ 120 ] ml
[ 15 ] 분
[ 36.5 ] °C
```

#### 4.1.3 SegmentedControl
**용도**: 2-4개 옵션 선택 (수유 방향: 좌/우/양쪽)

**스펙**:
```
Container:
├─ Height:       40dp
├─ Background:   $surface-tertiary
├─ Border:       1dp, $border-default
├─ Radius:       radius-md (8dp)
└─ Padding:      2dp

Segment:
├─ Height:       36dp
├─ Min Width:    60dp
├─ Font:         body-medium (14sp, Medium)
├─ Radius:       radius-md (8dp) - 1dp
└─ Transition:   200ms
```

**상태**:
- **Selected**: Background `$primary`, Text `#FFFFFF`, Elevation `level-1`
- **Unselected**: Background `transparent`, Text `$text-secondary`

#### 4.1.4 SwitchWithLabel
**구성**: Switch + Label + Description (optional)

**스펙**:
```
Layout:          Horizontal, space-between
Switch Size:     48dp(W) × 28dp(H)
Thumb Size:      24dp
Label Font:      body-large (16sp, Medium)
Description:     caption (12sp), $text-secondary
Gap:             8dp (label ↔ description)
```

#### 4.1.5 CheckboxWithLabel
**구성**: Checkbox + Label

**스펙**:
```
Checkbox Size:   24dp × 24dp
Border:          2dp, $border-default
Border Radius:   radius-sm (4dp)
Check Icon:      18dp, $primary
Gap:             12dp
Label Font:      body-medium (14sp)
```

---

### 4.2 List Items

#### 4.2.1 BabyProfileHeader
**구성**: Avatar + Name + Age Info

**스펙**:
```
Layout:          Horizontal
Gap:             16dp
Avatar Size:     48dp
Name Font:       title (20sp, SemiBold)
Age Font:        body-medium (14sp), $text-secondary
Padding:         16dp
Background:      $surface-primary
Border Radius:   radius-xl (16dp)
```

**예시**:
```
[Avatar] Seungbum Jr.
         2 months 7 days
```

#### 4.2.2 RecordListItem
**구성**: Icon + Content + Time + Actions

**스펙**:
```
Layout:          Horizontal, space-between
Height:          Min 64dp
Padding:         12dp(H) × 16dp(V)
Gap:             12dp
Border Bottom:   1dp, $border-light (optional)
```

**구조**:
```
[Icon] [Content]      [Time] [Actions]
       [Details]            [>]
```

**요소**:
- **Icon**: 32dp, colored by category
- **Content**: Title (body-large) + Details (body-medium, secondary)
- **Time**: caption (12sp), $text-tertiary
- **Actions**: chevron_right icon or action buttons

**타입별 아이콘 색상**:
```
Feeding:    $primary (blue)
Diaper:     $accent (orange)
Sleep:      $success (green)
Medicine:   $error (red)
```

#### 4.2.3 GPTHistoryItem
**구성**: Question Summary + Timestamp

**스펙**:
```
Layout:          Vertical
Padding:         16dp
Gap:             8dp
Border:          1dp, $border-default
Border Radius:   radius-lg (12dp)
Background:      $surface-primary
```

**구조**:
```
Q: [Question text preview...]
   [Timestamp] • [Badge]
```

#### 4.2.4 SelectableListItem
**용도**: 선택 가능한 리스트 아이템

**스펙**:
```
Height:          56dp
Padding:         12dp(V) × 16dp(H)
Background:      $surface-primary (default)
                 $primary-50 (selected)
```

**구성**:
- Leading: Radio button or Checkbox
- Content: Text
- Trailing: Check icon (if selected)

---

### 4.3 Cards & Containers

#### 4.3.1 StatCard (Metric Card)
**용도**: 통계/지표 표시

**스펙**:
```
Layout:          Vertical
Padding:         16dp
Gap:             8dp
Background:      $surface-primary
Border:          1dp, $border-default
Border Radius:   radius-xl (16dp)
Min Height:      100dp
```

**구조**:
```
[Icon]
[Value]  (display-medium, 28sp, Bold)
[Label]  (caption, 12sp, $text-secondary)
```

**변형**:
- `StatCard.Colored`: 배경 색상 강조 (Primary-50, Success-50, etc.)
- `StatCard.WithTrend`: 증감 표시 (↑↓ icon + percentage)

#### 4.3.2 InfoCard
**용도**: 정보 표시 카드

**스펙**:
```
Padding:         16dp
Background:      $surface-primary
Border Radius:   radius-xl (16dp)
Elevation:       level-1
```

**구조**:
- Header: Title + Action Button (optional)
- Content: Custom content area
- Footer: Metadata or actions (optional)

---

### 4.4 Dashboard Elements

#### 4.4.1 StatusCardHeader
**구성**: Title + Status Badge + More Icon

**스펙**:
```
Layout:          Horizontal, space-between
Padding:         16dp
Title Font:      title (20sp, SemiBold)
Gap:             8dp
```

#### 4.4.2 TimerDisplay
**구성**: Time Text + Status Badge

**스펙**:
```
Time Font:       display-medium (28sp, Bold)
Time Color:      $primary
Status Badge:    Small badge (L/R/Both)
Layout:          Horizontal, aligned center
Gap:             12dp
```

**예시**:
```
00:15:23  [L]
```

#### 4.4.3 QuickActionButton
**구성**: Icon + Label (Vertical layout)

**스펙**:
```
Size:            Auto (fit content)
Padding:         16dp
Layout:          Vertical, centered
Gap:             8dp
Background:      $primary (or category color)
Border Radius:   radius-lg (12dp)
Icon Size:       icon-md (24dp)
Label Font:      body-medium (14sp, SemiBold)
Text Color:      #FFFFFF
```

**타입별 배경색**:
```
Breast Milk:  $primary
Formula:      $primary-100 (text: $primary)
Diaper:       $accent-50 (text: $accent)
Sleep:        $success-50 (text: $success)
```

#### 4.4.4 ActivityStatusCard
**구성**: Icon + Status Text + Time Badge

**스펙**:
```
Size:            Flexible width
Padding:         16dp
Layout:          Vertical, centered
Gap:             8dp
Background:      Category color (light)
Border Radius:   radius-lg (12dp)
Icon Size:       icon-lg (32dp)
Time Font:       body-medium (14sp, SemiBold)
```

---

### 4.5 Navigation Elements

#### 4.5.1 BottomNavItem
**구성**: Icon + Label (Vertical)

**스펙**:
```
Size:            Auto × 64dp
Padding:         8dp(V) × 12dp(H)
Layout:          Vertical, centered
Gap:             4dp
Icon Size:       icon-md (24dp)
Label Font:      caption (12sp)
```

**상태**:
- **Active**: Icon & Text `$primary`, Font Weight `600`
- **Inactive**: Icon & Text `$text-secondary`, Font Weight `400`

**인터랙션**:
- Ripple effect on tap
- Transition: 200ms

#### 4.5.2 TabItem
**구성**: Label + Indicator

**스펙**:
```
Height:          48dp
Padding:         12dp(V) × 20dp(H)
Label Font:      body-medium (14sp, Medium)
Indicator:       2dp height, $primary
```

**상태**:
- **Active**: Text `$primary`, Indicator visible
- **Inactive**: Text `$text-secondary`, Indicator hidden

---

## 5. Organisms (유기체)
*Molecules를 조합하여 명확한 인터페이스 섹션 구성*

### 5.1 Dashboard Components

#### 5.1.1 BabySummaryCard
**구성**: BabyProfileHeader + Daily Stats

**스펙**:
```
Layout:          Vertical
Padding:         16dp
Gap:             16dp
Background:      $surface-primary
Border Radius:   radius-xl (16dp)
Elevation:       level-1
```

**구조**:
```
[Avatar] [Name]
         [Age]
─────────────────
오늘의 기록
• 수유: 8회 (650ml)
• 수면: 12시간
• 기저귀: 6회
```

#### 5.1.2 LastActivityGrid
**구성**: 3-column grid of ActivityStatusCards

**스펙**:
```
Layout:          Horizontal (3 columns)
Gap:             12dp
Card Width:      fill_container (1fr each)
```

**카드 구성**:
1. **수유** (Feeding): Icon `water_drop`, Background `$primary-50`
2. **기저귀** (Diaper): Icon `baby_changing_station`, Background `$accent-50`
3. **수면** (Sleep): Icon `bedtime`, Background `$success-50`

**표시 정보**: "4m ago", "2h ago", "3h ago"

#### 5.1.3 ActiveTimerWidget
**구성**: TimerDisplay + Control Buttons

**스펙**:
```
Layout:          Horizontal
Padding:         16dp
Gap:             16dp
Background:      $surface-primary
Border:          2dp, $primary
Border Radius:   radius-xl (16dp)
Elevation:       level-1
```

**구조**:
```
[00:15:23] [L]  [Pause] [Stop] [Switch]
```

**버튼**:
- **Pause**: IconButton (pause icon)
- **Stop**: IconButton (stop icon)
- **Switch**: SecondaryButton (L ↔ R)

**상태 표시**:
- **수유 중**: Primary border, Timer running
- **일시정지**: Border dashed, Timer paused

#### 5.1.4 QuickRecordGrid
**구성**: 2×2 Grid of QuickActionButtons

**스펙**:
```
Layout:          Vertical (2 rows)
Row Layout:      Horizontal (2 columns)
Gap:             12dp
```

**버튼 구성**:
```
[모유 수유]  [분유 수유]
[기저귀]    [수면]
```

---

### 5.2 Record Components

#### 5.2.1 FeedingRecordForm
**구성**: 수유 기록 입력 폼

**스펙**:
```
Layout:          Vertical, scrollable
Padding:         16dp
Gap:             16dp
Background:      $background-primary
```

**필드 구성**:
1. **수유 타입**: SegmentedControl (모유/분유/이유식)
2. **수유 방향** (모유): SegmentedControl (좌/우/양쪽)
3. **수유량** (분유): UnitInputField (ml)
4. **수유 시간** (모유): UnitInputField (분)
5. **기록 시간**: DateTimePicker
6. **메모**: TextField (multiline, optional)

**하단 액션**:
- **취소**: SecondaryButton
- **저장**: PrimaryButton

#### 5.2.2 CareRecordForm
**구성**: 육아 기록 입력 폼

**스펙**: FeedingRecordForm과 동일한 레이아웃

**필드 구성 (타입별)**:

**기저귀**:
1. 기저귀 상태: SegmentedControl (젖음/대변/둘 다)
2. 기록 시간: DateTimePicker
3. 메모: TextField (optional)

**수면**:
1. 수면 시작: DateTimePicker
2. 수면 종료: DateTimePicker
3. 수면 시간: 자동 계산 표시
4. 메모: TextField (optional)

**체온**:
1. 체온: UnitInputField (°C)
2. 측정 시간: DateTimePicker
3. 메모: TextField (optional)

**약물**:
1. 약물명: TextField
2. 용량: TextField
3. 복용 시간: DateTimePicker
4. 메모: TextField (optional)

#### 5.2.3 RecordHistoryList
**구성**: 날짜별 그룹화된 RecordListItems

**스펙**:
```
Layout:          Vertical, scrollable
Date Header:     Sticky header
```

**날짜 헤더**:
```
Background:      $background-primary
Padding:         8dp(V) × 16dp(H)
Font:            caption-large (13sp, SemiBold)
Color:           $text-secondary
Sticky:          Top
```

**구조**:
```
━━━ 오늘 ━━━
[수유 기록 1]
[기저귀 기록 1]
[수면 기록 1]

━━━ 어제 ━━━
[수유 기록 2]
...
```

---

### 5.3 GPT Components

#### 5.3.1 GPTChatWidget
**구성**: Message List + Input Area

**스펙**:
```
Layout:          Vertical
Height:          fill_container
```

**메시지 리스트**:
```
Layout:          Vertical, reversed (최신 하단)
Padding:         16dp
Gap:             12dp
Background:      $background-primary
```

**메시지 버블**:
```
User Message:
├─ Align:          end (right)
├─ Background:     $primary
├─ Text Color:     #FFFFFF
├─ Border Radius:  radius-xl (16dp), bottom-right radius-sm
├─ Padding:        12dp
└─ Max Width:      80%

AI Message:
├─ Align:          start (left)
├─ Background:     $surface-secondary
├─ Text Color:     $text-primary
├─ Border Radius:  radius-xl (16dp), bottom-left radius-sm
├─ Padding:        12dp
└─ Max Width:      80%
```

**입력 영역**:
```
Layout:          Horizontal
Padding:         12dp(V) × 16dp(H)
Background:      $surface-primary
Border Top:      1dp, $border-light
Gap:             8dp
```

**구성**:
- TextField: fill_container, multiline (max 4 lines)
- Send Button: IconButton, disabled when empty

#### 5.3.2 GPTContextIndicator
**구성**: 컨텍스트 정보 표시 배너

**스펙**:
```
Padding:         12dp
Background:      $info-50
Border Left:     4dp, $info
Border Radius:   radius-md (8dp)
Gap:             8dp
```

**구조**:
```
[Info Icon] 최근 7일간의 기록을 바탕으로 답변합니다
            • 수유 기록 23개
            • 육아 기록 18개
```

---

### 5.4 Navigation

#### 5.4.1 BottomNavigationBar
**구성**: 4개 BottomNavItems

**스펙**:
```
Height:          80dp (with padding)
Padding:         12dp(T) × 0dp(H)
Background:      $surface-primary
Border Top:      1dp, $border-default
Elevation:       level-2
Layout:          Horizontal, space-around
```

**탭 구성**:
1. **Home** (home icon)
2. **History** (history icon)
3. **AI Chat** (smart_toy icon)
4. **Profile** (person icon)

#### 5.4.2 AppBar
**구성**: Leading + Title + Actions

**스펙**:
```
Height:          56dp (default) / 64dp (large)
Padding:         0dp(V) × 4dp(H)
Background:      $surface-primary
Border Bottom:   1dp, $border-light (optional)
Elevation:       level-0 (flat) / level-1 (elevated)
```

**구조**:
```
[Back] [Title]              [Action] [Menu]
```

**요소**:
- **Leading**: IconButton (back, menu)
- **Title**: headline (24sp) or title (20sp)
- **Actions**: 1-3 IconButtons

**변형**:
- `AppBar.Large`: Height 64dp, Title 28sp
- `AppBar.Transparent`: Background transparent, no border
- `AppBar.Floating`: With Elevation level-2

---

### 5.5 Modals & Overlays

#### 5.5.1 BottomSheet
**용도**: 하단에서 올라오는 액션 시트

**스펙**:
```
Max Height:      90% of screen
Min Height:      fit_content
Border Radius:   radius-3xl (24dp) top only
Background:      $surface-primary
Elevation:       level-4
Padding:         24dp
```

**구조**:
```
[Drag Handle]  (32dp × 4dp, centered, $border-strong)
[Title]        (headline, 24sp)
[Content]      (scrollable if needed)
[Actions]      (bottom-aligned buttons)
```

#### 5.5.2 Dialog (Modal)
**용도**: 중앙 모달 다이얼로그

**스펙**:
```
Width:           Min 280dp, Max 560dp
Padding:         24dp
Border Radius:   radius-xl (16dp)
Background:      $surface-primary
Elevation:       level-4
```

**구조**:
```
[Icon]         (optional, icon-xl)
[Title]        (headline, 24sp, centered)
[Content]      (body-medium, 14sp)
[Actions]      (horizontal button group, end-aligned)
```

#### 5.5.3 Snackbar
**용도**: 하단 피드백 메시지

**스펙**:
```
Width:           fit_content, max 90%
Height:          48dp (single line) / auto (action)
Padding:         12dp(V) × 16dp(H)
Border Radius:   radius-md (8dp)
Background:      #323232 (dark) or $text-primary
Text Color:      #FFFFFF
Elevation:       level-3
Position:        Bottom, centered, 16dp from bottom
Duration:        4s (default)
```

**구조**:
```
[Message]                 [Action]
```

---

## 6. Templates (템플릿)
*페이지의 구조적 레이아웃*

### 6.1 Dashboard Template

**구조**:
```
┌────────────────────────────────────┐
│ AppBar (56dp)                      │
├────────────────────────────────────┤
│ [Scroll Area]                      │
│  ┌──────────────────────────────┐  │
│  │ BabySummaryCard              │  │ ← 16dp padding
│  └──────────────────────────────┘  │
│                                    │
│  ┌──────────────────────────────┐  │
│  │ ActiveTimerWidget (조건부)   │  │ ← 24dp gap
│  └──────────────────────────────┘  │
│                                    │
│  ┌──────────────────────────────┐  │
│  │ LastActivityGrid (3-col)     │  │ ← 24dp gap
│  └──────────────────────────────┘  │
│                                    │
│  ┌──────────────────────────────┐  │
│  │ Quick Actions (2×2 grid)     │  │ ← 24dp gap
│  └──────────────────────────────┘  │
│                                    │
│  ┌──────────────────────────────┐  │
│  │ Recent History               │  │ ← 24dp gap
│  └──────────────────────────────┘  │
│                                    │
│  [16dp bottom padding]             │
└────────────────────────────────────┘
┌────────────────────────────────────┐
│ BottomNavigationBar (80dp)         │
└────────────────────────────────────┘
```

**스펙**:
- Screen Padding: 0dp (top), 16dp (horizontal), 0dp (bottom)
- Content Gap: 24dp
- Background: $background-primary
- Bottom Nav: Fixed at bottom

---

### 6.2 Form Template

**구조**:
```
┌────────────────────────────────────┐
│ AppBar                             │
│  [Back] [Title]        [Save]      │
├────────────────────────────────────┤
│ [Scroll Area]                      │
│  ┌──────────────────────────────┐  │
│  │ Form Content                 │  │
│  │  ┌────────────────────────┐  │  │
│  │  │ LabeledInput 1         │  │  │ ← 16dp gap
│  │  └────────────────────────┘  │  │
│  │  ┌────────────────────────┐  │  │
│  │  │ LabeledInput 2         │  │  │ ← 16dp gap
│  │  └────────────────────────┘  │  │
│  │  ┌────────────────────────┐  │  │
│  │  │ SegmentedControl       │  │  │ ← 16dp gap
│  │  └────────────────────────┘  │  │
│  │  ...                         │  │
│  └──────────────────────────────┘  │
│                                    │
│  [Bottom Spacer: 96dp]             │
└────────────────────────────────────┘
┌────────────────────────────────────┐
│ Bottom Action Bar (Fixed)          │
│  [Cancel]              [Save]      │
└────────────────────────────────────┘
```

**스펙**:
- Content Padding: 16dp (all sides)
- Field Gap: 16dp
- Bottom Action Bar: Height 80dp, Padding 16dp, Elevated
- Keyboard Handling: Adjust scroll when keyboard appears

---

### 6.3 List Template

**구조**:
```
┌────────────────────────────────────┐
│ AppBar                             │
│  [Back] [Title]        [Filter]    │
├────────────────────────────────────┤
│ ┌────────────────────────────────┐ │
│ │ Filter Bar (optional)          │ │
│ └────────────────────────────────┘ │
├────────────────────────────────────┤
│ [Infinite Scroll List]             │
│  ┌──────────────────────────────┐  │
│  │ ━━━ 오늘 ━━━ (Sticky)       │  │
│  ├──────────────────────────────┤  │
│  │ RecordListItem 1             │  │
│  ├──────────────────────────────┤  │
│  │ RecordListItem 2             │  │
│  ├──────────────────────────────┤  │
│  │ ...                          │  │
│  └──────────────────────────────┘  │
│  ┌──────────────────────────────┐  │
│  │ ━━━ 어제 ━━━                │  │
│  ├──────────────────────────────┤  │
│  │ RecordListItem 3             │  │
│  └──────────────────────────────┘  │
│                                    │
└────────────────────────────────────┘
             [FAB] ← 16dp from edges
```

**스펙**:
- List Padding: 0dp (full width)
- Date Header: Sticky, Background $background-primary
- FAB: Fixed at bottom-right, 16dp margin
- Pull-to-Refresh: Enabled

---

### 6.4 Chat Template

**구조**:
```
┌────────────────────────────────────┐
│ AppBar                             │
│  [Back] [AI Chat]                  │
├────────────────────────────────────┤
│ [Message List - Reversed]          │
│                                    │
│  ┌──────────────────────────────┐  │
│  │ AI Message                   │  │ ← left-aligned
│  └──────────────────────────────┘  │
│          ┌──────────────────────┐  │
│          │ User Message         │  │ ← right-aligned
│          └──────────────────────┘  │
│  ┌──────────────────────────────┐  │
│  │ AI Message                   │  │
│  └──────────────────────────────┘  │
│                                    │
│  [Context Indicator]               │
│                                    │
└────────────────────────────────────┘
┌────────────────────────────────────┐
│ Input Area (Fixed)                 │
│  [TextField]          [Send]       │
└────────────────────────────────────┘
```

**스펙**:
- Message Padding: 16dp (horizontal)
- Message Gap: 12dp
- Input Area: Height auto (max 5 lines), Fixed at bottom
- Keyboard: Push up input area

---

### 6.5 Profile/Settings Template

**구조**:
```
┌────────────────────────────────────┐
│ AppBar                             │
│  [Menu] [Profile]                  │
├────────────────────────────────────┤
│ [Scroll Area]                      │
│  ┌──────────────────────────────┐  │
│  │ Profile Header               │  │
│  │  [Avatar (96dp)]             │  │
│  │  [Name]                      │  │
│  │  [Edit Button]               │  │
│  └──────────────────────────────┘  │
│                                    │
│  ━━━ 섹션 1 ━━━                    │
│  [Setting Item 1]                  │
│  [Setting Item 2]                  │
│                                    │
│  ━━━ 섹션 2 ━━━                    │
│  [Setting Item 3]                  │
│  [Setting Item 4]                  │
│                                    │
└────────────────────────────────────┘
┌────────────────────────────────────┐
│ BottomNavigationBar                │
└────────────────────────────────────┘
```

**스펙**:
- Profile Header: Padding 24dp, Centered
- Section Header: overline style, Padding 8dp × 16dp
- Setting Item: Height 56dp, Padding 16dp

---

## 7. Pages (페이지)
*실제 데이터가 주입된 완성된 화면*

### 7.1 DashboardPage
**템플릿**: Dashboard Template

**주요 컴포넌트**:
1. **AppBar**: "Baby Care" 타이틀, 메뉴 아이콘
2. **BabySummaryCard**: 아기 프로필 + 오늘의 요약
3. **ActiveTimerWidget**: 진행 중인 수유 타이머 (조건부 표시)
4. **LastActivityGrid**: 3개 활동 카드 (수유, 기저귀, 수면)
5. **QuickRecordGrid**: 4개 빠른 기록 버튼
6. **RecordHistoryList**: 최근 5개 기록 (더보기 버튼)

**API 연동**:
- `GET /babies/{id}/dashboard` → 전체 데이터
- 실시간 업데이트: 타이머 진행 시간

**상태 관리**:
- 활성 타이머 상태
- 새로고침 (Pull-to-Refresh)
- 실시간 시간 업데이트

---

### 7.2 AddRecordPage / EditRecordPage
**템플릿**: Form Template

**주요 컴포넌트**:
1. **AppBar**: 
   - Add: "기록 추가", 취소/저장 버튼
   - Edit: "기록 수정", 취소/저장 버튼
2. **FeedingRecordForm** 또는 **CareRecordForm**: 동적 폼
3. **Bottom Action Bar**: 취소/저장 버튼

**API 연동**:
- Add: `POST /feeding-records` or `/care-records`
- Edit: `PUT /feeding-records/{id}` or `/care-records/{id}`

**유효성 검사**:
- 필수 필드 체크
- 값 범위 검증 (예: 수유량 > 0)
- 시간 논리 검증 (시작 < 종료)

**사용자 경험**:
- 자동 포커스 (첫 번째 입력 필드)
- 저장 시 로딩 인디케이터
- 성공 시 이전 화면으로 돌아가기
- 에러 시 Snackbar 표시

---

### 7.3 RecordHistoryPage
**템플릿**: List Template

**주요 컴포넌트**:
1. **AppBar**: "기록", 필터 아이콘
2. **Filter Bar**: 날짜 범위, 카테고리 필터 (칩 형태)
3. **RecordHistoryList**: 무한 스크롤 리스트
4. **FAB**: 새 기록 추가

**API 연동**:
- `GET /feeding-records?limit=20&offset=0`
- `GET /care-records?limit=20&offset=0`
- 무한 스크롤: offset 증가

**필터링**:
- 날짜 범위: 오늘, 최근 7일, 최근 30일, 커스텀
- 카테고리: 전체, 수유, 기저귀, 수면, 기타

**인터랙션**:
- 아이템 탭: 상세 보기
- 아이템 스와이프: 수정/삭제
- Pull-to-Refresh

---

### 7.4 GPTConsultationPage
**템플릿**: Chat Template

**주요 컴포넌트**:
1. **AppBar**: "AI Chat"
2. **GPTContextIndicator**: 컨텍스트 정보 (최근 N일 기록)
3. **Message List**: 대화 내역
4. **Input Area**: 질문 입력 + 전송 버튼

**API 연동**:
- `POST /gpt-questions` → 질문 전송
- `GET /gpt-conversations` → 대화 내역 로드

**사용자 경험**:
- 메시지 전송 시 로딩 인디케이터
- 스트리밍 응답 (가능 시)
- 에러 처리 (재시도 버튼)
- 컨텍스트 일수 조정 옵션

---

### 7.5 BabyProfilePage
**템플릿**: Profile/Settings Template

**주요 컴포넌트**:
1. **AppBar**: "프로필"
2. **Profile Header**: 아기 사진, 이름, 나이
3. **Info Section**: 
   - 생년월일
   - 성별
   - 혈액형
   - 출생 체중/신장
4. **Settings Section**:
   - 프로필 편집
   - 가족 구성원 관리 (Phase 2)
   - 알림 설정
5. **Danger Zone**: 프로필 삭제

**API 연동**:
- `GET /babies/{id}` → 프로필 조회
- `PUT /babies/{id}` → 프로필 수정
- `DELETE /babies/{id}` → 프로필 삭제 (확인 다이얼로그)

---

### 7.6 RecordDetailPage
**템플릿**: 스크롤 가능한 상세 페이지

**구조**:
```
┌────────────────────────────────────┐
│ AppBar                             │
│  [Back] [상세 기록]     [Edit]     │
├────────────────────────────────────┤
│ [Scroll Area]                      │
│  ┌──────────────────────────────┐  │
│  │ Header Card                  │  │
│  │  [Icon] [Category]           │  │
│  │  [Timestamp]                 │  │
│  └──────────────────────────────┘  │
│                                    │
│  ┌──────────────────────────────┐  │
│  │ Details Section              │  │
│  │  • 수유량: 120ml              │  │
│  │  • 수유 시간: 15분            │  │
│  │  • 메모: ...                  │  │
│  └──────────────────────────────┘  │
│                                    │
│  [Delete Button]                   │
│                                    │
└────────────────────────────────────┘
```

**API 연동**:
- `GET /feeding-records/{id}` or `/care-records/{id}`
- `DELETE /feeding-records/{id}` or `/care-records/{id}`

---

## 8. Implementation Guidelines

### 8.1 Component Architecture

#### Flutter 위젯 구조
```dart
lib/
├─ presentation/
│  ├─ atoms/
│  │  ├─ buttons/
│  │  │  ├─ primary_button.dart
│  │  │  ├─ secondary_button.dart
│  │  │  ├─ icon_button.dart
│  │  │  └─ fab.dart
│  │  ├─ inputs/
│  │  │  ├─ text_field.dart
│  │  │  ├─ number_field.dart
│  │  │  └─ dropdown_field.dart
│  │  └─ display/
│  │     ├─ app_text.dart
│  │     ├─ app_icon.dart
│  │     ├─ avatar.dart
│  │     └─ status_badge.dart
│  ├─ molecules/
│  │  ├─ forms/
│  │  │  ├─ labeled_input.dart
│  │  │  ├─ unit_input_field.dart
│  │  │  └─ segmented_control.dart
│  │  ├─ list_items/
│  │  │  ├─ baby_profile_header.dart
│  │  │  ├─ record_list_item.dart
│  │  │  └─ gpt_history_item.dart
│  │  └─ cards/
│  │     ├─ stat_card.dart
│  │     └─ info_card.dart
│  ├─ organisms/
│  │  ├─ dashboard/
│  │  │  ├─ baby_summary_card.dart
│  │  │  ├─ last_activity_grid.dart
│  │  │  ├─ active_timer_widget.dart
│  │  │  └─ quick_record_grid.dart
│  │  ├─ forms/
│  │  │  ├─ feeding_record_form.dart
│  │  │  └─ care_record_form.dart
│  │  └─ navigation/
│  │     ├─ app_bar.dart
│  │     └─ bottom_navigation_bar.dart
│  └─ pages/
│     ├─ dashboard_page.dart
│     ├─ add_record_page.dart
│     ├─ record_history_page.dart
│     ├─ gpt_consultation_page.dart
│     └─ baby_profile_page.dart
```

---

### 8.2 Design Token Implementation

#### Flutter Theme 설정
```dart
// lib/core/theme/app_theme.dart

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: Color(0xFF4A90E2),
        secondary: Color(0xFFFF8A80),
        tertiary: Color(0xFFF5A623),
        surface: Color(0xFFFFFFFF),
        background: Color(0xFFF9F9F9),
        error: Color(0xFFEF5350),
      ),
      
      // Typography
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.25,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.33,
          letterSpacing: -0.25,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.40,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.50,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.43,
          letterSpacing: 0.25,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          height: 1.38,
          letterSpacing: 0.4,
        ),
      ),
      
      // Shape
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Spacing (via custom extension)
      extensions: <ThemeExtension<dynamic>>[
        AppSpacing(),
        AppRadius(),
      ],
    );
  }
}

// Spacing Extension
class AppSpacing extends ThemeExtension<AppSpacing> {
  static const double space0 = 0;
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space6 = 24;
  static const double space8 = 32;
  
  @override
  ThemeExtension<AppSpacing> copyWith() => this;
  
  @override
  ThemeExtension<AppSpacing> lerp(
    ThemeExtension<AppSpacing>? other,
    double t,
  ) => this;
}
```

---

### 8.3 Responsive Design

#### Breakpoint 처리
```dart
// lib/core/responsive/breakpoints.dart

enum ScreenSize {
  mobile,    // < 600dp
  tablet,    // 600-840dp
  desktop,   // > 840dp
}

class Responsive {
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return ScreenSize.mobile;
    if (width < 840) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }
  
  static T value<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}
```

---

### 8.4 Accessibility

#### 최소 터치 타겟 준수
```dart
// All interactive elements
const kMinInteractiveDimension = 44.0;

// Usage
Container(
  constraints: BoxConstraints(
    minWidth: kMinInteractiveDimension,
    minHeight: kMinInteractiveDimension,
  ),
  child: IconButton(...),
)
```

#### Semantic Labels
```dart
Semantics(
  label: '수유 기록 추가',
  button: true,
  child: IconButton(
    icon: Icon(Icons.add),
    onPressed: () {},
  ),
)
```

---

### 8.5 Animation Guidelines

#### 표준 애니메이션 Duration
```dart
const kQuickAnimation = Duration(milliseconds: 200);
const kNormalAnimation = Duration(milliseconds: 300);
const kSlowAnimation = Duration(milliseconds: 400);

// Usage
AnimatedContainer(
  duration: kNormalAnimation,
  curve: Curves.easeInOut,
  ...
)
```

---

### 8.6 Code Style Guidelines

#### 컴포넌트 네이밍
- Atoms: `PrimaryButton`, `AppTextField`
- Molecules: `LabeledInput`, `RecordListItem`
- Organisms: `BabySummaryCard`, `QuickRecordGrid`
- Pages: `DashboardPage`, `AddRecordPage`

#### 파일 네이밍
- Snake case: `primary_button.dart`, `baby_summary_card.dart`
- 테스트: `primary_button_test.dart`

#### Props 전달
```dart
// Good: Named parameters
PrimaryButton(
  label: 'Save',
  onPressed: () {},
  isLoading: false,
)

// Bad: Positional parameters
PrimaryButton('Save', () {}, false)
```

---

### 8.7 Performance Optimization

#### 리스트 최적화
```dart
// Use ListView.builder for long lists
ListView.builder(
  itemCount: records.length,
  itemBuilder: (context, index) {
    return RecordListItem(record: records[index]);
  },
)

// Use const constructors
const AppText.bodyLarge('Hello')
```

#### 이미지 최적화
```dart
// Cache network images
CachedNetworkImage(
  imageUrl: baby.photoUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

---

## 9. Quality Checklist

### 디자인 일관성
- [ ] 모든 간격이 4dp 배수인가?
- [ ] 모든 radius가 정의된 토큰을 사용하는가?
- [ ] 색상이 정의된 팔레트를 사용하는가?
- [ ] 폰트 크기가 Type Scale을 따르는가?

### 접근성
- [ ] 최소 터치 타겟 44dp를 준수하는가?
- [ ] 텍스트 대비율이 4.5:1 이상인가?
- [ ] Semantic labels가 적용되어 있는가?
- [ ] 키보드 내비게이션이 가능한가?

### 성능
- [ ] 리스트에 builder 패턴을 사용하는가?
- [ ] const constructor를 사용하는가?
- [ ] 불필요한 rebuild를 방지하는가?
- [ ] 이미지 캐싱을 적용했는가?

### 사용성
- [ ] 로딩 상태를 표시하는가?
- [ ] 에러 메시지가 명확한가?
- [ ] 빈 상태를 처리하는가?
- [ ] 피드백(Snackbar, Dialog)을 제공하는가?

---

## 10. References

### External Resources
- [Material Design 3](https://m3.material.io/)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

### Internal Documents
- PRD: `.cursor/prd/20260206-baby-care-mvp-prd.md`
- API Reference: `docs/api-reference.md`
- Flutter Integration Guide: `docs/flutter-integration-guide.md`

---

**문서 버전**: 2.0  
**최종 업데이트**: 2026-02-08  
**작성자**: Development Team

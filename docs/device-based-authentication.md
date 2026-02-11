# 디바이스 기반 인증 시스템

## 개요

Baby Care AI는 **디바이스 ID 기반 자동 인증 시스템**을 사용합니다.  
회원가입이나 로그인 과정 없이 디바이스 정보만으로 자동으로 인증되어 앱을 사용할 수 있습니다.

## 주요 특징

### 1. 자동 인증
- 앱 시작 시 자동으로 디바이스 ID 생성 및 인증
- 회원가입/로그인 화면 불필요
- 사용자 개입 없이 백그라운드에서 처리

### 2. 디바이스 식별
- UUID v4 기반 고유 디바이스 ID 생성
- 디바이스 정보 자동 수집 (플랫폼, 모델, OS 버전 등)
- Secure Storage를 통한 안전한 ID 저장

### 3. 향후 확장성
- 구글 계정 연동 기능 추가 예정
- 소셜 로그인은 나중에 추가 가능
- 현재는 디바이스 기반으로만 운영

## 아키텍처

```
┌──────────────────────────────────────────────┐
│  앱 시작 (main.dart)                          │
└──────────────┬───────────────────────────────┘
               │
               v
┌──────────────────────────────────────────────┐
│  AuthState 초기화                             │
│  - autoSignIn() 자동 호출                     │
└──────────────┬───────────────────────────────┘
               │
               v
┌──────────────────────────────────────────────┐
│  DeviceService                               │
│  - 디바이스 ID 생성/조회                       │
│  - 디바이스 정보 수집                          │
└──────────────┬───────────────────────────────┘
               │
               v
┌──────────────────────────────────────────────┐
│  AuthService                                 │
│  - 디바이스 ID로 자동 로그인                   │
│  - Access Token 생성/저장                     │
└──────────────┬───────────────────────────────┘
               │
               v
┌──────────────────────────────────────────────┐
│  ApiClient                                   │
│  - Authorization 헤더에 토큰 자동 추가         │
│  - X-Device-ID 헤더 추가                      │
└──────────────────────────────────────────────┘
```

## 주요 컴포넌트

### 1. DeviceService (`lib/services/device_service.dart`)

디바이스 ID 및 정보 관리를 담당합니다.

**주요 기능:**
- `getDeviceId()`: 디바이스 고유 ID 생성/조회
- `getDeviceInfo()`: 플랫폼별 디바이스 정보 수집
- `resetDeviceId()`: 디바이스 ID 초기화 (테스트용)

**디바이스 정보:**
- **Android**: model, manufacturer, os_version, sdk_version, brand, device
- **iOS**: model, name, os_version, is_physical, identifier

### 2. AuthService (`lib/services/auth_service.dart`)

디바이스 기반 인증 로직을 처리합니다.

**주요 기능:**
- `autoSignIn()`: 디바이스 ID로 자동 로그인
- `signOut()`: 로그아웃 (토큰 삭제)
- `refreshToken()`: 토큰 갱신
- `resetDevice()`: 디바이스 초기화

**인증 흐름:**
1. 저장된 토큰 확인
2. 토큰이 없으면 디바이스 ID 생성
3. 디바이스 정보 수집
4. 서버에 인증 요청 (TODO)
5. Access Token 저장

### 3. AuthState (`lib/states/auth_state.dart`)

전역 인증 상태를 관리합니다.

**주요 속성:**
- `isAuthenticated`: 인증 상태
- `userId`: 사용자 ID (디바이스 ID 기반)
- `deviceId`: 디바이스 ID
- `deviceInfo`: 디바이스 정보

**주요 메서드:**
- `autoSignIn()`: 자동 로그인 실행
- `signOut()`: 로그아웃
- `resetDevice()`: 디바이스 초기화
- `refreshToken()`: 토큰 갱신

### 4. ApiClient (`lib/clients/api_client.dart`)

서버 API와의 통신을 담당합니다.

**주요 기능:**
- `registerDevice()`: 디바이스 등록
- `signInWithDevice()`: 디바이스로 로그인
- `AuthInterceptor`: 모든 요청에 토큰 자동 추가

**헤더:**
- `Authorization: Bearer {access_token}`
- `X-Device-ID: {device_id}`

## 사용 방법

### 1. 기본 설정

`pubspec.yaml`에 필요한 패키지가 포함되어 있습니다:

```yaml
dependencies:
  device_info_plus: ^11.1.1  # 디바이스 정보
  uuid: ^4.5.1               # UUID 생성
  flutter_secure_storage: ^9.2.2  # 안전한 저장소
```

### 2. 자동 인증

앱 시작 시 자동으로 인증이 처리됩니다:

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const BabyCareApp());
}

// AuthState가 자동으로 autoSignIn() 호출
AuthState() {
  _initializeAuth();
}
```

### 3. 인증 상태 사용

```dart
// 어떤 화면에서든 AuthState 접근 가능
final authState = context.watch<AuthState>();

if (authState.isAuthenticated) {
  // 인증됨
  print('User ID: ${authState.userId}');
  print('Device ID: ${authState.deviceId}');
} else {
  // 인증 중 또는 실패
  print('Error: ${authState.errorMessage}');
}
```

### 4. API 호출

```dart
// ApiClient는 자동으로 토큰을 추가합니다
final apiClient = ApiClient(authService);

// 디바이스 등록
await apiClient.registerDevice(
  deviceId: deviceId,
  deviceInfo: deviceInfo,
);

// 디바이스로 로그인
final response = await apiClient.signInWithDevice(
  deviceId: deviceId,
  deviceInfo: deviceInfo,
);
```

## 라우팅

### 현재 라우트

1. `/splash` - 스플래시 화면
2. `/dashboard` - 메인 대시보드

### 인증 흐름

```
앱 시작
  ↓
Splash Screen (2초)
  ↓
AuthState.autoSignIn() 실행
  ↓
Dashboard Screen
```

로그인/회원가입 화면이 없으며, 인증 실패 시에도 Dashboard로 이동합니다 (로컬 데이터 사용).

## 보안

### 1. Secure Storage

디바이스 ID와 Access Token은 `flutter_secure_storage`를 통해 안전하게 저장됩니다:

- **Android**: EncryptedSharedPreferences 사용
- **iOS**: Keychain 사용

### 2. 토큰 관리

- Access Token은 메모리와 Secure Storage에 저장
- 401 에러 시 자동으로 토큰 갱신 시도
- 갱신 실패 시 재로그인

## TODO: 서버 연동

현재 `AuthService`와 `ApiClient`는 목업 구현입니다.  
실제 서버 API 연동이 필요합니다:

### 1. 디바이스 로그인 API

```
POST /api/v1/users/device-login
Content-Type: application/json

{
  "device_id": "uuid-v4-string",
  "device_info": {
    "platform": "android",
    "model": "SM-G991N",
    "os_version": "13",
    ...
  },
  "app_id": "app.babycareai"
}

Response:
{
  "access_token": "jwt-token",
  "user_id": "uuid-string",
  "expires_in": 3600
}
```

### 2. 디바이스 등록 API

```
POST /api/v1/users/devices
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "device_id": "uuid-v4-string",
  "device_info": { ... },
  "platform": "android",
  "app_id": "app.babycareai"
}
```

### 3. 토큰 갱신 API

```
POST /api/v1/users/refresh-token
Authorization: Bearer {access_token}
X-Device-ID: {device_id}

Response:
{
  "access_token": "new-jwt-token",
  "expires_in": 3600
}
```

## 테스트

### 디바이스 초기화

테스트 목적으로 디바이스 ID를 초기화할 수 있습니다:

```dart
final authState = context.read<AuthState>();
await authState.resetDevice();

// 또는 직접
final deviceService = DeviceService();
await deviceService.resetDeviceId();
```

### 로그 확인

디버그 모드에서 디바이스 정보를 확인할 수 있습니다:

```dart
final deviceService = DeviceService();
final deviceId = await deviceService.getDeviceId();
final deviceInfo = await deviceService.getDeviceInfo();

print('Device ID: $deviceId');
print('Device Info: $deviceInfo');
```

## 향후 계획

### 1. 구글 계정 연동
- 디바이스 기반 인증 후 구글 계정 연결 기능 추가
- 여러 기기에서 동일 계정으로 데이터 동기화

### 2. 소셜 로그인 (선택적)
- Apple 로그인
- 카카오 로그인
- 네이버 로그인

### 3. 가족 계정 공유
- 여러 디바이스를 하나의 가족 계정으로 연결
- 권한 관리 (부모, 보호자 등)

## 문제 해결

### 디바이스 ID가 생성되지 않음

`flutter_secure_storage` 권한 문제일 수 있습니다:

**Android**: `android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
```

**iOS**: 추가 설정 불필요

### 토큰이 저장되지 않음

Secure Storage 초기화 문제일 수 있습니다:

```dart
// 강제 초기화
const storage = FlutterSecureStorage();
await storage.deleteAll();
```

### 인증 루프

AuthState가 무한 루프에 빠진 경우:

```dart
// AuthState의 _initializeAuth() 확인
// notifyListeners() 호출 횟수 체크
```

## 참고 자료

- [device_info_plus](https://pub.dev/packages/device_info_plus)
- [uuid](https://pub.dev/packages/uuid)
- [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
- [API 문서](./api-reference.md)
- [Authentication API 문서](./authentication-api.md)

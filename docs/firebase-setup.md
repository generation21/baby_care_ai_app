# Firebase 설정 가이드

## Android 설정

1. Firebase Console에서 Android 앱을 등록합니다.
2. `google-services.json` 파일을 다운로드합니다.
3. `android/app/` 디렉토리에 `google-services.json` 파일을 배치합니다.
4. `android/build.gradle.kts` 파일에 다음을 추가합니다:

```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

5. `android/app/build.gradle.kts` 파일 상단에 다음을 추가합니다:

```kotlin
plugins {
    id("com.google.gms.google-services")
}
```

## iOS 설정

1. Firebase Console에서 iOS 앱을 등록합니다.
2. `GoogleService-Info.plist` 파일을 다운로드합니다.
3. `ios/Runner/` 디렉토리에 `GoogleService-Info.plist` 파일을 배치합니다.
4. Xcode에서 프로젝트를 열고 `GoogleService-Info.plist` 파일을 프로젝트에 추가합니다.

## Flutter 코드 설정

`lib/main.dart`에서 Firebase 초기화를 추가합니다:

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // ... 나머지 코드
}
```

**참고**: 현재 프로젝트에서는 `firebase_auth` 패키지가 추가되어 있으나, 실제 Firebase 프로젝트 설정은 Firebase Console에서 완료해야 합니다.

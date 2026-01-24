# babycareai

# 앱 아이콘 및 스플래시 화면 적용 방법
## 앱 아이콘 적용 방법

assets/icons/icon.png 경로에 이미지를 추가하세요.

앱 아이콘 적용 시 아래 명령어를 입력하세요.

```
flutter pub run flutter_launcher_icons
```

## 스플래시 화면 적용 방법

assets/icons/splash12.png 경로에 이미지를 추가하세요.

스플래시 화면 적용 시 아래 명령어를 입력하세요.

```
flutter pub run flutter_native_splash:create
```

스플래시 화면 변경 시 아래 명령어를 입력하세요.

```
flutter pub run flutter_native_splash:remove

flutter clean
flutter pub get

flutter pub run flutter_native_splash:create
```

# 프로젝트 구조

### 주요 디렉토리 설명:
- clients: 외부 서비스와의 통신을 담당하는 클라이언트 모듈
- models: 앱에서 사용하는 데이터 구조 정의
- screens: 앱의 각 화면을 구성하는 위젯
- services: 비즈니스 로직을 처리하는 계층
- states: 앱의 상태 관리 로직
- theme: 앱의 디자인 시스템 정의
- utils: 유틸리티 함수 모음
- widgets: 여러 화면에서 재사용되는 공통 위젯

# 현재 적용된 기능
- 고객 문의/제안 기능 (Discord 연결)
- Supabase로 공지사항 띄우기
- 앱 (강제) 업데이트 안내 띄우기
- 설정창
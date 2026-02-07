# Baby Care API 사용 가이드

## 목차
1. [개요](#개요)
2. [Provider 사용법](#provider-사용법)
3. [서비스 사용법](#서비스-사용법)
4. [API 예제](#api-예제)
5. [Mock 서비스 vs 실제 API](#mock-서비스-vs-실제-api)

## 개요

Baby Care 앱은 다음과 같은 주요 기능을 제공합니다:
- **Baby Management**: 아기 정보 관리
- **Feeding Records**: 수유 기록 관리
- **Care Records**: 육아 기록 (수면, 기저귀, 체온, 약물, 활동) 관리
- **GPT Conversation**: AI 기반 육아 상담

## Provider 사용법

### 1. FeedingRecordProvider 사용

```dart
import 'package:provider/provider.dart';
import 'package:babycareai/states/feeding_record_provider.dart';

// 화면에서 Provider 사용
class FeedingRecordScreen extends StatefulWidget {
  final int babyId;

  const FeedingRecordScreen({required this.babyId});

  @override
  State<FeedingRecordScreen> createState() => _FeedingRecordScreenState();
}

class _FeedingRecordScreenState extends State<FeedingRecordScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 로드 시 데이터 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedingRecordProvider>().loadRecords(widget.babyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedingRecordProvider>(
      builder: (context, provider, child) {
        // 로딩 상태 처리
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // 에러 상태 처리
        if (provider.hasError) {
          return Center(child: Text('오류: ${provider.errorMessage}'));
        }

        // 빈 목록 처리
        if (provider.isEmpty) {
          return const Center(child: Text('수유 기록이 없습니다'));
        }

        // 데이터 표시
        return ListView.builder(
          itemCount: provider.records.length,
          itemBuilder: (context, index) {
            final record = provider.records[index];
            return ListTile(
              title: Text(record.feedingTypeInKorean),
              subtitle: Text('${record.amount ?? '-'}ml'),
              trailing: Text(
                DateFormat('HH:mm').format(record.recordedAtDateTime),
              ),
            );
          },
        );
      },
    );
  }
}
```

### 2. 수유 기록 생성

```dart
// 버튼 클릭 시 수유 기록 생성
Future<void> _createFeedingRecord() async {
  final provider = context.read<FeedingRecordProvider>();

  final success = await provider.createRecord(
    babyId: widget.babyId,
    feedingType: 'breast_milk',
    amount: 120.0,
    durationMinutes: 15,
    side: 'left',
    notes: '잘 먹었어요',
    recordedAt: DateTime.now(),
  );

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('수유 기록이 추가되었습니다')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('오류: ${provider.errorMessage}')),
    );
  }
}
```

### 3. CareRecordProvider 사용

```dart
// 수면 기록 생성
Future<void> _createSleepRecord() async {
  final provider = context.read<CareRecordProvider>();

  final success = await provider.createRecord(
    babyId: widget.babyId,
    recordType: 'sleep',
    sleepStart: DateTime.now().subtract(const Duration(hours: 2)),
    sleepEnd: DateTime.now(),
    sleepDurationMinutes: 120,
    notes: '낮잠',
  );

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('수면 기록이 추가되었습니다')),
    );
  }
}

// 기저귀 기록 생성
Future<void> _createDiaperRecord() async {
  final provider = context.read<CareRecordProvider>();

  final success = await provider.createRecord(
    babyId: widget.babyId,
    recordType: 'diaper',
    diaperType: 'wet',
    recordedAt: DateTime.now(),
  );

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('기저귀 기록이 추가되었습니다')),
    );
  }
}

// 체온 기록 생성
Future<void> _createTemperatureRecord() async {
  final provider = context.read<CareRecordProvider>();

  final success = await provider.createRecord(
    babyId: widget.babyId,
    recordType: 'temperature',
    temperature: 36.5,
    notes: '정상 체온',
    recordedAt: DateTime.now(),
  );

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('체온 기록이 추가되었습니다')),
    );
  }
}

// 기록 유형별 필터링
void _loadSleepRecordsOnly() {
  final provider = context.read<CareRecordProvider>();
  provider.loadRecords(widget.babyId, recordType: 'sleep');
}

// 수면 기록만 가져오기
List<CareRecord> sleepRecords = provider.sleepRecords;
```

### 4. GptProvider 사용

```dart
class GptChatScreen extends StatefulWidget {
  final int babyId;

  const GptChatScreen({required this.babyId});

  @override
  State<GptChatScreen> createState() => _GptChatScreenState();
}

class _GptChatScreenState extends State<GptChatScreen> {
  final TextEditingController _questionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 기존 대화 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GptProvider>().loadConversations(widget.babyId);
    });
  }

  // 질문 전송
  Future<void> _askQuestion() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) return;

    final provider = context.read<GptProvider>();
    _questionController.clear();

    final success = await provider.askQuestion(
      babyId: widget.babyId,
      question: question,
      contextDays: 7, // 최근 7일간의 데이터를 컨텍스트로 사용
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류: ${provider.errorMessage}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 육아 상담')),
      body: Consumer<GptProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // 대화 목록
              Expanded(
                child: provider.isEmpty
                    ? const Center(child: Text('질문을 입력해보세요'))
                    : ListView.builder(
                        reverse: true,
                        itemCount: provider.conversations.length,
                        itemBuilder: (context, index) {
                          final conversation = provider.conversations[index];
                          return Card(
                            margin: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Q: ${conversation.question}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('A: ${conversation.answer}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // 질문 입력
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _questionController,
                        decoration: const InputDecoration(
                          hintText: '질문을 입력하세요',
                          border: OutlineInputBorder(),
                        ),
                        enabled: !provider.isSending,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: provider.isSending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                      onPressed: provider.isSending ? null : _askQuestion,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }
}
```

## 서비스 사용법

Provider를 사용하지 않고 직접 서비스를 호출할 수도 있습니다:

```dart
import 'package:babycareai/services/feeding_record_service.dart';
import 'package:babycareai/services/care_record_service.dart';
import 'package:babycareai/services/gpt_service.dart';

// 서비스 인스턴스 가져오기
final feedingService = FeedingRecordService.instance;
final careService = CareRecordService.instance;
final gptService = GptService.instance;

// 수유 기록 가져오기
final feedingRecords = await feedingService.getFeedingRecords(
  babyId: 1,
  limit: 50,
);

// 오늘의 수유 기록만 가져오기
final todayFeeding = await feedingService.getTodayFeedingRecords(1);

// 최근 7일간의 육아 기록 가져오기
final recentCare = await careService.getRecentCareRecords(
  1,
  days: 7,
);

// GPT에게 질문하기
final conversation = await gptService.askQuestion(
  babyId: 1,
  question: '아기가 밤에 자주 깨는데 어떻게 해야 하나요?',
  contextDays: 7,
);
```

## API 예제

### Feeding Records API

```dart
// 1. 수유 기록 목록 조회
final records = await feedingService.getFeedingRecords(
  babyId: 1,
  limit: 20,
  offset: 0,
  startDate: '2024-01-01T00:00:00Z',
  endDate: '2024-01-31T23:59:59Z',
);

// 2. 특정 수유 기록 조회
final record = await feedingService.getFeedingRecord(recordId);

// 3. 수유 기록 생성
final newRecord = await feedingService.createFeedingRecord(
  babyId: 1,
  feedingType: 'breast_milk',
  amount: 120.0,
  durationMinutes: 15,
  side: 'left',
  notes: '잘 먹었어요',
  recordedAt: DateTime.now(),
);

// 4. 수유 기록 수정
final updatedRecord = await feedingService.updateFeedingRecord(
  recordId: 1,
  amount: 150.0,
  notes: '더 먹었어요',
);

// 5. 수유 기록 삭제
await feedingService.deleteFeedingRecord(recordId);
```

### Care Records API

```dart
// 1. 수면 기록 생성
final sleepRecord = await careService.createCareRecord(
  babyId: 1,
  recordType: 'sleep',
  sleepStart: DateTime.now().subtract(const Duration(hours: 2)),
  sleepEnd: DateTime.now(),
  sleepDurationMinutes: 120,
  notes: '낮잠',
);

// 2. 기저귀 기록 생성
final diaperRecord = await careService.createCareRecord(
  babyId: 1,
  recordType: 'diaper',
  diaperType: 'wet',
);

// 3. 체온 기록 생성
final tempRecord = await careService.createCareRecord(
  babyId: 1,
  recordType: 'temperature',
  temperature: 36.5,
  notes: '정상 체온',
);

// 4. 약물 기록 생성
final medicineRecord = await careService.createCareRecord(
  babyId: 1,
  recordType: 'medicine',
  medicineName: '타이레놀',
  medicineDosage: '5ml',
);

// 5. 활동 기록 생성
final activityRecord = await careService.createCareRecord(
  babyId: 1,
  recordType: 'activity',
  activityDescription: '목욕',
);

// 6. 특정 유형의 기록만 조회
final sleepRecords = await careService.getCareRecords(
  babyId: 1,
  recordType: 'sleep',
);
```

### GPT Conversation API

```dart
// 1. GPT에게 질문하기
final conversation = await gptService.askQuestion(
  babyId: 1,
  question: '아기가 밤에 자주 깨는데 어떻게 해야 하나요?',
  contextDays: 7, // 최근 7일간의 기록을 컨텍스트로 사용
);

print('질문: ${conversation.question}');
print('답변: ${conversation.answer}');

// 2. 대화 목록 조회
final conversationList = await gptService.getConversations(
  babyId: 1,
  limit: 20,
  offset: 0,
);

print('전체 대화 수: ${conversationList.total}');
for (var conv in conversationList.conversations) {
  print('Q: ${conv.question}');
  print('A: ${conv.answer}');
  print('---');
}

// 3. 최근 대화 조회
final recentConversations = await gptService.getRecentConversations(1);
```

## Mock 서비스 vs 실제 API

### Mock 서비스 사용 (개발 중)

`.env` 파일:
```env
USE_MOCK_SERVICE=true
API_BASE_URL=http://localhost:8000
```

Mock 서비스의 특징:
- ✅ 인터넷 연결 불필요
- ✅ 빠른 응답 시간 (네트워크 지연 시뮬레이션)
- ✅ 샘플 데이터 제공
- ✅ 오프라인 개발 가능
- ✅ GPT는 키워드 기반 자동 응답

### 실제 API 사용 (프로덕션)

`.env` 파일:
```env
USE_MOCK_SERVICE=false
API_BASE_URL=https://your-api-server.com
SUPABASE_URL=https://your-supabase-url.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

실제 API의 특징:
- ✅ 실제 데이터베이스 연동
- ✅ Supabase 인증
- ✅ 실제 GPT API 호출
- ✅ 데이터 영구 저장

### 자동 폴백

API 호출 실패 시 자동으로 Mock 서비스로 전환됩니다:

```dart
try {
  // 실제 API 호출 시도
  final records = await apiClient.getFeedingRecords(babyId: 1);
} catch (e) {
  // 실패 시 Mock 서비스로 자동 전환
  print('🔄 Switching to mock service');
  final records = await mockService.getFeedingRecords(babyId: 1);
}
```

## Enum 사용

### Feeding Type (수유 유형)

```dart
import 'package:babycareai/models/feeding_record.dart';

// Enum 사용
FeedingType.breastMilk.value;  // 'breast_milk'
FeedingType.formula.value;     // 'formula'
FeedingType.mixed.value;       // 'mixed'
FeedingType.solid.value;       // 'solid'

// 한국어 표시
FeedingType.breastMilk.displayName;  // '모유'
FeedingType.formula.displayName;     // '분유'

// 문자열에서 Enum으로 변환
final feedingType = FeedingType.fromString('breast_milk');
```

### Care Record Type (육아 기록 유형)

```dart
import 'package:babycareai/models/care_record.dart';

// Enum 사용
CareRecordType.sleep.value;        // 'sleep'
CareRecordType.diaper.value;       // 'diaper'
CareRecordType.temperature.value;  // 'temperature'
CareRecordType.medicine.value;     // 'medicine'
CareRecordType.activity.value;     // 'activity'

// 한국어 표시
CareRecordType.sleep.displayName;  // '수면'
CareRecordType.diaper.displayName; // '기저귀'
```

### Diaper Type (기저귀 유형)

```dart
// Enum 사용
DiaperType.wet.value;    // 'wet'
DiaperType.dirty.value;  // 'dirty'
DiaperType.both.value;   // 'both'
DiaperType.dry.value;    // 'dry'

// 한국어 표시
DiaperType.wet.displayName;   // '소변'
DiaperType.dirty.displayName; // '대변'
```

## 날짜 및 시간 처리

```dart
// DateTime을 ISO 8601 문자열로 변환
final dateString = DateTime.now().toIso8601String();

// ISO 8601 문자열을 DateTime으로 변환
final dateTime = DateTime.parse('2024-01-20T10:30:00Z');

// 날짜만 추출 (YYYY-MM-DD)
final dateOnly = DateTime.now().toIso8601String().split('T')[0];

// 오늘의 시작 시간
final startOfDay = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
);

// 오늘의 종료 시간
final endOfDay = startOfDay.add(const Duration(days: 1));
```

## 에러 처리

```dart
try {
  final records = await feedingService.getFeedingRecords(babyId: 1);
} on BabyApiException catch (e) {
  // API 예외 처리
  switch (e.type) {
    case BabyApiExceptionType.network:
      print('네트워크 오류: ${e.message}');
      break;
    case BabyApiExceptionType.unauthorized:
      print('인증 오류: ${e.message}');
      break;
    case BabyApiExceptionType.notFound:
      print('리소스를 찾을 수 없음: ${e.message}');
      break;
    default:
      print('오류: ${e.message}');
  }
} catch (e) {
  // 기타 예외 처리
  print('예기치 않은 오류: $e');
}
```

## 디버깅

### 로그 확인

콘솔에서 다음 로그를 확인할 수 있습니다:

```
🎭 Mock Service enabled from environment variable
📦 Using mock service for getFeedingRecords
🚀 Request: GET http://localhost:8000/baby-care/feeding-records
✅ Response: 200 http://localhost:8000/baby-care/feeding-records
❌ Error: Connection timeout
🔄 Switching to mock service
```

## 요약

1. **Provider 사용 권장**: UI에서는 Provider를 사용하여 상태 관리
2. **Mock 서비스**: 개발 중에는 Mock 서비스 사용
3. **에러 처리**: 항상 try-catch로 에러 처리
4. **Enum 활용**: 타입 안정성을 위해 Enum 사용
5. **날짜 처리**: ISO 8601 형식 사용

더 자세한 정보는 각 파일의 Dart Doc 주석을 참고하세요.

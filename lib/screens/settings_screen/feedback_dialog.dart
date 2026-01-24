import 'package:flutter/material.dart';

//  1단계: 문의 유형 선택(기능 제안, 버그 신고, 기타 등등)
//  2단계: 문의 내용입력
//  3단계: 연락받을 사용자 이메일 입력(선태 사항)
//  사용자로부터 받은 메세지를 디스코드로 받기

enum FeedbackCategory { featureSuggestion, bugReport, other }

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({super.key});

  static Future<Map<String, dynamic>?> show(BuildContext context) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => FeedbackDialog(),
    );
  }

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  int _currentStep = 0;
  FeedbackCategory _category = FeedbackCategory.featureSuggestion;
  String? _messageError;
  String? _emailError;
  final _messageController = TextEditingController();
  final _emailController = TextEditingController();

  // 타이틀 가져오기
  String _getTitle() {
    switch (_currentStep) {
      case 0:
        return '문의 유형';
      case 1:
        return '내용 입력';
      case 2:
        return '이메일 주소 (선택 사항)';
      default:
        return '';
    }
  }

  // // 컨텐츠 가져오기
  Widget _buildContent() {
    switch (_currentStep) {
      case 0:
        return _buildCategoryStepContent();
      case 1:
        return _buildMessageStepContent();
      case 2:
        return _buildEmailStepContent();
      default:
        return SizedBox();
    }
  }

  Widget _buildCategoryStepContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.lightbulb_outline),
          title: Text('기능 제안'),
          subtitle: Text('원하는 기능을 말씀해주세요'),
          onTap: () {
            setState(() {
              _category = FeedbackCategory.featureSuggestion;
              _currentStep++;
            });
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.bug_report_outlined),
          title: Text('버그 신고'),
          subtitle: Text('불편한 점을 말씀해주세요'),
          onTap: () {
            setState(() {
              _category = FeedbackCategory.bugReport;
              _currentStep++;
            });
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.question_mark_outlined),
          title: Text('기타 문의'),
          subtitle: Text('궁금한 점을 말씀해주세요'),
          onTap: () {
            setState(() {
              _category = FeedbackCategory.other;
              _currentStep++;
            });
          },
        ),
      ],
    );
  }

  Widget _buildMessageStepContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _messageController,
          autofocus: true,
          maxLength: 300,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText:
                '예시) 앱을 실행하면 화면이 깜빡이고 검은 화면이 나타납니다. 앱을 재시작해도 동일한 문제가 발생합니다.',
            hintStyle: TextStyle(color: Colors.grey),
            errorText: _messageError,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailStepContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _emailController,
          autofocus: true,
          maxLength: 100,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'example@email.com',
            hintStyle: TextStyle(color: Colors.grey),
            errorText: _emailError,
          ),
        ),
        SizedBox(height: 16),
        Text(
          '답변을 받으시려면 이메일 주소를 입력해주세요. 이메일 주소는 답변 용도 외에 사용되지 않습니다',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  // // 액션 가져오기
  List<Widget> _buildActions() {
    switch (_currentStep) {
      case 0:
        return _buildCategoryStepActions();
      case 1:
        return _buildMessageStepActions();
      case 2:
        return _buildEmailStepActions();
      default:
        return [];
    }
  }

  List<Widget> _buildCategoryStepActions() {
    return [
      TextButton(onPressed: () => Navigator.pop(context), child: Text('닫기')),
    ];
  }

  List<Widget> _buildMessageStepActions() {
    return [
      TextButton(
        onPressed: () => setState(() {
          _currentStep--;
        }),
        child: Text('이전'),
      ),
      TextButton(
        onPressed: () {
          final message = _messageController.text.trim();
          if (message.length < 5) {
            setState(() {
              _messageError = '5자 이상 입력해주세요';
            });
            return;
          }
          setState(() {
            _messageError = null;
            _currentStep++;
          });
        },
        child: Text('다음'),
      ),
    ];
  }

  List<Widget> _buildEmailStepActions() {
    return [
      TextButton(
        onPressed: () => setState(() {
          _currentStep--;
        }),
        child: Text('이전'),
      ),
      TextButton(
        onPressed: () {
          final email = _emailController.text.trim();
          if (email.isNotEmpty && !email.contains('@')) {
            setState(() {
              _emailError = '올바른 이메일 주소를 입력해주세요';
            });
            return;
          }
          Navigator.pop(context, {
            'category': _category,
            'message': _messageController.text.trim(),
            'email': _emailController.text.trim(),
          });
        },
        child: Text('제출'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(_getTitle()),
      content: _buildContent(),
      actions: _buildActions(),
    );
  }
}

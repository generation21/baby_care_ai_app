import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/gpt_conversation.dart';
import '../../states/baby_state.dart';
import '../../states/gpt_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/gpt/context_days_selector.dart';
import '../../widgets/gpt/question_input.dart';

class GPTQuestionScreen extends StatefulWidget {
  const GPTQuestionScreen({super.key});

  @override
  State<GPTQuestionScreen> createState() => _GPTQuestionScreenState();
}

class _GPTQuestionScreenState extends State<GPTQuestionScreen> {
  static const Duration _maxLoadingIndicatorDuration = Duration(seconds: 5);

  final TextEditingController _questionController = TextEditingController();
  int _contextDays = 7;
  int? _selectedBabyId;
  GPTConversation? _latestConversation;
  bool _showAskingIndicator = false;
  Timer? _loadingIndicatorTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureBabySelected();
    });
  }

  @override
  void dispose() {
    _loadingIndicatorTimer?.cancel();
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _ensureBabySelected() async {
    final babyState = context.read<BabyState>();
    if (babyState.babies.isEmpty) {
      try {
        await babyState.loadBabies();
      } catch (_) {
        // 에러는 state에서 처리
      }
    }

    if (!mounted) {
      return;
    }
    final firstBabyId = babyState.selectedBaby?.id ??
        (babyState.babies.isNotEmpty ? babyState.babies.first.id : null);
    setState(() {
      _selectedBabyId = firstBabyId;
    });
  }

  Future<void> _askQuestion() async {
    final selectedBabyId = _selectedBabyId;
    if (selectedBabyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('먼저 아이를 등록해주세요.')),
      );
      return;
    }

    final question = _questionController.text.trim();
    if (question.isEmpty) {
      return;
    }

    setState(() {
      _showAskingIndicator = true;
    });

    _loadingIndicatorTimer?.cancel();
    _loadingIndicatorTimer = Timer(_maxLoadingIndicatorDuration, () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showAskingIndicator = false;
      });
    });

    try {
      final conversation = await context.read<GPTState>().askQuestion(
            selectedBabyId,
            question: question,
            contextDays: _contextDays,
          );

      if (!mounted) {
        return;
      }
      setState(() {
        _latestConversation = conversation;
      });
      _questionController.clear();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('질문에 실패했습니다: $error')),
      );
    } finally {
      _loadingIndicatorTimer?.cancel();
      if (mounted) {
        setState(() {
          _showAskingIndicator = false;
        });
      }
    }
  }

  Future<void> _copyText(String label, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label 복사 완료')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final babyState = context.watch<BabyState>();
    final gptState = context.watch<GPTState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(
              title: 'GPT 질문',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.history),
                  tooltip: '대화 기록',
                  onPressed: _selectedBabyId == null
                      ? null
                      : () => context.push('/gpt/${_selectedBabyId!}/conversations'),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (babyState.babies.isNotEmpty)
                      DropdownButtonFormField<int>(
                        initialValue: _selectedBabyId,
                        decoration: const InputDecoration(labelText: '아이 선택'),
                        items: babyState.babies
                            .map(
                              (baby) => DropdownMenuItem<int>(
                                value: baby.id,
                                child: Text(baby.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedBabyId = value;
                          });
                        },
                      ),
                    if (babyState.babies.isNotEmpty) const SizedBox(height: 12),
                    ContextDaysSelector(
                      selectedDays: _contextDays,
                      onChanged: (value) {
                        setState(() {
                          _contextDays = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '최근 $_contextDays일 기록을 컨텍스트로 사용합니다.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_showAskingIndicator || gptState.isAsking)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'GPT 응답을 생성 중입니다...',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    if (_latestConversation != null) ...[
                      const SizedBox(height: 16),
                      _buildLatestConversation(_latestConversation!),
                    ],
                  ],
                ),
              ),
            ),
            QuestionInput(
              controller: _questionController,
              enabled: !gptState.isAsking,
              onSubmit: _askQuestion,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestConversation(GPTConversation conversation) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('질문', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              IconButton(
                onPressed: () => _copyText('질문', conversation.question),
                icon: const Icon(Icons.copy, size: 18),
                tooltip: '질문 복사',
              ),
            ],
          ),
          Text(
            conversation.question,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('GPT 응답', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              IconButton(
                onPressed: () => _copyText('응답', conversation.answer),
                icon: const Icon(Icons.copy, size: 18),
                tooltip: '응답 복사',
              ),
            ],
          ),
          MarkdownBody(
            data: conversation.answer,
            styleSheet: MarkdownStyleSheet(
              p: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

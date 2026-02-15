import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/gpt_conversation.dart';
import '../../states/gpt_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';

class GPTConversationDetailScreen extends StatefulWidget {
  final int babyId;
  final int conversationId;

  const GPTConversationDetailScreen({
    super.key,
    required this.babyId,
    required this.conversationId,
  });

  @override
  State<GPTConversationDetailScreen> createState() => _GPTConversationDetailScreenState();
}

class _GPTConversationDetailScreenState extends State<GPTConversationDetailScreen> {
  GPTConversation? _conversation;
  bool _isLoading = true;
  bool _isDeleting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  Future<void> _loadConversation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final conversation = await context.read<GPTState>().getConversation(
            widget.babyId,
            widget.conversationId,
          );
      if (!mounted) {
        return;
      }
      setState(() {
        _conversation = conversation;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = '대화 내용을 불러오지 못했습니다.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
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

  Future<void> _confirmAndDelete() async {
    if (_conversation == null || _isDeleting) {
      return;
    }
    final gptState = context.read<GPTState>();

    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('대화 삭제'),
            content: const Text('이 GPT 대화를 삭제하시겠어요?\n삭제 후 복구할 수 없습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
                child: const Text('삭제'),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldDelete) {
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      await gptState.deleteConversation(
            widget.babyId,
            widget.conversationId,
          );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('대화가 삭제되었습니다.')),
      );
      context.pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('삭제에 실패했습니다: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(
              title: '대화 상세',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              actions: [
                IconButton(
                  tooltip: '삭제',
                  onPressed: _isLoading || _conversation == null ? null : _confirmAndDelete,
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.error,
                ),
              ],
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null || _conversation == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage ?? '대화를 찾을 수 없습니다.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadConversation,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    final conversation = _conversation!;
    final createdAt = DateTime.tryParse(conversation.createdAt);
    final createdAtLabel = createdAt == null
        ? conversation.createdAt
        : DateFormat('yyyy-MM-dd HH:mm').format(createdAt);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            createdAtLabel,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          _buildQuestionCard(conversation.question),
          const SizedBox(height: 12),
          _buildAnswerCard(conversation.answer),
          if (_isDeleting) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String question) {
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
              Text(
                '질문',
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _copyText('질문', question),
                icon: const Icon(Icons.copy, size: 18),
              ),
            ],
          ),
          Text(question, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildAnswerCard(String answer) {
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
              Text(
                'GPT 응답',
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _copyText('응답', answer),
                icon: const Icon(Icons.copy, size: 18),
              ),
            ],
          ),
          MarkdownBody(
            data: answer,
            styleSheet: MarkdownStyleSheet(
              p: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

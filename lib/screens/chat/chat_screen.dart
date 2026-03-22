import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../states/baby_state.dart';
import '../../states/chat_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/chat/ai_disclaimer_bar.dart';
import '../../widgets/chat/chat_input_bar.dart';
import '../../widgets/chat/chat_message_bubble.dart';
import '../../widgets/chat/typing_indicator.dart';

/// 멀티턴 AI 채팅 화면
///
/// 세션이 없으면 자동 생성하고, 메시지를 주고받는 채팅 UI를 제공합니다.
class ChatScreen extends StatefulWidget {
  final int? sessionId;

  const ChatScreen({super.key, this.sessionId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int? _activeSessionId;
  bool _isCreatingSession = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  int? get _babyId {
    final babyState = context.read<BabyState>();
    return babyState.selectedBaby?.id ??
        (babyState.babies.isNotEmpty ? babyState.babies.first.id : null);
  }

  Future<void> _initialize() async {
    final babyState = context.read<BabyState>();
    if (babyState.babies.isEmpty) {
      try {
        await babyState.loadBabies();
      } catch (_) {}
    }

    if (!mounted) return;

    if (widget.sessionId != null) {
      _activeSessionId = widget.sessionId;
      final babyId = _babyId;
      if (babyId != null) {
        await context.read<ChatState>().loadSessionDetail(
          babyId,
          widget.sessionId!,
        );
        _scrollToBottom();
      }
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final babyId = _babyId;
    if (babyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('먼저 아이를 등록해주세요.')),
      );
      return;
    }

    final chatState = context.read<ChatState>();

    if (_activeSessionId == null) {
      setState(() => _isCreatingSession = true);
      try {
        final session = await chatState.createSession(babyId);
        _activeSessionId = session.id;
      } catch (_) {
        if (mounted) setState(() => _isCreatingSession = false);
        return;
      }
      if (mounted) setState(() => _isCreatingSession = false);
    }

    _messageController.clear();
    await chatState.sendMessage(
      babyId,
      _activeSessionId!,
      message: text,
    );

    if (mounted) _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _navigateToSessionList() {
    final babyId = _babyId;
    if (babyId == null) return;
    context.push('/chat/$babyId/sessions');
  }

  void _startNewChat() {
    final chatState = context.read<ChatState>();
    chatState.clearCurrentSession();
    setState(() => _activeSessionId = null);
  }

  @override
  Widget build(BuildContext context) {
    final chatState = context.watch<ChatState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(
              title: chatState.currentSession?.displayTitle ?? 'AI 상담',
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_comment_outlined),
                  tooltip: '새 대화',
                  onPressed: _startNewChat,
                ),
                IconButton(
                  icon: const Icon(Icons.history),
                  tooltip: '대화 기록',
                  onPressed: _navigateToSessionList,
                ),
              ],
            ),
            Expanded(child: _buildMessageArea(chatState)),
            if (chatState.isSending || _isCreatingSession)
              const TypingIndicator(),
            const AiDisclaimerBar(),
            ChatInputBar(
              controller: _messageController,
              enabled: !chatState.isSending && !_isCreatingSession,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageArea(ChatState chatState) {
    if (chatState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chatState.errorMessage != null && !chatState.hasMessages) {
      return _buildErrorState(chatState.errorMessage!);
    }

    if (!chatState.hasMessages && _activeSessionId == null) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      itemCount: chatState.messages.length,
      itemBuilder: (context, index) {
        return ChatMessageBubble(message: chatState.messages[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'AI 육아 상담',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '아이의 수유, 수면, 건강 등\n궁금한 것을 자유롭게 물어보세요.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildSuggestionChip('수유량이 줄었어요'),
                _buildSuggestionChip('밤에 자주 깨요'),
                _buildSuggestionChip('이유식 시작 시기'),
                _buildSuggestionChip('수면 패턴이 불규칙해요'),
              ],
            ),
            const SizedBox(height: 32),
            const AiDisclaimerBar(expanded: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary700),
      ),
      backgroundColor: AppColors.primary50,
      side: BorderSide(color: AppColors.primary100),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {
        _messageController.text = text;
        _sendMessage();
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final chatState = context.read<ChatState>();
                chatState.clearError();
                if (_activeSessionId != null && _babyId != null) {
                  chatState.loadSessionDetail(_babyId!, _activeSessionId!);
                }
              },
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}

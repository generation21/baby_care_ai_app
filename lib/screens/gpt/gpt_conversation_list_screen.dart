import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../states/gpt_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/gpt/conversation_card.dart';

class GPTConversationListScreen extends StatefulWidget {
  final int babyId;

  const GPTConversationListScreen({super.key, required this.babyId});

  @override
  State<GPTConversationListScreen> createState() =>
      _GPTConversationListScreenState();
}

class _GPTConversationListScreenState extends State<GPTConversationListScreen> {
  static const double _paginationTriggerOffset = 240;
  static const double _listCacheExtent = 800;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadConversations();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadConversations() async {
    await context.read<GPTState>().loadConversations(widget.babyId);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _paginationTriggerOffset) {
      context.read<GPTState>().loadMore(widget.babyId);
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
              title: 'GPT 대화 기록',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_comment_outlined),
                  tooltip: '새 질문',
                  onPressed: () => context.push('/ai-chat'),
                ),
              ],
            ),
            Expanded(
              child: Consumer<GPTState>(
                builder: (context, gptState, child) {
                  if (gptState.isLoading && gptState.conversations.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (gptState.errorMessage != null &&
                      gptState.conversations.isEmpty) {
                    return _buildErrorState(gptState.errorMessage!);
                  }
                  if (gptState.conversations.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: _loadConversations,
                    child: ListView.builder(
                      controller: _scrollController,
                      cacheExtent: _listCacheExtent,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                      itemCount: gptState.conversations.length + 1,
                      itemBuilder: (context, index) {
                        if (index == gptState.conversations.length) {
                          return _buildListFooter(gptState);
                        }
                        final conversation = gptState.conversations[index];
                        return ConversationCard(
                          conversation: conversation,
                          onTap: () => context.push(
                            '/gpt/${widget.babyId}/conversations/${conversation.id}',
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
              onPressed: _loadConversations,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              size: 72,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'GPT 대화 기록이 없습니다',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '질문을 보내면 대화 기록이 여기에 쌓입니다.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListFooter(GPTState gptState) {
    if (gptState.isLoading && gptState.conversations.isNotEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (!gptState.hasMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            '모든 대화 기록을 불러왔습니다.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

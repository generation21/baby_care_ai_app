import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../states/baby_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/baby/baby_card.dart';

class BabyListScreen extends StatefulWidget {
  const BabyListScreen({super.key});

  @override
  State<BabyListScreen> createState() => _BabyListScreenState();
}

class _BabyListScreenState extends State<BabyListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBabies();
    });
  }

  Future<void> _loadBabies() async {
    await context.read<BabyState>().loadBabies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(
              title: '아이 프로필',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/dashboard'),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: '아이 추가',
                  onPressed: () => context.push('/baby/add'),
                ),
              ],
            ),
            Expanded(
              child: Consumer<BabyState>(
                builder: (context, babyState, child) {
                  if (babyState.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (babyState.errorMessage != null) {
                    return _buildErrorState(
                      message: babyState.errorMessage!,
                      onRetry: _loadBabies,
                    );
                  }

                  if (babyState.babies.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: _loadBabies,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: babyState.babies.length,
                      itemBuilder: (context, index) {
                        final baby = babyState.babies[index];
                        return BabyCard(
                          baby: baby,
                          onTap: () => context.push('/baby/${baby.id}'),
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

  Widget _buildErrorState({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
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
              Icons.child_care,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              '등록된 아이가 없습니다',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '아이를 추가해주세요',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/baby/add'),
              icon: const Icon(Icons.add),
              label: const Text('아이 추가'),
            ),
          ],
        ),
      ),
    );
  }
}

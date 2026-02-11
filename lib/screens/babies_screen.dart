import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/baby.dart';
import '../states/baby_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_bar_widget.dart';

/// 아기 목록 화면
/// 
/// 등록된 모든 아기들의 목록을 보여줍니다.
class BabiesScreen extends StatefulWidget {
  const BabiesScreen({super.key});

  @override
  State<BabiesScreen> createState() => _BabiesScreenState();
}

class _BabiesScreenState extends State<BabiesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BabyState>().loadBabies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(
              title: '아이 목록',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/dashboard'),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => context.push('/add-child'),
                ),
              ],
            ),
            Expanded(
              child: Consumer<BabyState>(
                builder: (context, babyState, child) {
                  if (babyState.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (babyState.errorMessage != null) {
                    return Center(
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
                            babyState.errorMessage!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => babyState.loadBabies(),
                            child: const Text('다시 시도'),
                          ),
                        ],
                      ),
                    );
                  }

                  final babies = babyState.babies;
                  
                  if (babies.isEmpty) {
                    return Center(
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
                            onPressed: () => context.push('/add-child'),
                            icon: const Icon(Icons.add),
                            label: const Text('아이 추가'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: babies.length,
                    itemBuilder: (context, index) {
                      final baby = babies[index];
                      return _BabyListItem(
                        baby: baby,
                        onTap: () => context.push('/baby/${baby.id}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BabyListItem extends StatelessWidget {
  final Baby baby;
  final VoidCallback onTap;

  const _BabyListItem({
    required this.baby,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 아기 사진 또는 아이콘
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: baby.photo != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            baby.photo!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.child_care,
                                color: AppColors.primary,
                                size: 32,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.child_care,
                          color: AppColors.primary,
                          size: 32,
                        ),
                ),
                const SizedBox(width: 16),
                // 아기 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        baby.name,
                        style: AppTextStyles.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        baby.ageString,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (baby.gender != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              baby.gender == 'male' 
                                  ? Icons.male 
                                  : Icons.female,
                              size: 16,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              baby.gender == 'male' ? '남아' : '여아',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // 화살표
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

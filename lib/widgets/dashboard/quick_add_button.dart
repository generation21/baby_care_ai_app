import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// 빠른 기록 추가 플로팅 버튼
/// 
/// 대시보드 하단에 표시되는 빠른 추가 메뉴입니다.
class QuickAddButton extends StatelessWidget {
  final VoidCallback? onAddFeeding;
  final VoidCallback? onAddDiaper;
  final VoidCallback? onAddSleep;
  final VoidCallback? onAddHealth;

  const QuickAddButton({
    super.key,
    this.onAddFeeding,
    this.onAddDiaper,
    this.onAddSleep,
    this.onAddHealth,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showQuickAddMenu(context),
      backgroundColor: AppColors.primary,
      elevation: 4,
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  void _showQuickAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 핸들
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              // 제목
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text(
                      '빠른 기록 추가',
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // 메뉴 항목들
              _QuickAddMenuItem(
                icon: Icons.restaurant,
                label: '수유',
                color: AppColors.primary,
                onTap: () {
                  Navigator.pop(context);
                  onAddFeeding?.call();
                },
              ),
              _QuickAddMenuItem(
                icon: Icons.child_care,
                label: '기저귀',
                color: AppColors.accent,
                onTap: () {
                  Navigator.pop(context);
                  onAddDiaper?.call();
                },
              ),
              _QuickAddMenuItem(
                icon: Icons.nightlight_round,
                label: '수면',
                color: AppColors.info,
                onTap: () {
                  Navigator.pop(context);
                  onAddSleep?.call();
                },
              ),
              _QuickAddMenuItem(
                icon: Icons.favorite,
                label: '건강',
                color: AppColors.error,
                onTap: () {
                  Navigator.pop(context);
                  onAddHealth?.call();
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAddMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _QuickAddMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

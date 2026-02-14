import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// 좌/우 유방 선택 위젯
/// 
/// 현재 수유 중인 유방을 표시하고 전환할 수 있습니다.
class BreastSideSelector extends StatelessWidget {
  final String? currentSide;
  final Function(String) onSideChanged;

  const BreastSideSelector({
    super.key,
    required this.currentSide,
    required this.onSideChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Text(
            '수유 위치',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SideButton(
                  side: 'left',
                  label: '왼쪽',
                  icon: Icons.arrow_back,
                  isSelected: currentSide == 'left',
                  onTap: () => onSideChanged('left'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SideButton(
                  side: 'right',
                  label: '오른쪽',
                  icon: Icons.arrow_forward,
                  isSelected: currentSide == 'right',
                  onTap: () => onSideChanged('right'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 좌/우 선택 버튼
class _SideButton extends StatelessWidget {
  final String side;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SideButton({
    required this.side,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.primary : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

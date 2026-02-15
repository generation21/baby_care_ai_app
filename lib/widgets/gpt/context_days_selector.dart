import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ContextDaysSelector extends StatelessWidget {
  static const int minDays = 1;
  static const int maxDays = 30;

  final int selectedDays;
  final ValueChanged<int> onChanged;

  const ContextDaysSelector({
    super.key,
    required this.selectedDays,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Text(
            '컨텍스트 기간',
            style: AppTextStyles.bodyMedium,
          ),
          const Spacer(),
          DropdownButton<int>(
            value: selectedDays,
            underline: const SizedBox.shrink(),
            items: List.generate(
              maxDays - minDays + 1,
              (index) {
                final day = minDays + index;
                return DropdownMenuItem<int>(
                  value: day,
                  child: Text('$day일'),
                );
              },
            ),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ],
      ),
    );
  }
}

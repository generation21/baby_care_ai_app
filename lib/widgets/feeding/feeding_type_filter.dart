import 'package:flutter/material.dart';
import '../../models/feeding_record.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class FeedingTypeFilter extends StatelessWidget {
  static const String allValue = 'all';

  static const List<String> _orderedValues = <String>[
    allValue,
    'breast_milk',
    'formula',
    'pumping',
    'solid_food',
  ];

  final String selectedValue;
  final ValueChanged<String> onChanged;

  const FeedingTypeFilter({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _orderedValues
            .map(
              (value) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_labelForValue(value)),
                  selected: selectedValue == value,
                  onSelected: (_) => onChanged(value),
                  selectedColor: AppColors.primary50,
                  backgroundColor: AppColors.surface,
                  side: BorderSide(
                    color: selectedValue == value
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                  labelStyle: AppTextStyles.bodySmall.copyWith(
                    color: selectedValue == value
                        ? AppColors.primary700
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  static String? toApiValue(String selectedValue) {
    return selectedValue == allValue ? null : selectedValue;
  }

  String _labelForValue(String value) {
    switch (value) {
      case allValue:
        return '전체';
      case 'breast_milk':
        return FeedingType.breastMilk.displayName;
      case 'formula':
        return FeedingType.formula.displayName;
      case 'pumping':
        return FeedingType.pumping.displayName;
      case 'solid_food':
        return FeedingType.solidFood.displayName;
      default:
        return value;
    }
  }
}

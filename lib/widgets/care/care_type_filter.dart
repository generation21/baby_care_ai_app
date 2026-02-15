import 'package:flutter/material.dart';
import '../../models/care_record.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class CareTypeFilter extends StatelessWidget {
  static const String allValue = 'all';

  static const List<String> _orderedValues = <String>[
    allValue,
    'sleep',
    'diaper',
    'temperature',
    'medicine',
    'bath',
    'other',
  ];

  final String selectedValue;
  final ValueChanged<String> onChanged;

  const CareTypeFilter({
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
      case 'sleep':
        return CareRecordType.sleep.displayName;
      case 'diaper':
        return CareRecordType.diaper.displayName;
      case 'temperature':
        return CareRecordType.temperature.displayName;
      case 'medicine':
        return CareRecordType.medicine.displayName;
      case 'bath':
        return CareRecordType.bath.displayName;
      case 'other':
        return CareRecordType.other.displayName;
      default:
        return value;
    }
  }
}

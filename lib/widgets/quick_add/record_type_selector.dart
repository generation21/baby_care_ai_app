import 'package:flutter/material.dart';

/// 기록 유형
enum RecordType {
  breastMilk,
  formula,
  diaper,
  solidFood,
  pumping,
}

/// 기록 유형 확장 메서드
extension RecordTypeExtension on RecordType {
  /// 표시 이름
  String get displayName {
    switch (this) {
      case RecordType.breastMilk:
        return '모유';
      case RecordType.formula:
        return '분유';
      case RecordType.diaper:
        return '기저귀';
      case RecordType.solidFood:
        return '이유식';
      case RecordType.pumping:
        return '유축';
    }
  }

  /// 아이콘
  IconData get icon {
    switch (this) {
      case RecordType.breastMilk:
        return Icons.child_care;
      case RecordType.formula:
        return Icons.local_drink;
      case RecordType.diaper:
        return Icons.baby_changing_station;
      case RecordType.solidFood:
        return Icons.restaurant;
      case RecordType.pumping:
        return Icons.water_drop;
    }
  }

  /// 색상
  Color get color {
    switch (this) {
      case RecordType.breastMilk:
        return Colors.pink;
      case RecordType.formula:
        return Colors.blue;
      case RecordType.diaper:
        return Colors.orange;
      case RecordType.solidFood:
        return Colors.green;
      case RecordType.pumping:
        return Colors.purple;
    }
  }
}

/// 기록 유형 선택 위젯
/// 
/// 모유, 분유, 기저귀, 이유식, 유축 중 하나를 선택할 수 있습니다.
class RecordTypeSelector extends StatelessWidget {
  final RecordType selectedType;
  final Function(RecordType) onTypeSelected;

  const RecordTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: RecordType.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final type = RecordType.values[index];
          final isSelected = type == selectedType;

          return _TypeButton(
            type: type,
            isSelected: isSelected,
            onTap: () => onTypeSelected(type),
          );
        },
      ),
    );
  }
}

/// 기록 유형 버튼 위젯
class _TypeButton extends StatelessWidget {
  final RecordType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 70,
        decoration: BoxDecoration(
          color: isSelected ? type.color.withValues(alpha: 0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? type.color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type.icon,
              color: isSelected ? type.color : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              type.displayName,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? type.color : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

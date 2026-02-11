import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../screens/quick_add/quick_add_modal.dart';

/// 빠른 기록 추가 플로팅 버튼
/// 
/// 대시보드 하단에 표시되는 빠른 추가 메뉴입니다.
class QuickAddButton extends StatelessWidget {
  final int babyId;

  const QuickAddButton({
    super.key,
    required this.babyId,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showQuickAddModal(context, babyId),
      backgroundColor: AppColors.primary,
      elevation: 4,
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}

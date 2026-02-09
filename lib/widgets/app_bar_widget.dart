import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppBarWidget extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  const AppBarWidget({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Row(
        children: [
          if (leading != null) leading!,
          if (leading != null) const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.headline6,
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}

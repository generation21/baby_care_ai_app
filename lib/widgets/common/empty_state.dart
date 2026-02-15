import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  static const String _defaultTitle = '아직 데이터가 없어요';

  final String title;
  final String? description;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  const EmptyState({
    super.key,
    this.title = _defaultTitle,
    this.description,
    this.icon = Icons.inbox_outlined,
    this.actionText,
    this.onAction,
    this.padding = const EdgeInsets.all(AppDimensions.xl),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: AppColors.textDisabled),
          const SizedBox(height: AppDimensions.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headline6,
          ),
          if (description != null && description!.trim().isNotEmpty) ...[
            const SizedBox(height: AppDimensions.xs),
            Text(
              description!,
              textAlign: TextAlign.center,
              style: AppTextStyles.body2,
            ),
          ],
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: AppDimensions.lg),
            OutlinedButton(onPressed: onAction, child: Text(actionText!)),
          ],
        ],
      ),
    );
  }
}

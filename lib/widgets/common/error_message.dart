import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

class ErrorMessage extends StatelessWidget {
  static const String _defaultTitle = '문제가 발생했어요';
  static const String _defaultActionText = '다시 시도';

  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final String retryText;
  final IconData icon;
  final EdgeInsetsGeometry padding;

  const ErrorMessage({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.retryText = _defaultActionText,
    this.icon = Icons.error_outline_rounded,
    this.padding = const EdgeInsets.all(AppDimensions.md),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.error),
              const SizedBox(width: AppDimensions.xs),
              Expanded(
                child: Text(
                  title ?? _defaultTitle,
                  style: AppTextStyles.headline6.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            message,
            style: AppTextStyles.body2.copyWith(color: AppColors.textPrimary),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppDimensions.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: onRetry, child: Text(retryText)),
            ),
          ],
        ],
      ),
    );
  }
}

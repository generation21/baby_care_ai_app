import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

class LoadingIndicator extends StatelessWidget {
  static const double _defaultSize = 24;
  static const double _defaultStrokeWidth = 2.5;

  final String? message;
  final double size;
  final double strokeWidth;
  final Color? color;
  final bool center;

  const LoadingIndicator({
    super.key,
    this.message,
    this.size = _defaultSize,
    this.strokeWidth = _defaultStrokeWidth,
    this.color,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color ?? AppColors.primary,
      ),
    );

    final content = message == null
        ? indicator
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              indicator,
              const SizedBox(height: AppDimensions.sm),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          );

    return center ? Center(child: content) : content;
  }
}

import 'package:flutter/material.dart';

import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

enum CustomButtonVariant { filled, outlined, text }

class CustomButton extends StatelessWidget {
  static const double _loaderSize = 18;
  static const double _loaderStrokeWidth = 2;

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final CustomButtonVariant variant;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.variant = CustomButtonVariant.filled,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = isLoading
        ? const SizedBox(
            width: _loaderSize,
            height: _loaderSize,
            child: CircularProgressIndicator(strokeWidth: _loaderStrokeWidth),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: AppDimensions.iconSize - 4),
                const SizedBox(width: AppDimensions.xs),
              ],
              Text(label, style: AppTextStyles.button),
              if (trailingIcon != null) ...[
                const SizedBox(width: AppDimensions.xs),
                Icon(trailingIcon, size: AppDimensions.iconSize - 4),
              ],
            ],
          );

    final Widget button = switch (variant) {
      CustomButtonVariant.filled => ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: padding == null
            ? null
            : ElevatedButton.styleFrom(padding: padding),
        child: buttonChild,
      ),
      CustomButtonVariant.outlined => OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: padding == null
            ? null
            : OutlinedButton.styleFrom(padding: padding),
        child: buttonChild,
      ),
      CustomButtonVariant.text => TextButton(
        onPressed: isLoading ? null : onPressed,
        style: padding == null ? null : TextButton.styleFrom(padding: padding),
        child: buttonChild,
      ),
    };

    if (!fullWidth) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}

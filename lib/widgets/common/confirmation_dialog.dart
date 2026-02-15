import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  static const String _defaultConfirmText = '확인';
  static const String _defaultCancelText = '취소';

  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final bool isDanger;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = _defaultConfirmText,
    this.cancelText = _defaultCancelText,
    this.isDanger = false,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = _defaultConfirmText,
    String cancelText = _defaultCancelText,
    bool isDanger = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        isDanger: isDanger,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final confirmColor = isDanger ? colorScheme.error : colorScheme.primary;

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: confirmColor),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmText),
        ),
      ],
    );
  }
}

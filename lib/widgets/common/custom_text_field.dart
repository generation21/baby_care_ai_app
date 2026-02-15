import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CustomTextFieldType { text, number, decimal, multiline }

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final int? maxLength;
  final int minLines;
  final int maxLines;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final CustomTextFieldType type;

  const CustomTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.helperText,
    this.suffixIcon,
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,
    this.maxLength,
    this.minLines = 1,
    this.maxLines = 1,
    this.textInputAction,
    this.onChanged,
    this.onTap,
    this.validator,
    this.type = CustomTextFieldType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      enabled: enabled,
      obscureText: obscureText,
      maxLength: maxLength,
      minLines: _effectiveMinLines,
      maxLines: _effectiveMaxLines,
      keyboardType: _keyboardType,
      inputFormatters: _inputFormatters,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        suffixIcon: suffixIcon,
      ),
    );
  }

  int get _effectiveMinLines =>
      type == CustomTextFieldType.multiline ? minLines : 1;

  int get _effectiveMaxLines =>
      type == CustomTextFieldType.multiline ? maxLines : 1;

  TextInputType get _keyboardType {
    return switch (type) {
      CustomTextFieldType.number => TextInputType.number,
      CustomTextFieldType.decimal => const TextInputType.numberWithOptions(
        decimal: true,
      ),
      CustomTextFieldType.multiline => TextInputType.multiline,
      CustomTextFieldType.text => TextInputType.text,
    };
  }

  List<TextInputFormatter>? get _inputFormatters {
    return switch (type) {
      CustomTextFieldType.number => <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      CustomTextFieldType.decimal => <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      _ => null,
    };
  }
}

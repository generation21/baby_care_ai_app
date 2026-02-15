import 'package:flutter/material.dart';

import '../../utils/time_utils.dart';
import 'custom_text_field.dart';

enum DateTimePickerMode { date, time, dateTime }

class DateTimePicker extends StatefulWidget {
  final String labelText;
  final String hintText;
  final DateTimePickerMode mode;
  final DateTime? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;
  final String locale;
  final ValueChanged<DateTime>? onChanged;
  final String? Function(String?)? validator;

  const DateTimePicker({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.mode,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.locale = 'ko',
    this.onChanged,
    this.validator,
  });

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late final TextEditingController _controller;
  DateTime? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    _controller = TextEditingController(
      text: _formatDisplayValue(widget.initialValue),
    );
  }

  @override
  void didUpdateWidget(covariant DateTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _selectedValue = widget.initialValue;
      _controller.text = _formatDisplayValue(widget.initialValue);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      readOnly: true,
      enabled: widget.enabled,
      suffixIcon: Icon(_suffixIcon),
      onTap: _pick,
      validator: widget.validator,
    );
  }

  IconData get _suffixIcon {
    return switch (widget.mode) {
      DateTimePickerMode.date => Icons.calendar_today_outlined,
      DateTimePickerMode.time => Icons.access_time_outlined,
      DateTimePickerMode.dateTime => Icons.event_outlined,
    };
  }

  Future<void> _pick() async {
    if (!widget.enabled) {
      return;
    }

    final now = DateTime.now();
    final selectedValue = _selectedValue ?? now;
    DateTime? pickedValue;

    switch (widget.mode) {
      case DateTimePickerMode.date:
        pickedValue = await showDatePicker(
          context: context,
          initialDate: selectedValue,
          firstDate: widget.firstDate ?? DateTime(now.year - 30),
          lastDate: widget.lastDate ?? DateTime(now.year + 10),
        );
      case DateTimePickerMode.time:
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(selectedValue),
        );
        if (pickedTime != null) {
          pickedValue = DateTime(
            selectedValue.year,
            selectedValue.month,
            selectedValue.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        }
      case DateTimePickerMode.dateTime:
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedValue,
          firstDate: widget.firstDate ?? DateTime(now.year - 30),
          lastDate: widget.lastDate ?? DateTime(now.year + 10),
        );
        if (pickedDate == null) {
          break;
        }
        if (!mounted) {
          return;
        }
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(selectedValue),
        );
        if (pickedTime != null) {
          pickedValue = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        }
    }

    if (pickedValue == null) {
      return;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedValue = pickedValue;
      _controller.text = _formatDisplayValue(pickedValue);
    });
    widget.onChanged?.call(pickedValue);
  }

  String _formatDisplayValue(DateTime? value) {
    if (value == null) {
      return '';
    }
    return switch (widget.mode) {
      DateTimePickerMode.date => TimeUtils.formatDate(
        value,
        locale: widget.locale,
      ),
      DateTimePickerMode.time => TimeUtils.formatTime(
        value,
        locale: widget.locale,
      ),
      DateTimePickerMode.dateTime => TimeUtils.formatDateTime(
        value,
        locale: widget.locale,
      ),
    };
  }
}

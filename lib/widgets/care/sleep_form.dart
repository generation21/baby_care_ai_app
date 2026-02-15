import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/sleep_duration_utils.dart';

class CareSleepFormData {
  final DateTime sleepStart;
  final DateTime sleepEnd;
  final String? notes;
  final int durationMinutes;

  const CareSleepFormData({
    required this.sleepStart,
    required this.sleepEnd,
    required this.durationMinutes,
    this.notes,
  });
}

class CareSleepForm extends StatefulWidget {
  final bool enabled;
  final DateTime? initialSleepStart;
  final DateTime? initialSleepEnd;
  final String? initialNotes;
  final ValueChanged<CareSleepFormData?> onChanged;

  const CareSleepForm({
    super.key,
    required this.enabled,
    required this.onChanged,
    this.initialSleepStart,
    this.initialSleepEnd,
    this.initialNotes,
  });

  @override
  State<CareSleepForm> createState() => _CareSleepFormState();
}

class _CareSleepFormState extends State<CareSleepForm> {
  late DateTime _sleepStart;
  late DateTime _sleepEnd;
  late final TextEditingController _sleepStartController;
  late final TextEditingController _sleepEndController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _sleepEnd = widget.initialSleepEnd ?? now;
    _sleepStart = widget.initialSleepStart ?? _sleepEnd.subtract(const Duration(hours: 1));
    _sleepStartController = TextEditingController(text: _formatDateTime(_sleepStart));
    _sleepEndController = TextEditingController(text: _formatDateTime(_sleepEnd));
    _notesController = TextEditingController(text: widget.initialNotes ?? '');
    _notifyChanged();
  }

  @override
  void dispose() {
    _sleepStartController.dispose();
    _sleepEndController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickSleepStart() async {
    final picked = await _pickDateTime(_sleepStart);
    if (picked == null) {
      return;
    }
    setState(() {
      _sleepStart = picked;
      _sleepStartController.text = _formatDateTime(_sleepStart);
    });
    _notifyChanged();
  }

  Future<void> _pickSleepEnd() async {
    final picked = await _pickDateTime(_sleepEnd);
    if (picked == null) {
      return;
    }
    setState(() {
      _sleepEnd = picked;
      _sleepEndController.text = _formatDateTime(_sleepEnd);
    });
    _notifyChanged();
  }

  Future<DateTime?> _pickDateTime(DateTime initialValue) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialValue,
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime.now(),
    );
    if (selectedDate == null || !mounted) {
      return null;
    }

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialValue),
    );
    if (selectedTime == null) {
      return null;
    }

    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
  }

  void _notifyChanged() {
    final durationMinutes =
        SleepDurationUtils.calculateDurationMinutes(_sleepStart, _sleepEnd);
    if (durationMinutes == null) {
      widget.onChanged(null);
      return;
    }

    widget.onChanged(
      CareSleepFormData(
        sleepStart: _sleepStart,
        sleepEnd: _sleepEnd,
        durationMinutes: durationMinutes,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final durationLabel = SleepDurationUtils.formatDuration(_sleepStart, _sleepEnd);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _sleepStartController,
          enabled: widget.enabled,
          readOnly: true,
          onTap: _pickSleepStart,
          decoration: const InputDecoration(
            labelText: '수면 시작 시각',
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _sleepEndController,
          enabled: widget.enabled,
          readOnly: true,
          onTap: _pickSleepEnd,
          decoration: const InputDecoration(
            labelText: '수면 종료 시각',
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '자동 계산 수면 시간: $durationLabel',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _notesController,
          enabled: widget.enabled,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: '메모',
            hintText: '수면 관련 메모',
          ),
          onChanged: (_) => _notifyChanged(),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime value) {
    return DateFormat('yyyy-MM-dd HH:mm').format(value);
  }
}

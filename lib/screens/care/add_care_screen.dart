import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/care_record.dart';
import '../../states/care_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/care/diaper_form.dart';
import '../../widgets/care/medicine_form.dart';
import '../../widgets/care/sleep_form.dart';
import '../../widgets/care/temperature_form.dart';

class AddCareScreen extends StatefulWidget {
  final int babyId;

  const AddCareScreen({
    super.key,
    required this.babyId,
  });

  @override
  State<AddCareScreen> createState() => _AddCareScreenState();
}

class _AddCareScreenState extends State<AddCareScreen> {
  bool _isSubmitting = false;
  CareRecordType _selectedType = CareRecordType.diaper;
  DateTime _recordedAt = DateTime.now();

  CareDiaperFormData? _diaperFormData;
  CareSleepFormData? _sleepFormData;
  CareTemperatureFormData? _temperatureFormData;
  CareMedicineFormData? _medicineFormData;

  final TextEditingController _recordedAtController = TextEditingController();
  final TextEditingController _genericNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _recordedAtController.text = _formatDateTime(_recordedAt);
  }

  @override
  void dispose() {
    _recordedAtController.dispose();
    _genericNotesController.dispose();
    super.dispose();
  }

  Future<void> _selectRecordedAt() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _recordedAt,
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime.now(),
    );
    if (selectedDate == null || !mounted) {
      return;
    }
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_recordedAt),
    );
    if (selectedTime == null) {
      return;
    }

    setState(() {
      _recordedAt = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      _recordedAtController.text = _formatDateTime(_recordedAt);
    });
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting || !_isTypeFormValid()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final careState = context.read<CareState>();

      await careState.createCareRecord(
        widget.babyId,
        recordType: _selectedType,
        diaperType: _selectedType == CareRecordType.diaper
            ? _diaperFormData?.diaperType
            : null,
        sleepStart: _selectedType == CareRecordType.sleep
            ? _sleepFormData?.sleepStart.toIso8601String()
            : null,
        sleepEnd: _selectedType == CareRecordType.sleep
            ? _sleepFormData?.sleepEnd.toIso8601String()
            : null,
        temperature: _selectedType == CareRecordType.temperature
            ? _temperatureFormData?.temperature
            : null,
        temperatureUnit: _selectedType == CareRecordType.temperature
            ? _temperatureFormData?.temperatureUnit
            : null,
        medicineName: _selectedType == CareRecordType.medicine
            ? _medicineFormData?.medicineName
            : null,
        medicineDosage: _selectedType == CareRecordType.medicine
            ? _medicineFormData?.medicineDosage
            : null,
        notes: _resolveNotes(),
        recordedAt: _recordedAt.toIso8601String(),
      );

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('육아 기록이 생성되었습니다.')),
      );
      context.pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('생성에 실패했습니다: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(
              title: '육아 기록 추가',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<CareRecordType>(
                      initialValue: _selectedType,
                      decoration: const InputDecoration(labelText: '기록 타입'),
                      items: CareRecordType.values
                          .map(
                            (type) => DropdownMenuItem<CareRecordType>(
                              value: type,
                              child: Text(type.displayName),
                            ),
                          )
                          .toList(),
                      onChanged: _isSubmitting
                          ? null
                          : (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _selectedType = value;
                              });
                            },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _recordedAtController,
                      readOnly: true,
                      enabled: !_isSubmitting,
                      onTap: _selectRecordedAt,
                      decoration: const InputDecoration(
                        labelText: '기록 시각',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTypeSpecificForm(),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _handleSubmit,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('저장하기'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSpecificForm() {
    switch (_selectedType) {
      case CareRecordType.diaper:
        return CareDiaperForm(
          enabled: !_isSubmitting,
          onChanged: (data) => _diaperFormData = data,
        );
      case CareRecordType.sleep:
        return CareSleepForm(
          enabled: !_isSubmitting,
          onChanged: (data) => _sleepFormData = data,
        );
      case CareRecordType.temperature:
        return CareTemperatureForm(
          enabled: !_isSubmitting,
          onChanged: (data) => _temperatureFormData = data,
        );
      case CareRecordType.medicine:
        return CareMedicineForm(
          enabled: !_isSubmitting,
          onChanged: (data) => _medicineFormData = data,
        );
      case CareRecordType.bath:
      case CareRecordType.other:
        return TextFormField(
          controller: _genericNotesController,
          enabled: !_isSubmitting,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: '메모',
            hintText: '기록 내용을 입력하세요',
          ),
        );
    }
  }

  bool _isTypeFormValid() {
    switch (_selectedType) {
      case CareRecordType.diaper:
        return _diaperFormData != null;
      case CareRecordType.sleep:
        return _sleepFormData != null;
      case CareRecordType.temperature:
        return _temperatureFormData != null;
      case CareRecordType.medicine:
        return _medicineFormData != null;
      case CareRecordType.bath:
      case CareRecordType.other:
        return true;
    }
  }

  String? _resolveNotes() {
    switch (_selectedType) {
      case CareRecordType.diaper:
        return _diaperFormData?.notes;
      case CareRecordType.sleep:
        return _sleepFormData?.notes;
      case CareRecordType.temperature:
        return _temperatureFormData?.notes;
      case CareRecordType.medicine:
        return _medicineFormData?.notes;
      case CareRecordType.bath:
      case CareRecordType.other:
        final note = _genericNotesController.text.trim();
        return note.isEmpty ? null : note;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
}

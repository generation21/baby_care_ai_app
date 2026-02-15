import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/feeding_record.dart';
import '../../states/feeding_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_bar_widget.dart';

class AddFeedingScreen extends StatefulWidget {
  final int babyId;

  const AddFeedingScreen({
    super.key,
    required this.babyId,
  });

  @override
  State<AddFeedingScreen> createState() => _AddFeedingScreenState();
}

class _AddFeedingScreenState extends State<AddFeedingScreen> {
  bool _isSubmitting = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();

  FeedingType _selectedFeedingType = FeedingType.breastMilk;
  String? _selectedSide = 'left';
  DateTime _recordedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateTimeController.text = _formatDateTime(_recordedAt);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    _dateTimeController.dispose();
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
      _dateTimeController.text = _formatDateTime(_recordedAt);
    });
  }

  Future<void> _handleSubmit() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await context.read<FeedingState>().createFeedingRecord(
            widget.babyId,
            feedingType: _selectedFeedingType,
            amount: _parseIntOrNull(_amountController.text),
            unit: _parseIntOrNull(_amountController.text) == null ? null : 'ml',
            durationMinutes: _parseIntOrNull(_durationController.text),
            side: _requiresSide(_selectedFeedingType) ? _selectedSide : null,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
            recordedAt: _recordedAt.toIso8601String(),
          );

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('수유 기록이 생성되었습니다.')),
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
              title: '수유 기록 추가',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      DropdownButtonFormField<FeedingType>(
                        initialValue: _selectedFeedingType,
                        decoration: const InputDecoration(
                          labelText: '수유 타입',
                        ),
                        items: FeedingType.values
                            .map(
                              (type) => DropdownMenuItem<FeedingType>(
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
                                  _selectedFeedingType = value;
                                  if (!_requiresSide(value)) {
                                    _selectedSide = null;
                                  } else {
                                    _selectedSide ??= 'left';
                                  }
                                });
                              },
                      ),
                      const SizedBox(height: 12),
                      if (_requiresSide(_selectedFeedingType))
                        DropdownButtonFormField<String>(
                          initialValue: _selectedSide,
                          decoration: const InputDecoration(
                            labelText: '수유 부위',
                          ),
                          items: const [
                            DropdownMenuItem(value: 'left', child: Text('왼쪽')),
                            DropdownMenuItem(value: 'right', child: Text('오른쪽')),
                            DropdownMenuItem(value: 'both', child: Text('양쪽')),
                          ],
                          onChanged: _isSubmitting
                              ? null
                              : (value) {
                                  setState(() {
                                    _selectedSide = value;
                                  });
                                },
                          validator: (value) {
                            if (_requiresSide(_selectedFeedingType) && value == null) {
                              return '수유 부위를 선택해주세요.';
                            }
                            return null;
                          },
                        ),
                      if (_requiresSide(_selectedFeedingType))
                        const SizedBox(height: 12),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: '섭취량(ml)',
                          hintText: '예: 120',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null;
                          }
                          if (_parseIntOrNull(value) == null) {
                            return '숫자만 입력해주세요.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: '수유 시간(분)',
                          hintText: '예: 15',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null;
                          }
                          if (_parseIntOrNull(value) == null) {
                            return '숫자만 입력해주세요.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _dateTimeController,
                        readOnly: true,
                        onTap: _selectRecordedAt,
                        decoration: const InputDecoration(
                          labelText: '기록 시각',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _notesController,
                        minLines: 2,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: '메모',
                          hintText: '메모를 입력하세요',
                        ),
                      ),
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
            ),
          ],
        ),
      ),
    );
  }

  bool _requiresSide(FeedingType type) {
    return type == FeedingType.breastMilk;
  }

  int? _parseIntOrNull(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return int.tryParse(value.trim());
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
}

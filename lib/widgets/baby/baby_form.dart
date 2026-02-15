import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class BabyFormData {
  final String name;
  final DateTime birthDate;
  final String? gender;
  final String? notes;

  const BabyFormData({
    required this.name,
    required this.birthDate,
    this.gender,
    this.notes,
  });
}

class BabyForm extends StatefulWidget {
  final String title;
  final String submitButtonText;
  final bool isSubmitting;
  final String? initialName;
  final DateTime? initialBirthDate;
  final String? initialGender;
  final String? initialNotes;
  final Future<void> Function(BabyFormData formData) onSubmit;

  const BabyForm({
    super.key,
    required this.title,
    required this.submitButtonText,
    required this.isSubmitting,
    required this.onSubmit,
    this.initialName,
    this.initialBirthDate,
    this.initialGender,
    this.initialNotes,
  });

  @override
  State<BabyForm> createState() => _BabyFormState();
}

class _BabyFormState extends State<BabyForm> {
  static const double _contentPadding = 16;
  static const double _sectionSpacing = 16;
  static const int _maxBabyYears = 10;
  static const int _maxNotesLength = 500;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _notesController;

  DateTime? _selectedBirthDate;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _notesController = TextEditingController(text: widget.initialNotes ?? '');
    _selectedBirthDate = widget.initialBirthDate;
    _selectedGender = widget.initialGender;
    _birthDateController = TextEditingController(
      text: _formatDate(widget.initialBirthDate),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();
    final initialDate = _selectedBirthDate ?? now;
    final firstDate = DateTime(now.year - _maxBabyYears, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? now : initialDate,
      firstDate: firstDate,
      lastDate: now,
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedBirthDate = pickedDate;
      _birthDateController.text = _formatDate(pickedDate);
    });
  }

  Future<void> _handleSubmit() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }
    if (_selectedBirthDate == null) {
      return;
    }

    final formData = BabyFormData(
      name: _nameController.text.trim(),
      birthDate: _selectedBirthDate!,
      gender: _selectedGender,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
    await widget.onSubmit(formData);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(_contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNameField(),
            const SizedBox(height: _sectionSpacing),
            _buildBirthDateField(),
            const SizedBox(height: _sectionSpacing),
            _buildGenderField(),
            const SizedBox(height: _sectionSpacing),
            _buildNotesField(),
            const SizedBox(height: _sectionSpacing * 2),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      enabled: !widget.isSubmitting,
      decoration: _buildInputDecoration(
        labelText: '이름',
        hintText: '아이 이름을 입력하세요',
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        final trimmedValue = value?.trim() ?? '';
        if (trimmedValue.isEmpty) {
          return '이름을 입력해주세요.';
        }
        return null;
      },
    );
  }

  Widget _buildBirthDateField() {
    return TextFormField(
      controller: _birthDateController,
      enabled: !widget.isSubmitting,
      readOnly: true,
      onTap: _selectBirthDate,
      decoration: _buildInputDecoration(
        labelText: '생년월일',
        hintText: '날짜를 선택하세요',
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      validator: (_) {
        if (_selectedBirthDate == null) {
          return '생년월일을 선택해주세요.';
        }
        return null;
      },
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('성별', style: AppTextStyles.caption),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildGenderChip(label: '남아', value: 'male'),
            _buildGenderChip(label: '여아', value: 'female'),
            _buildGenderChip(label: '미선택', value: null),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderChip({required String label, required String? value}) {
    final isSelected = _selectedGender == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: widget.isSubmitting
          ? null
          : (_) {
              setState(() {
                _selectedGender = value;
              });
            },
      selectedColor: AppColors.primary50,
      labelStyle: AppTextStyles.bodySmall.copyWith(
        color: isSelected ? AppColors.primary700 : AppColors.textSecondary,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
      ),
      backgroundColor: AppColors.surface,
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      enabled: !widget.isSubmitting,
      minLines: 3,
      maxLines: 5,
      maxLength: _maxNotesLength,
      decoration: _buildInputDecoration(
        labelText: '메모',
        hintText: '아이에 대한 메모를 입력하세요',
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.isSubmitting ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: widget.isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(widget.submitButtonText),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      suffixIcon: suffixIcon,
      labelStyle: AppTextStyles.caption.copyWith(
        color: AppColors.textSecondary,
      ),
      hintStyle: AppTextStyles.bodySmall,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}

import 'package:flutter/material.dart';

class CareMedicineFormData {
  final String medicineName;
  final String medicineDosage;
  final String? notes;

  const CareMedicineFormData({
    required this.medicineName,
    required this.medicineDosage,
    this.notes,
  });
}

class CareMedicineForm extends StatefulWidget {
  final bool enabled;
  final String? initialMedicineName;
  final String? initialMedicineDosage;
  final String? initialNotes;
  final ValueChanged<CareMedicineFormData?> onChanged;

  const CareMedicineForm({
    super.key,
    required this.enabled,
    required this.onChanged,
    this.initialMedicineName,
    this.initialMedicineDosage,
    this.initialNotes,
  });

  @override
  State<CareMedicineForm> createState() => _CareMedicineFormState();
}

class _CareMedicineFormState extends State<CareMedicineForm> {
  late final TextEditingController _medicineNameController;
  late final TextEditingController _dosageController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _medicineNameController = TextEditingController(
      text: widget.initialMedicineName ?? '',
    );
    _dosageController = TextEditingController(
      text: widget.initialMedicineDosage ?? '',
    );
    _notesController = TextEditingController(text: widget.initialNotes ?? '');
    _notifyChanged();
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _notifyChanged() {
    final medicineName = _medicineNameController.text.trim();
    final medicineDosage = _dosageController.text.trim();
    if (medicineName.isEmpty || medicineDosage.isEmpty) {
      widget.onChanged(null);
      return;
    }

    widget.onChanged(
      CareMedicineFormData(
        medicineName: medicineName,
        medicineDosage: medicineDosage,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _medicineNameController,
          enabled: widget.enabled,
          decoration: const InputDecoration(
            labelText: '약 이름',
            hintText: '예: 해열제',
          ),
          onChanged: (_) => _notifyChanged(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _dosageController,
          enabled: widget.enabled,
          decoration: const InputDecoration(
            labelText: '복용량',
            hintText: '예: 2.5ml',
          ),
          onChanged: (_) => _notifyChanged(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _notesController,
          enabled: widget.enabled,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: '메모',
            hintText: '복약 관련 메모',
          ),
          onChanged: (_) => _notifyChanged(),
        ),
      ],
    );
  }
}

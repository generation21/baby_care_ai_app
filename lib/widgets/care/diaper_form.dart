import 'package:flutter/material.dart';
import '../../models/care_record.dart';

class CareDiaperFormData {
  final DiaperType diaperType;
  final String? notes;

  const CareDiaperFormData({
    required this.diaperType,
    this.notes,
  });
}

class CareDiaperForm extends StatefulWidget {
  final bool enabled;
  final DiaperType? initialDiaperType;
  final String? initialNotes;
  final ValueChanged<CareDiaperFormData> onChanged;

  const CareDiaperForm({
    super.key,
    required this.enabled,
    required this.onChanged,
    this.initialDiaperType,
    this.initialNotes,
  });

  @override
  State<CareDiaperForm> createState() => _CareDiaperFormState();
}

class _CareDiaperFormState extends State<CareDiaperForm> {
  late DiaperType _diaperType;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _diaperType = widget.initialDiaperType ?? DiaperType.wet;
    _notesController = TextEditingController(text: widget.initialNotes ?? '');
    _notifyChanged();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _notifyChanged() {
    widget.onChanged(
      CareDiaperFormData(
        diaperType: _diaperType,
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
        DropdownButtonFormField<DiaperType>(
          initialValue: _diaperType,
          decoration: const InputDecoration(labelText: '기저귀 타입'),
          items: DiaperType.values
              .map(
                (type) => DropdownMenuItem<DiaperType>(
                  value: type,
                  child: Text(type.displayName),
                ),
              )
              .toList(),
          onChanged: widget.enabled
              ? (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _diaperType = value;
                  });
                  _notifyChanged();
                }
              : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _notesController,
          enabled: widget.enabled,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: '메모',
            hintText: '기저귀 상태 메모',
          ),
          onChanged: (_) => _notifyChanged(),
        ),
      ],
    );
  }
}

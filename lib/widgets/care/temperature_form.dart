import 'package:flutter/material.dart';

class CareTemperatureFormData {
  final double temperature;
  final String temperatureUnit;
  final String? notes;

  const CareTemperatureFormData({
    required this.temperature,
    required this.temperatureUnit,
    this.notes,
  });
}

class CareTemperatureForm extends StatefulWidget {
  final bool enabled;
  final double? initialTemperature;
  final String? initialTemperatureUnit;
  final String? initialNotes;
  final ValueChanged<CareTemperatureFormData?> onChanged;

  const CareTemperatureForm({
    super.key,
    required this.enabled,
    required this.onChanged,
    this.initialTemperature,
    this.initialTemperatureUnit,
    this.initialNotes,
  });

  @override
  State<CareTemperatureForm> createState() => _CareTemperatureFormState();
}

class _CareTemperatureFormState extends State<CareTemperatureForm> {
  late final TextEditingController _temperatureController;
  late final TextEditingController _notesController;
  late String _temperatureUnit;

  @override
  void initState() {
    super.initState();
    _temperatureController = TextEditingController(
      text: widget.initialTemperature?.toString() ?? '',
    );
    _notesController = TextEditingController(text: widget.initialNotes ?? '');
    _temperatureUnit = widget.initialTemperatureUnit ?? 'C';
    _notifyChanged();
  }

  @override
  void dispose() {
    _temperatureController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _notifyChanged() {
    final temperature = double.tryParse(_temperatureController.text.trim());
    if (temperature == null) {
      widget.onChanged(null);
      return;
    }

    widget.onChanged(
      CareTemperatureFormData(
        temperature: temperature,
        temperatureUnit: _temperatureUnit,
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
          controller: _temperatureController,
          enabled: widget.enabled,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: '체온',
            hintText: '예: 36.8',
          ),
          onChanged: (_) => _notifyChanged(),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _temperatureUnit,
          decoration: const InputDecoration(labelText: '단위'),
          items: const [
            DropdownMenuItem(value: 'C', child: Text('섭씨 (C)')),
            DropdownMenuItem(value: 'F', child: Text('화씨 (F)')),
          ],
          onChanged: widget.enabled
              ? (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _temperatureUnit = value;
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
            hintText: '체온 관련 메모',
          ),
          onChanged: (_) => _notifyChanged(),
        ),
      ],
    );
  }
}

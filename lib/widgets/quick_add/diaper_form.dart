import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/care_record.dart';
import '../../states/care_state.dart';

/// 기저귀 교체 빠른 입력 폼
/// 
/// 기저귀 교체 기록을 빠르게 추가할 수 있는 폼입니다.
class DiaperForm extends StatefulWidget {
  final int babyId;
  final VoidCallback onSaved;

  const DiaperForm({
    super.key,
    required this.babyId,
    required this.onSaved,
  });

  @override
  State<DiaperForm> createState() => _DiaperFormState();
}

class _DiaperFormState extends State<DiaperForm> {
  final _formKey = GlobalKey<FormState>();
  DiaperType? _diaperType;
  String? _notes;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 기저귀 타입 선택
          const Text(
            '기저귀 종류',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              _DiaperTypeButton(
                type: DiaperType.wet,
                icon: Icons.water_drop,
                label: '소변',
                color: Colors.yellow[700]!,
                isSelected: _diaperType == DiaperType.wet,
                onTap: () => setState(() => _diaperType = DiaperType.wet),
              ),
              const SizedBox(height: 8),
              _DiaperTypeButton(
                type: DiaperType.dirty,
                icon: Icons.circle,
                label: '대변',
                color: Colors.brown,
                isSelected: _diaperType == DiaperType.dirty,
                onTap: () => setState(() => _diaperType = DiaperType.dirty),
              ),
              const SizedBox(height: 8),
              _DiaperTypeButton(
                type: DiaperType.both,
                icon: Icons.spa,
                label: '소변+대변',
                color: Colors.orange,
                isSelected: _diaperType == DiaperType.both,
                onTap: () => setState(() => _diaperType = DiaperType.both),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 메모
          TextFormField(
            decoration: const InputDecoration(
              labelText: '메모 (선택사항)',
              hintText: '예: 정상적인 변',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            onChanged: (value) {
              _notes = value.isEmpty ? null : value;
            },
          ),
          
          const SizedBox(height: 24),
          
          // 저장 버튼
          ElevatedButton(
            onPressed: _isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    '저장',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  /// 폼 제출 처리
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_diaperType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('기저귀 종류를 선택해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final careState = context.read<CareState>();
      await careState.createCareRecord(
        widget.babyId,
        recordType: CareRecordType.diaper,
        diaperType: _diaperType,
        notes: _notes,
        recordedAt: DateTime.now().toIso8601String(),
      );

      widget.onSaved();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('기록 저장 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

/// 기저귀 타입 선택 버튼
class _DiaperTypeButton extends StatelessWidget {
  final DiaperType type;
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _DiaperTypeButton({
    required this.type,
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[600],
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? color : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

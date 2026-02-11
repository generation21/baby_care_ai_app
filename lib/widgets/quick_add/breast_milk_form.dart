import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/feeding_record.dart';
import '../../states/feeding_state.dart';

/// 모유 수유 빠른 입력 폼
/// 
/// 모유 수유 기록을 빠르게 추가할 수 있는 폼입니다.
class BreastMilkForm extends StatefulWidget {
  final int babyId;
  final VoidCallback onSaved;

  const BreastMilkForm({
    super.key,
    required this.babyId,
    required this.onSaved,
  });

  @override
  State<BreastMilkForm> createState() => _BreastMilkFormState();
}

class _BreastMilkFormState extends State<BreastMilkForm> {
  final _formKey = GlobalKey<FormState>();
  String? _side;
  int? _durationMinutes;
  String? _notes;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 좌/우 선택
          const Text(
            '수유 위치',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SideButton(
                  label: '왼쪽',
                  icon: Icons.arrow_back,
                  isSelected: _side == 'left',
                  onTap: () => setState(() => _side = 'left'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SideButton(
                  label: '오른쪽',
                  icon: Icons.arrow_forward,
                  isSelected: _side == 'right',
                  onTap: () => setState(() => _side = 'right'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SideButton(
                  label: '양쪽',
                  icon: Icons.compare_arrows,
                  isSelected: _side == 'both',
                  onTap: () => setState(() => _side = 'both'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 수유 시간 (분)
          TextFormField(
            decoration: const InputDecoration(
              labelText: '수유 시간 (분)',
              hintText: '예: 15',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _durationMinutes = int.tryParse(value);
            },
          ),
          
          const SizedBox(height: 16),
          
          // 메모
          TextFormField(
            decoration: const InputDecoration(
              labelText: '메모 (선택사항)',
              hintText: '예: 배가 고파 보였어요',
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
              backgroundColor: Colors.pink,
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

    if (_side == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('수유 위치를 선택해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final feedingState = context.read<FeedingState>();
      await feedingState.createFeedingRecord(
        widget.babyId,
        feedingType: FeedingType.breastMilk,
        side: _side,
        durationMinutes: _durationMinutes,
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

/// 좌/우/양쪽 선택 버튼
class _SideButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SideButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.pink.withValues(alpha: 0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.pink : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.pink : Colors.grey[600],
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.pink : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/feeding_record.dart';
import '../../states/feeding_state.dart';

/// 이유식 빠른 입력 폼
/// 
/// 이유식 기록을 빠르게 추가할 수 있는 폼입니다.
class SolidForm extends StatefulWidget {
  final int babyId;
  final VoidCallback onSaved;

  const SolidForm({
    super.key,
    required this.babyId,
    required this.onSaved,
  });

  @override
  State<SolidForm> createState() => _SolidFormState();
}

class _SolidFormState extends State<SolidForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _unit = 'g';
  String? _notes;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 양 입력
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: '양 (선택사항)',
                    hintText: '예: 100',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _unit,
                  decoration: const InputDecoration(
                    labelText: '단위',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'g', child: Text('g')),
                    DropdownMenuItem(value: 'ml', child: Text('ml')),
                    DropdownMenuItem(value: '공기', child: Text('공기')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _unit = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 빠른 선택 버튼 (g 단위일 때만)
          if (_unit == 'g') ...[
            const Text(
              '빠른 선택',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _QuickAmountButton(
                  amount: 50,
                  unit: _unit,
                  onTap: () => _amountController.text = '50',
                ),
                _QuickAmountButton(
                  amount: 100,
                  unit: _unit,
                  onTap: () => _amountController.text = '100',
                ),
                _QuickAmountButton(
                  amount: 150,
                  unit: _unit,
                  onTap: () => _amountController.text = '150',
                ),
                _QuickAmountButton(
                  amount: 200,
                  unit: _unit,
                  onTap: () => _amountController.text = '200',
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          
          // 메모
          TextFormField(
            decoration: const InputDecoration(
              labelText: '메모 (선택사항)',
              hintText: '예: 당근죽, 잘 먹었어요',
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
              backgroundColor: Colors.green,
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

    setState(() => _isLoading = true);

    try {
      final feedingState = context.read<FeedingState>();
      final amount = _amountController.text.isEmpty 
          ? null 
          : int.tryParse(_amountController.text);
      
      await feedingState.createFeedingRecord(
        widget.babyId,
        feedingType: FeedingType.solidFood,
        amount: amount,
        unit: _unit,
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

/// 빠른 양 선택 버튼
class _QuickAmountButton extends StatelessWidget {
  final int amount;
  final String unit;
  final VoidCallback onTap;

  const _QuickAmountButton({
    required this.amount,
    required this.unit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green),
        ),
        child: Text(
          '$amount$unit',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}

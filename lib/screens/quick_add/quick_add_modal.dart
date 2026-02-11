import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../states/dashboard_state.dart';
import '../../widgets/quick_add/record_type_selector.dart';
import '../../widgets/quick_add/breast_milk_form.dart';
import '../../widgets/quick_add/formula_form.dart';
import '../../widgets/quick_add/diaper_form.dart';
import '../../widgets/quick_add/solid_form.dart';
import '../../widgets/quick_add/pumping_form.dart';

/// 빠른 기록 추가 모달
/// 
/// 대시보드에서 원클릭으로 기록을 추가할 수 있는 바텀시트 모달입니다.
class QuickAddModal extends StatefulWidget {
  final int babyId;

  const QuickAddModal({
    super.key,
    required this.babyId,
  });

  @override
  State<QuickAddModal> createState() => _QuickAddModalState();
}

class _QuickAddModalState extends State<QuickAddModal> {
  RecordType _selectedType = RecordType.breastMilk;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 핸들
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // 헤더
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  '빠른 기록 추가',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // 기록 유형 선택
          Padding(
            padding: const EdgeInsets.all(16),
            child: RecordTypeSelector(
              selectedType: _selectedType,
              onTypeSelected: (type) {
                setState(() {
                  _selectedType = type;
                });
              },
            ),
          ),
          
          // 선택된 유형에 따른 입력 폼
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildForm(),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// 선택된 기록 유형에 따른 입력 폼 위젯 빌드
  Widget _buildForm() {
    switch (_selectedType) {
      case RecordType.breastMilk:
        return BreastMilkForm(
          babyId: widget.babyId,
          onSaved: _handleSaved,
        );
      case RecordType.formula:
        return FormulaForm(
          babyId: widget.babyId,
          onSaved: _handleSaved,
        );
      case RecordType.diaper:
        return DiaperForm(
          babyId: widget.babyId,
          onSaved: _handleSaved,
        );
      case RecordType.solidFood:
        return SolidForm(
          babyId: widget.babyId,
          onSaved: _handleSaved,
        );
      case RecordType.pumping:
        return PumpingForm(
          babyId: widget.babyId,
          onSaved: _handleSaved,
        );
    }
  }

  /// 기록 저장 완료 핸들러
  void _handleSaved() {
    // 대시보드 자동 갱신
    context.read<DashboardState>().loadDashboard(widget.babyId);
    
    // 모달 닫기
    Navigator.pop(context);
    
    // 성공 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedType.displayName} 기록이 추가되었습니다'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// 빠른 기록 추가 모달 표시 함수
void showQuickAddModal(BuildContext context, int babyId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: QuickAddModal(babyId: babyId),
      ),
    ),
  );
}

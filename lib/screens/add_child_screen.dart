import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/baby_service.dart';
import '../states/auth_state.dart';
import '../theme/app_colors.dart';
import '../widgets/segmented_control.dart';

/// 아이 등록 화면
class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _noteController = TextEditingController();

  String _selectedGender = 'male';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  /// 생년월일 선택
  Future<void> _selectBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _birthDateController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  /// 아이 등록 처리
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('🔵 아이 등록 시작');
      final authState = Provider.of<AuthState>(context, listen: false);
      final babyCareApi = authState.babyCareApi;
      final babyService = BabyService(babyCareApi);

      final birthDate = DateTime.parse(_birthDateController.text);
      final birthHeight = _heightController.text.isNotEmpty
          ? double.tryParse(_heightController.text)
          : null;
      final birthWeight = _weightController.text.isNotEmpty
          ? double.tryParse(_weightController.text)
          : null;
      final notes = _noteController.text.trim().isNotEmpty
          ? _noteController.text.trim()
          : null;

      debugPrint('📤 POST 요청 데이터:');
      debugPrint('  - name: ${_nameController.text.trim()}');
      debugPrint('  - birthDate: $birthDate');
      debugPrint('  - gender: $_selectedGender');
      debugPrint('  - birthHeight: $birthHeight');
      debugPrint('  - birthWeight: $birthWeight');
      debugPrint('  - notes: $notes');

      final result = await babyService.createBaby(
        name: _nameController.text.trim(),
        birthDate: birthDate,
        gender: _selectedGender,
        birthHeight: birthHeight,
        birthWeight: birthWeight,
        notes: notes,
      );

      debugPrint('✅ 아이 등록 성공: ${result.id}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('아이 등록이 완료되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      debugPrint('❌ 아이 등록 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('등록 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '아이 등록',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppColors.borderLight,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이름 입력
              _buildTextField(
                label: '이름',
                controller: _nameController,
                placeholder: '아이 이름을 입력하세요',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '이름을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 생년월일 입력
              _buildTextField(
                label: '생년월일',
                controller: _birthDateController,
                placeholder: 'YYYY-MM-DD',
                readOnly: true,
                onTap: _selectBirthDate,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '생년월일을 선택해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 성별 선택
              const Text(
                '성별',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              SegmentedControl(
                options: const ['남아', '여아'],
                selectedOption: _selectedGender == 'male' ? '남아' : '여아',
                onChanged: (option) {
                  setState(() {
                    _selectedGender = option == '남아' ? 'male' : 'female';
                  });
                },
              ),
              const SizedBox(height: 16),

              // 키 입력
              _buildTextField(
                label: '키 (cm)',
                controller: _heightController,
                placeholder: '예: 50',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // 몸무게 입력
              _buildTextField(
                label: '몸무게 (kg)',
                controller: _weightController,
                placeholder: '예: 3.5',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // 메모 입력
              const Text(
                '메모',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _noteController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: '아이에 대한 메모를 입력하세요',
                    hintStyle: TextStyle(
                      color: AppColors.textDisabled,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 등록하기 버튼
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          '등록하기',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 텍스트 필드 위젯 빌더
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                color: AppColors.textDisabled,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

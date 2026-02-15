import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../states/baby_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/baby/baby_form.dart';

class AddBabyScreen extends StatefulWidget {
  const AddBabyScreen({super.key});

  @override
  State<AddBabyScreen> createState() => _AddBabyScreenState();
}

class _AddBabyScreenState extends State<AddBabyScreen> {
  bool _isSubmitting = false;

  Future<void> _handleCreate(BabyFormData formData) async {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await context.read<BabyState>().createBaby(
            name: formData.name,
            birthDate: _toApiDateString(formData.birthDate),
            gender: formData.gender,
            bloodType: formData.bloodType,
            notes: formData.notes == null ? null : {'memo': formData.notes},
          );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이 프로필이 생성되었습니다.')),
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
              title: '아이 추가',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            Expanded(
              child: BabyForm(
                title: '아이 추가',
                submitButtonText: '추가하기',
                isSubmitting: _isSubmitting,
                onSubmit: _handleCreate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _toApiDateString(DateTime dateTime) {
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '${dateTime.year}-$month-$day';
  }
}

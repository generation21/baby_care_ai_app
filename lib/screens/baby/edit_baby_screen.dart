import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/baby.dart';
import '../../states/baby_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/baby/baby_form.dart';

class EditBabyScreen extends StatefulWidget {
  final int babyId;

  const EditBabyScreen({
    super.key,
    required this.babyId,
  });

  @override
  State<EditBabyScreen> createState() => _EditBabyScreenState();
}

class _EditBabyScreenState extends State<EditBabyScreen> {
  Baby? _baby;
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBaby();
  }

  Future<void> _loadBaby() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final babyState = context.read<BabyState>();
      final loadedBaby = await babyState.getBaby(widget.babyId);
      if (!mounted) {
        return;
      }
      setState(() {
        _baby = loadedBaby;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = '아이 정보를 불러오지 못했습니다.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleUpdate(BabyFormData formData) async {
    if (_isSubmitting) {
      return;
    }
    setState(() {
      _isSubmitting = true;
    });

    try {
      await context.read<BabyState>().updateBaby(
            widget.babyId,
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
        const SnackBar(content: Text('아이 프로필이 수정되었습니다.')),
      );
      context.pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('수정에 실패했습니다: $error')),
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
              title: '아이 정보 수정',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null || _baby == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage ?? '아이 정보를 찾을 수 없습니다.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadBaby,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    final birthDate = DateTime.tryParse(_baby!.birthDate);
    final memo = _extractMemo(_baby!.notes);

    return BabyForm(
      title: '아이 정보 수정',
      submitButtonText: '저장하기',
      isSubmitting: _isSubmitting,
      initialName: _baby!.name,
      initialBirthDate: birthDate,
      initialGender: _baby!.gender,
      initialBloodType: _baby!.bloodType,
      initialNotes: memo,
      onSubmit: _handleUpdate,
    );
  }

  String _toApiDateString(DateTime dateTime) {
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '${dateTime.year}-$month-$day';
  }

  String? _extractMemo(Map<String, dynamic>? notes) {
    if (notes == null || notes.isEmpty) {
      return null;
    }
    final memo = notes['memo'];
    if (memo is String && memo.trim().isNotEmpty) {
      return memo.trim();
    }
    return notes.toString();
  }
}

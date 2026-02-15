import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/baby.dart';
import '../../states/baby_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/baby_age_utils.dart';
import '../../widgets/app_bar_widget.dart';

class BabyDetailScreen extends StatefulWidget {
  final int babyId;

  const BabyDetailScreen({
    super.key,
    required this.babyId,
  });

  @override
  State<BabyDetailScreen> createState() => _BabyDetailScreenState();
}

class _BabyDetailScreenState extends State<BabyDetailScreen> {
  Baby? _baby;
  bool _isLoading = true;
  bool _isDeleting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBabyDetail();
  }

  Future<void> _loadBabyDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final baby = await context.read<BabyState>().getBaby(widget.babyId);
      if (!mounted) {
        return;
      }
      setState(() {
        _baby = baby;
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

  Future<void> _moveToEditScreen() async {
    await context.push('/baby/${widget.babyId}/edit');
    if (!mounted) {
      return;
    }
    await _loadBabyDetail();
  }

  Future<void> _confirmAndDelete() async {
    if (_baby == null || _isDeleting) {
      return;
    }
    final babyState = context.read<BabyState>();

    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('아이 프로필 삭제'),
            content: Text(
              '${_baby!.name} 프로필을 삭제하면 관련 수유/기저귀/수면 기록도 함께 삭제될 수 있습니다.\n정말 삭제하시겠어요?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
                child: const Text('삭제'),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldDelete) {
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      await babyState.deleteBaby(widget.babyId);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이 프로필이 삭제되었습니다.')),
      );
      context.go('/babies');
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('삭제에 실패했습니다: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
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
              title: '아이 상세',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              actions: [
                IconButton(
                  tooltip: '수정',
                  onPressed: _isLoading || _baby == null ? null : _moveToEditScreen,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: '삭제',
                  onPressed: _isLoading || _baby == null ? null : _confirmAndDelete,
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.error,
                ),
              ],
            ),
            Expanded(child: _buildBody()),
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 64),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? '아이 정보를 찾을 수 없습니다.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadBabyDetail,
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    final baby = _baby!;
    final ageText = BabyAgeUtils.formatAgeInDaysAndMonths(baby.birthDate);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileSection(baby, ageText),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: '기본 정보',
            children: [
              _buildInfoRow('이름', baby.name),
              _buildInfoRow('생년월일', _formatDate(baby.birthDate)),
              _buildInfoRow('나이', ageText),
              if (baby.gender != null)
                _buildInfoRow('성별', baby.gender == 'male' ? '남아' : '여아'),
              if (baby.bloodType != null) _buildInfoRow('혈액형', baby.bloodType!),
            ],
          ),
          if (baby.notes != null && baby.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              title: '메모',
              children: [
                Text(
                  _formatNotes(baby.notes!),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
          if (_isDeleting) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileSection(Baby baby, String ageText) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          _buildAvatar(baby.photo),
          const SizedBox(height: 12),
          Text(
            baby.name,
            style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            ageText,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? photoUrl) {
    const double avatarSize = 96;
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(avatarSize / 2),
      ),
      child: photoUrl == null
          ? const Icon(Icons.child_care, size: 48, color: AppColors.primary)
          : ClipRRect(
              borderRadius: BorderRadius.circular(avatarSize / 2),
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.child_care,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
            ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final parsedDate = DateTime.tryParse(dateString);
    if (parsedDate == null) {
      return dateString;
    }
    return '${parsedDate.year}년 ${parsedDate.month}월 ${parsedDate.day}일';
  }

  String _formatNotes(Map<String, dynamic> notes) {
    final memo = notes['memo'];
    if (memo is String && memo.trim().isNotEmpty) {
      return memo.trim();
    }
    return notes.toString();
  }
}

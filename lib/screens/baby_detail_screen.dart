import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/baby.dart';
import '../states/baby_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_bar_widget.dart';

/// 아기 상세 화면
/// 
/// 특정 아기의 상세 정보를 보여줍니다.
class BabyDetailScreen extends StatefulWidget {
  final String babyId;

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
      final babyState = context.read<BabyState>();
      
      // 먼저 로컬 상태에서 찾기
      final babies = babyState.babies;
      final localBaby = babies.where((b) => b.id.toString() == widget.babyId).firstOrNull;
      
      if (localBaby != null) {
        setState(() {
          _baby = localBaby;
          _isLoading = false;
        });
      } else {
        // 로컬에 없으면 API에서 가져오기
        await babyState.loadBabies();
        final baby = babyState.babies.where((b) => b.id.toString() == widget.babyId).firstOrNull;
        
        if (baby != null) {
          setState(() {
            _baby = baby;
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = '아기 정보를 찾을 수 없습니다.';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = '아기 정보를 불러오는데 실패했습니다: $e';
        _isLoading = false;
      });
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
              title: '아이 정보',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/babies'),
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
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBabyDetail,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (_baby == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.child_care,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              '아기 정보를 찾을 수 없습니다',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 섹션
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: _baby!.photo != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            _baby!.photo!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.child_care,
                                color: AppColors.primary,
                                size: 60,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.child_care,
                          color: AppColors.primary,
                          size: 60,
                        ),
                ),
                const SizedBox(height: 16),
                Text(
                  _baby!.name,
                  style: AppTextStyles.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  _baby!.ageString,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // 상세 정보
          _InfoCard(
            title: '기본 정보',
            items: [
              _InfoItem(
                label: '생년월일',
                value: _formatDate(_baby!.birthDate),
              ),
              if (_baby!.gender != null)
                _InfoItem(
                  label: '성별',
                  value: _baby!.gender == 'male' ? '남아' : '여아',
                ),
              if (_baby!.bloodType != null)
                _InfoItem(
                  label: '혈액형',
                  value: _baby!.bloodType!,
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 메모
          if (_baby!.notes != null && _baby!.notes!.isNotEmpty)
            _InfoCard(
              title: '메모',
              items: [
                _InfoItem(
                  label: '',
                  value: _baby!.notes.toString(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}년 ${date.month}월 ${date.day}일';
    } catch (e) {
      return dateStr;
    }
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<_InfoItem> items;

  const _InfoCard({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 16),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: item,
                )),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) {
      return Text(
        value,
        style: AppTextStyles.bodyMedium,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
    );
  }
}

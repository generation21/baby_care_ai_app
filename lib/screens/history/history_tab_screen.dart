import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../states/baby_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../feeding/feeding_list_screen.dart';

class HistoryTabScreen extends StatefulWidget {
  const HistoryTabScreen({super.key});

  @override
  State<HistoryTabScreen> createState() => _HistoryTabScreenState();
}

class _HistoryTabScreenState extends State<HistoryTabScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  int? _resolvedBabyId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resolveHistoryBabyId();
    });
  }

  Future<void> _resolveHistoryBabyId() async {
    final babyState = context.read<BabyState>();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (babyState.babies.isEmpty) {
        await babyState.loadBabies();
      }

      if (!mounted) {
        return;
      }

      final selectedBabyId = babyState.selectedBaby?.id;
      final firstBabyId = babyState.babies.isNotEmpty
          ? babyState.babies.first.id
          : null;

      setState(() {
        _resolvedBabyId = selectedBabyId ?? firstBabyId;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
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
                    '히스토리를 불러오지 못했습니다',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _resolveHistoryBabyId,
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (_resolvedBabyId == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.child_care,
                    size: 72,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '먼저 아이를 등록해주세요',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '아이를 등록하면 수유 기록 히스토리를 확인할 수 있습니다.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/add-child'),
                    icon: const Icon(Icons.add),
                    label: const Text('아이 등록하기'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return FeedingListScreen(babyId: _resolvedBabyId!);
  }
}

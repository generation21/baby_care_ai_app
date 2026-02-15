import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class SleepControls extends StatelessWidget {
  final bool isSleeping;
  final bool isProcessing;
  final VoidCallback onStart;
  final VoidCallback onStop;

  const SleepControls({
    super.key,
    required this.isSleeping,
    required this.isProcessing,
    required this.onStart,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isProcessing ? null : (isSleeping ? onStop : onStart),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSleeping ? AppColors.error : AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        icon: isProcessing
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(isSleeping ? Icons.stop : Icons.play_arrow),
        label: Text(isSleeping ? '수면 종료' : '수면 시작'),
      ),
    );
  }
}

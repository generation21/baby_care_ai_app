import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isAI;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isAI,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isAI) ...[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.smart_toy,
              size: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
        ],
        
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isAI ? AppColors.primary50 : AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: Radius.circular(isAI ? 0 : 12),
                bottomRight: Radius.circular(isAI ? 12 : 0),
              ),
              border: isAI ? Border.all(color: AppColors.primary100) : null,
            ),
            child: Text(
              text,
              style: AppTextStyles.body2.copyWith(
                color: isAI ? AppColors.textPrimary : Colors.white,
                height: 1.5,
              ),
            ),
          ),
        ),
        
        if (!isAI) ...[
          const SizedBox(width: 8),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.person,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

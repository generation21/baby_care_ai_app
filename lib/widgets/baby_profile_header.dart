import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class BabyProfileHeader extends StatelessWidget {
  final String babyName;
  final String babyAge;
  final String? avatarUrl;

  const BabyProfileHeader({
    super.key,
    required this.babyName,
    required this.babyAge,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.child_care,
              size: 32,
              color: AppColors.primary,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  babyName,
                  style: AppTextStyles.headline2,
                ),
                const SizedBox(height: 4),
                Text(
                  babyAge,
                  style: AppTextStyles.body2,
                ),
              ],
            ),
          ),
          
          // Edit Button
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            color: AppColors.textSecondary,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

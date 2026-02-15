import 'package:flutter/material.dart';
import '../../models/baby.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/baby_age_utils.dart';

class BabyCard extends StatelessWidget {
  static const double _avatarSize = 56;
  static const double _cardBorderRadius = 16;
  static const EdgeInsets _cardPadding = EdgeInsets.all(16);
  static const EdgeInsets _cardMargin = EdgeInsets.only(bottom: 12);

  final Baby baby;
  final VoidCallback onTap;

  const BabyCard({
    super.key,
    required this.baby,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ageText = BabyAgeUtils.formatAgeInDaysAndMonths(baby.birthDate);

    return Container(
      margin: _cardMargin,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_cardBorderRadius),
          child: Padding(
            padding: _cardPadding,
            child: Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        baby.name,
                        style: AppTextStyles.headlineSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ageText,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (baby.gender != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          baby.gender == 'male' ? '남아' : '여아',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: _avatarSize,
      height: _avatarSize,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: baby.photo == null
          ? const Icon(
              Icons.child_care,
              color: AppColors.primary,
              size: 32,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                baby.photo!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.child_care,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';

/// AI 상담 면책 조항 바
///
/// 앱 스토어 정책(Apple 5.1.3 / Google Play 건강 정책) 준수를 위해
/// AI가 제공하는 정보가 전문 의료 조언을 대체하지 않음을 사용자에게 명확히 알린다.
class AiDisclaimerBar extends StatelessWidget {
  /// 확장 버전 여부 — true이면 두 줄 텍스트 + 배경 카드 형태로 표시
  final bool expanded;

  const AiDisclaimerBar({super.key, this.expanded = false});

  @override
  Widget build(BuildContext context) {
    return expanded ? _buildExpandedVariant() : _buildCompactVariant();
  }

  /// 입력창 위에 항상 노출되는 한 줄 콤팩트 바
  Widget _buildCompactVariant() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8E1),
        border: Border(top: BorderSide(color: Color(0xFFFFECB3))),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 13,
            color: Color(0xFFF9A825),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'AI 답변은 참고용이며 전문 의료인의 진단을 대체하지 않습니다.',
              style: AppTextStyles.overline.copyWith(
                color: const Color(0xFF795548),
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// 빈 화면 하단에 노출되는 확장 카드 형태
  Widget _buildExpandedVariant() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFECB3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.health_and_safety_outlined,
              size: 16,
              color: Color(0xFFF9A825),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '의료 전문가 상담을 권장합니다',
                  style: AppTextStyles.captionSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5D4037),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'AI가 제공하는 정보는 일반적인 참고 목적이며, 소아과 전문의 등 의료인의 진단·처방을 대체하지 않습니다. 아기의 건강에 이상이 의심되면 반드시 전문의와 상담하세요.',
                  style: AppTextStyles.overline.copyWith(
                    color: const Color(0xFF795548),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

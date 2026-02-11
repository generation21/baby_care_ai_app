import 'package:flutter/material.dart';
import '../../models/dashboard.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// 최근 기록 섹션 위젯
/// 
/// 최근 수유, 기저귀, 수면 등의 기록을 표시합니다.
class LastRecordsSection extends StatelessWidget {
  final LastRecords lastRecords;
  final VoidCallback? onTapFeeding;
  final VoidCallback? onTapDiaper;
  final VoidCallback? onTapSleep;

  const LastRecordsSection({
    super.key,
    required this.lastRecords,
    this.onTapFeeding,
    this.onTapDiaper,
    this.onTapSleep,
  });

  @override
  Widget build(BuildContext context) {
    // 기록이 하나도 없는 경우
    final hasAnyRecord = _hasAnyRecord();
    
    if (!hasAnyRecord) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Icon(
              Icons.description_outlined,
              size: 48,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 12),
            Text(
              '아직 기록이 없습니다',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '빠른 추가 버튼으로 첫 기록을 남겨보세요',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    final items = <Widget>[];
    
    // 수유 기록 (모유 또는 분유 중 최근 것)
    final feedingRecord = _getLatestFeedingRecord();
    if (feedingRecord != null) {
      items.add(_RecordItem(
        icon: Icons.restaurant,
        iconColor: AppColors.primary,
        title: _getFeedingTitle(feedingRecord),
        subtitle: feedingRecord.details != null 
            ? _formatDetails(feedingRecord.details!)
            : '수유 완료',
        time: feedingRecord.relativeTime,
        onTap: onTapFeeding,
      ));
    }
    
    // 기저귀 기록
    if (lastRecords.diaper != null && lastRecords.diaper!.time != null) {
      if (items.isNotEmpty) {
        items.add(Divider(height: 1, color: AppColors.borderLight));
      }
      items.add(_RecordItem(
        icon: Icons.child_care,
        iconColor: AppColors.accent,
        title: '기저귀 교체',
        subtitle: lastRecords.diaper!.details != null
            ? _formatDetails(lastRecords.diaper!.details!)
            : '기저귀',
        time: lastRecords.diaper!.relativeTime,
        onTap: onTapDiaper,
      ));
    }
    
    // 수면 기록
    if (lastRecords.sleep != null && lastRecords.sleep!.time != null) {
      if (items.isNotEmpty) {
        items.add(Divider(height: 1, color: AppColors.borderLight));
      }
      items.add(_RecordItem(
        icon: Icons.nightlight_round,
        iconColor: AppColors.info,
        title: '수면',
        subtitle: lastRecords.sleep!.details != null
            ? _formatDetails(lastRecords.sleep!.details!)
            : '수면 완료',
        time: lastRecords.sleep!.relativeTime,
        onTap: onTapSleep,
      ));
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(children: items),
    );
  }

  bool _hasAnyRecord() {
    return (lastRecords.breastMilk?.time != null) ||
        (lastRecords.formula?.time != null) ||
        (lastRecords.solid?.time != null) ||
        (lastRecords.pumping?.time != null) ||
        (lastRecords.diaper?.time != null) ||
        (lastRecords.sleep?.time != null);
  }

  LastRecord? _getLatestFeedingRecord() {
    // 모유, 분유, 이유식, 유축 중 가장 최근 기록 반환
    LastRecord? latest;
    
    final records = [
      lastRecords.breastMilk,
      lastRecords.formula,
      lastRecords.solid,
      lastRecords.pumping,
    ].where((r) => r != null && r.time != null).toList();
    
    if (records.isNotEmpty) {
      latest = records.first;
    }
    
    return latest;
  }

  String _getFeedingTitle(LastRecord record) {
    // details에서 타입 추론
    if (record.details?['feeding_type'] != null) {
      switch (record.details!['feeding_type']) {
        case 'breast_milk':
          return '모유 수유';
        case 'formula':
          return '분유 수유';
        case 'solid_food':
          return '이유식';
        case 'pumping':
          return '유축';
      }
    }
    return '수유';
  }

  String _formatDetails(Map<String, dynamic> details) {
    final parts = <String>[];
    
    if (details['amount'] != null) {
      parts.add('${details['amount']}ml');
    }
    
    if (details['duration_minutes'] != null) {
      parts.add('${details['duration_minutes']}분');
    }
    
    if (details['side'] != null) {
      parts.add(details['side'] == 'left' ? '왼쪽' : '오른쪽');
    }
    
    if (details['diaper_type'] != null) {
      parts.add(details['diaper_type'].toString());
    }
    
    if (details['sleep_duration_minutes'] != null) {
      final minutes = details['sleep_duration_minutes'] as int;
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      if (hours > 0) {
        parts.add('$hours시간 $mins분');
      } else {
        parts.add('$mins분');
      }
    }
    
    return parts.isEmpty ? '' : parts.join(' • ');
  }
}

class _RecordItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final VoidCallback? onTap;

  const _RecordItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 아이콘
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // 텍스트 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // 시간
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  if (onTap != null) ...[
                    const SizedBox(height: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

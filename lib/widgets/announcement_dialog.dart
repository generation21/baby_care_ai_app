import 'package:babycareai/models/announcement.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementDialog extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementDialog({super.key, required this.announcement});

  static const String _viewedAnnouncementsKey = 'viewed_announcements';

  static Future<void> _setViewed(int announcementId) async {
    final prefs = await SharedPreferences.getInstance();
    // 1. 기존의 공지사항 아이디를 가져온다.
    final viewedIds = prefs.getStringList(_viewedAnnouncementsKey) ?? [];

    // 2. 가져온 아이디에 포함여부 확인.
    if (!viewedIds.contains(announcementId.toString())) {
      viewedIds.add(announcementId.toString());
    }
    // 3. 포함되어 있지 않다면 새로 추가한다.
    await prefs.setStringList(_viewedAnnouncementsKey, viewedIds);
  }

  static Future<bool> _isViewed(int announcmentId) async {
    final prefs = await SharedPreferences.getInstance();
    final viewedIds = prefs.getStringList(_viewedAnnouncementsKey) ?? [];
    return viewedIds.contains(announcmentId.toString());
  }

  // 공지사항 다이얼로그 보여주는 함수 show
  static Future<void> show(
    BuildContext context,
    Announcement announcement,
  ) async {
    if (await _isViewed(announcement.id)) {
      return;
    }

    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => AnnouncementDialog(announcement: announcement),
      );
      await _setViewed(announcement.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(announcement.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(announcement.content)],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('확인'),
        ),
      ],
    );
  }
}

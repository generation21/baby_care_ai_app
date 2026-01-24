import 'dart:io';

import 'package:babycareai/models/update_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateInfoDialog extends StatelessWidget {
  final UpdateInfo updateInfo;

  const UpdateInfoDialog({super.key, required this.updateInfo});

  static const String _viewedUpdateInfoKey = 'viewed_update_info';

  static Future<void> _setViewed(int updateInfoId) async {
    final prefs = await SharedPreferences.getInstance();
    final viewedIds = prefs.getStringList(_viewedUpdateInfoKey) ?? [];
    if (!viewedIds.contains(updateInfoId.toString())) {
      viewedIds.add(updateInfoId.toString());
    }
    await prefs.setStringList(_viewedUpdateInfoKey, viewedIds);
  }

  static Future<bool> _isViewed(int updateInfoId) async {
    final prefs = await SharedPreferences.getInstance();
    final viewedIds = prefs.getStringList(_viewedUpdateInfoKey) ?? [];
    return viewedIds.contains(updateInfoId.toString());
  }

  static Future<void> show(BuildContext context, UpdateInfo updateInfo) async {
    if (await _isViewed(updateInfo.id)) {
      return;
    }

    if (context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => UpdateInfoDialog(updateInfo: updateInfo),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text('앱 업데이트 안내'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(updateInfo.updateContent)],
        ),
      ),
      actions: [
        if (!updateInfo.isForceUpdate)
          TextButton(
            onPressed: () async {
              await _setViewed(updateInfo.id);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Text('나중에'),
          ),
        TextButton(
          onPressed: () async {
            if (Platform.isIOS) {
              await launchUrl(
                Uri.parse(updateInfo.appStoreLink ?? 'https://apps.apple.com/'),
              );
            } else if (Platform.isAndroid) {
              await launchUrl(
                Uri.parse(
                  updateInfo.playStoreLink ?? 'https://play.google.com/',
                ),
              );
            }
          },
          child: Text('지금 업데이트'),
        ),
      ],
    );
  }
}

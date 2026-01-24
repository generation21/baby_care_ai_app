import 'dart:io';

import 'package:babycareai/clients/discord_webhook.dart';
import 'package:babycareai/screens/settings_screen/feedback_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<PackageInfo> _getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('설정 화면')),
      body: ListView(
        children: [
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('앱 버전'),
            subtitle: FutureBuilder(
              future: _getPackageInfo(),
              builder: (context, snapshot) {
                return Text(snapshot.data?.version ?? '불러오는 중...');
              },
            ),
          ),
          Divider(height: 0),
          ListTile(
            minVerticalPadding: 25,
            leading: Icon(Icons.description_outlined),
            title: Text('서비스 소개'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("서비스 소개"),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text("서비스 한 줄 소개를 입력해주세요."),
                      SizedBox(height: 12),
                      Text("이 서비스의 목적을 입력해주세요."),
                      SizedBox(height: 12),
                      Text("사용자의 다음 행동을 제안해주세요."),
                      SizedBox(height: 8),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text("확인"),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(height: 0),
          ListTile(
            minVerticalPadding: 25,
            leading: Icon(Icons.mail_outline),
            title: Text('고객 문의/제안'),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              // 1단계: 문의 유형 선택 (기능 제안, 버그 신고, 기타 문의)
              // 2단계: 문의 내용 입력
              // 3단계: 사용자가 답변 받을 이메일 입력 (선택사항)

              final feedback = await FeedbackDialog.show(context);
              if (feedback == null) {
                return;
              }
              final category = feedback['category'] as FeedbackCategory;

              // 마지막 사용자로부터 받은 메시지를 디스코드로 전송
              // 1. 타이틀
              // 문의 카테고리, 앱 이름, 앱 버전
              final packageInfo = await _getPackageInfo();
              final title =
                  '${category.name} :: ${packageInfo.appName} ${packageInfo.version}';
              // 기능 제안 :: Babycareai 1.0.0
              // 2. 메시지
              // 문의 내용 + 기기 정보 + 이메일
              final deviceInfo =
                  '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
              String message = '💬 ${feedback['message']}';
              message +=
                  '\n\n📨 ${feedback['email']!.isNotEmpty ? feedback['email'] : '제공하지 않음'}';
              message += '\n\n💻 $deviceInfo';

              // 3. 우선순위
              // 문의 카테고리에 따라 스위치 문으로 우선순위 지정
              final priority = switch (category) {
                FeedbackCategory.featureSuggestion => Priority.medium,
                FeedbackCategory.bugReport => Priority.high,
                _ => Priority.low,
              };

              // 메시지 전송
              await DiscordWebhookClient().sendMessage(
                title: title,
                message: message,
                priority: priority,
              );

              // 스낵바를 올려서 전송이 성공했다라는 것을 알려준다.
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('문의가 성공적으로 전송되었습니다')));
            },
          ),
          Divider(height: 0),
        ],
      ),
    );
  }
}

import 'package:babycareai/repositories/announcement.dart';
import 'package:babycareai/repositories/update_info.dart';
import 'package:babycareai/utils/version_utils.dart';
import 'package:babycareai/widgets/announcement_dialog.dart';
import 'package:babycareai/widgets/update_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _showUpdateInfo();
      await _showAnnouncement();
    });
  }

  Future<void> _showUpdateInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final updateInfoRepository = UpdateInfoRepository(
      Supabase.instance.client,
      packageInfo.packageName,
    );

    final updateInfo = await updateInfoRepository.getLatestUpdateInfo();
    final isUpdate = VersionUtils.isUpdateRequired(
      packageInfo.version,
      updateInfo?.version ?? '0.0.0',
    );
    if (updateInfo != null && isUpdate && mounted) {
      await UpdateInfoDialog.show(context, updateInfo);
    }
  }

  Future<void> _showAnnouncement() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final announcementRepository = AnnouncementRepository(
      Supabase.instance.client,
      packageInfo.packageName,
    );

    final announcement = await announcementRepository.getLatestAnnouncement();
    if (announcement != null && mounted) {
      await AnnouncementDialog.show(context, announcement);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('홈 화면'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: Center(child: Text('기능을 추가해주세요!')),
    );
  }
}

class UpdateInfo {
  final int id;
  final String appId;
  final String version;
  final bool isForceUpdate;
  final String updateContent;
  final DateTime createdAt;
  final String? appStoreLink;
  final String? playStoreLink;

  UpdateInfo({
    required this.id,
    required this.appId,
    required this.version,
    required this.isForceUpdate,
    required this.updateContent,
    required this.createdAt,
    this.appStoreLink,
    this.playStoreLink,
  });

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    return UpdateInfo(
      id: json['id'] as int,
      appId: json['app_id'] as String,
      version: json['version'] as String,
      isForceUpdate: json['is_force_update'] as bool,
      updateContent: json['update_content'] as String,
      createdAt: DateTime.parse(json['created_at']),
      appStoreLink: json['app_store_link'] as String?,
      playStoreLink: json['play_store_link'] as String?,
    );
  }
}

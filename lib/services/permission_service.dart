import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

enum AppPermissionType { notifications, photos }

class PermissionService {
  static const List<AppPermissionType> _requiredPermissions = [
    AppPermissionType.notifications,
    AppPermissionType.photos,
  ];

  Future<Map<AppPermissionType, PermissionStatus>>
  requestEssentialPermissions() async {
    final permissionStatuses = <AppPermissionType, PermissionStatus>{};

    for (final permissionType in _requiredPermissions) {
      permissionStatuses[permissionType] = await _requestPermissionByType(
        permissionType,
      );
    }

    return permissionStatuses;
  }

  Future<PermissionStatus> requestNotificationPermission() {
    return _requestPermissionByType(AppPermissionType.notifications);
  }

  Future<PermissionStatus> requestPhotoPermission() {
    return _requestPermissionByType(AppPermissionType.photos);
  }

  Future<PermissionStatus> getNotificationPermissionStatus() {
    final permission = _resolvePermission(AppPermissionType.notifications);
    if (permission == null) {
      return Future.value(PermissionStatus.granted);
    }
    return permission.status;
  }

  Future<PermissionStatus> getPhotoPermissionStatus() {
    final permission = _resolvePermission(AppPermissionType.photos);
    if (permission == null) {
      return Future.value(PermissionStatus.granted);
    }
    return permission.status;
  }

  Future<bool> openSystemSettings() => openAppSettings();

  Future<PermissionStatus> _requestPermissionByType(
    AppPermissionType permissionType,
  ) async {
    final permission = _resolvePermission(permissionType);
    if (permission == null) {
      return PermissionStatus.granted;
    }
    return permission.request();
  }

  Permission? _resolvePermission(AppPermissionType permissionType) {
    if (kIsWeb) {
      return null;
    }

    switch (permissionType) {
      case AppPermissionType.notifications:
        return Permission.notification;
      case AppPermissionType.photos:
        if (Platform.isIOS || Platform.isAndroid) {
          return Permission.photos;
        }
        return null;
    }
  }
}

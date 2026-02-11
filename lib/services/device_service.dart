import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

/// 디바이스 정보 및 ID 관리 서비스
/// 
/// 디바이스 고유 ID를 생성하고 관리합니다.
class DeviceService {
  static const String _deviceIdKey = 'device_id';
  
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Uuid _uuid = const Uuid();

  /// 디바이스 ID 가져오기
  /// 
  /// 저장된 디바이스 ID가 없으면 새로 생성합니다.
  Future<String> getDeviceId() async {
    try {
      String? deviceId = await _storage.read(key: _deviceIdKey);
      
      if (deviceId == null || deviceId.isEmpty) {
        deviceId = _uuid.v4();
        await _storage.write(key: _deviceIdKey, value: deviceId);
      }
      
      return deviceId;
    } catch (e) {
      throw Exception('디바이스 ID를 가져오는데 실패했습니다: $e');
    }
  }

  /// 디바이스 정보 가져오기
  /// 
  /// 플랫폼별 디바이스 정보를 반환합니다.
  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        return await _getAndroidInfo();
      } else if (Platform.isIOS) {
        return await _getIOSInfo();
      } else {
        return {
          'platform': 'unknown',
          'model': 'unknown',
          'os_version': 'unknown',
        };
      }
    } catch (e) {
      return {
        'platform': Platform.isAndroid ? 'android' : 'ios',
        'model': 'unknown',
        'os_version': 'unknown',
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _getAndroidInfo() async {
    final info = await _deviceInfo.androidInfo;
    return {
      'platform': 'android',
      'model': info.model,
      'manufacturer': info.manufacturer,
      'os_version': info.version.release,
      'sdk_version': info.version.sdkInt.toString(),
      'brand': info.brand,
      'device': info.device,
    };
  }

  Future<Map<String, dynamic>> _getIOSInfo() async {
    final info = await _deviceInfo.iosInfo;
    return {
      'platform': 'ios',
      'model': info.model,
      'name': info.name,
      'os_version': info.systemVersion,
      'is_physical': info.isPhysicalDevice.toString(),
      'identifier': info.identifierForVendor ?? 'unknown',
    };
  }

  /// 플랫폼 이름 가져오기
  String get platform {
    if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isAndroid) {
      return 'android';
    }
    return 'unknown';
  }

  /// 앱 ID
  static const String appId = 'app.babycareai';

  /// 디바이스 ID 초기화 (테스트용)
  Future<void> resetDeviceId() async {
    await _storage.delete(key: _deviceIdKey);
  }
}

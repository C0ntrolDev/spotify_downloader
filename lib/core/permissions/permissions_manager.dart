import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsManager {
  Future<bool> requestPermissions() async {
    final androidVersion = await _getAndroidVersion();
    late final List<Permission> permissions;
    if (androidVersion >= 13) {
      permissions = _getPermissionsForAndroid13AndAbove();
    } else {
      permissions = _getPermissionsForAndroid12AndEarlier();
    }

    for (var permission in permissions) {
      await permission.request();
    }

    return await isPermissionsGranted();
  }

  Future<bool> isNotificationsPermissionGranted() {
    return Permission.notification.isGranted;
  }

  Future<bool> isPermissionsGranted() async {
    final androidVersion = await _getAndroidVersion();
    late final List<Permission> permissions;
    if (androidVersion >= 13) {
      permissions = _getPermissionsForAndroid13AndAbove();
    } else {
      permissions = _getPermissionsForAndroid12AndEarlier();
    }

    for (var permission in permissions) {
      if (!(await permission.isGranted)) {
        return false;
      }
    }

    return true;
  }

  Future<int> _getAndroidVersion() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await info.androidInfo;
    final int androidVersion = int.parse(androidInfo.version.release);
    return androidVersion;
  }

  List<Permission> _getPermissionsForAndroid13AndAbove() {
    return [Permission.manageExternalStorage, Permission.notification, Permission.ignoreBatteryOptimizations];
  }

  List<Permission> _getPermissionsForAndroid12AndEarlier() {
    return [Permission.storage, Permission.notification];
  }
}

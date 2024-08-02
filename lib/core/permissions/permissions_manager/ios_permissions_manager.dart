import 'package:permission_handler/permission_handler.dart';
import 'package:spotify_downloader/core/permissions/permissions_manager/permissions_manager_class.dart';

class IOSPermissionsManager extends PermissionsManager {
  @override
  Future<bool> requestPermissions() async {
    final permissions = _getPermissionsForIOS();
    for (var permission in permissions) {
      await permission.request();
    }

    return await isPermissionsGranted();
  }

  @override
  Future<bool> isPermissionsGranted() async {
    final permissions = _getPermissionsForIOS();

    for (var permission in permissions) {
      if (!(await permission.isGranted)) {
        return false;
      }
    }

    return true;
  }

  Future<bool> isNotificationsPermissionGranted() {
    return Permission.notification.isGranted;
  }

  List<Permission> _getPermissionsForIOS() {
    return [Permission.storage, Permission.notification];
  }
}

import 'package:spotify_downloader/core/permissions/permissions_manager/permissions_manager_class.dart';

class MockPermissionsManager extends PermissionsManager {

  @override
  Future<bool> isPermissionsGranted() async {
    return false;
  }

  @override
  Future<bool> requestPermissions() async {
    return false;
  }
}

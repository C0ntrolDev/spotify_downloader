abstract class PermissionsManager {

  Future<bool> requestPermissions();

  Future<bool> isPermissionsGranted();
}

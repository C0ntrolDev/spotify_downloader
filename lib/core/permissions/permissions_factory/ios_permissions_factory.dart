import 'package:spotify_downloader/core/permissions/permissions.dart';


class IOSPermissionsFactory extends PermissionsAbstractFactory {
  @override
  IOSPermissionServicesInitializer getPermissionServicesInitializer() {
    return IOSPermissionServicesInitializer(permissionsManager: getPermissionsManager());
  }

  @override
  IOSPermissionsManager getPermissionsManager() {
    return IOSPermissionsManager();
  }
}

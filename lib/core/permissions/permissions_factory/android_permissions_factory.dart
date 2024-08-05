import 'package:spotify_downloader/core/permissions/permissions.dart';


class AndroidPermissionsFactory extends PermissionsAbstractFactory {
  @override
  AndroidPermissionServicesInitializer getPermissionServicesInitializer() {
    return AndroidPermissionServicesInitializer(permissionsManager: getPermissionsManager());
  }

  @override
  AndroidPermissionsManager getPermissionsManager() {
    return AndroidPermissionsManager();
  }
}

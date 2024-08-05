

import 'package:spotify_downloader/core/permissions/permissions.dart';

class MockPermissionsFactory extends PermissionsAbstractFactory {
  @override
  MockPermissionServicesInitializer getPermissionServicesInitializer() {
    return MockPermissionServicesInitializer();
  }

  @override
  MockPermissionsManager getPermissionsManager() {
    return MockPermissionsManager();
  }
}

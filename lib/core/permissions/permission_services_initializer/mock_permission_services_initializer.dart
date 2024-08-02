import 'package:spotify_downloader/core/permissions/permission_services_initializer/permission_services_initializer_class.dart';

class MockPermissionServicesInitializer extends PermissionServicesInitializer {
  @override
  Future<bool> init() async {
    return false;
  }
}

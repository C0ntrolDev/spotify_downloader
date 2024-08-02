import 'package:spotify_downloader/core/notifications/notifications.dart';
import 'package:spotify_downloader/core/permissions/permission_services_initializer/permission_services_initializer_class.dart';
import 'package:spotify_downloader/core/permissions/permissions_manager/ios_permissions_manager.dart';

class IOSPermissionServicesInitializer extends PermissionServicesInitializer {
  IOSPermissionServicesInitializer({required this.permissionsManager});

  IOSPermissionsManager permissionsManager;

  bool _isNotificationsInitialized = false;

  @override
  Future<bool> init() async {
    if (!_isNotificationsInitialized && await permissionsManager.isNotificationsPermissionGranted()) {
      _isNotificationsInitialized = true;

      await initAwesomeNotifications();
    }

    return _isNotificationsInitialized;
  }
}

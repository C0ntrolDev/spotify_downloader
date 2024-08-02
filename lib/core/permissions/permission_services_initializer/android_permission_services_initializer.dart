import 'package:flutter_background/flutter_background.dart';
import 'package:spotify_downloader/core/background/background.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/core/notifications/notifications.dart';
import 'package:spotify_downloader/core/permissions/permission_services_initializer/permission_services_initializer_class.dart';
import 'package:spotify_downloader/core/permissions/permissions_manager/android_permissions_manager.dart';
import 'package:spotify_downloader/features/presentation/tracks_collections_loading_notifications/view/tracks_collections_loading_notifications_sender.dart';

class AndroidPermissionServicesInitializer extends PermissionServicesInitializer {
  AndroidPermissionServicesInitializer({required this.permissionsManager});

  AndroidPermissionsManager permissionsManager;

  bool _isNotificationsInitialized = false;
  bool _isBackgroundInitialized = false;

  @override
  Future<bool> init() async {
    if (!_isNotificationsInitialized && await permissionsManager.isNotificationsPermissionGranted()) {
      _isNotificationsInitialized = true;

      await initAwesomeNotifications();
      await injector.get<TracksCollectionsLoadingNotificationsSender>().startSendNotifications();
    }

    if (!_isBackgroundInitialized && await FlutterBackground.hasPermissions) {
      _isBackgroundInitialized = true;

      await initBackground();
      await FlutterBackground.enableBackgroundExecution();
    }

    return _isNotificationsInitialized && _isBackgroundInitialized;
  }
}

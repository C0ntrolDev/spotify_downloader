import 'package:flutter_background/flutter_background.dart';
import 'package:spotify_downloader/core/background/background.dart';
import 'package:spotify_downloader/core/notifications/notifications.dart';
import 'package:spotify_downloader/core/permissions/permissions_manager.dart';
import 'package:spotify_downloader/features/presentation/tracks_collections_loading_notifications/view/tracks_collections_loading_notifications_sender.dart';

class RequiringPermissionServicesInitializer {
  RequiringPermissionServicesInitializer({required this.permissionsManager});

  final PermissionsManager permissionsManager;

  bool _isNotificationsInitialized = false;
  bool _isBackgroundInitialized = false;

  Future<void> initialize() async {
    if (!_isNotificationsInitialized && await permissionsManager.isNotificationsPermissionGranted()) {
      _isNotificationsInitialized = true;

      await initAwesomeNotifications();
      await TracksCollectionsLoadingNotificationsSender().startSendNotifications();
    }

    if (!_isBackgroundInitialized && await FlutterBackground.hasPermissions) {
      _isBackgroundInitialized = true;

      await initBackground();
      await FlutterBackground.enableBackgroundExecution();
    }
  }
}

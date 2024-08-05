

import 'package:flutter/foundation.dart';
import 'package:spotify_downloader/core/permissions/permissions.dart';

abstract class PermissionsAbstractFactory {
  PermissionsAbstractFactory();

  factory PermissionsAbstractFactory.create(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
        return AndroidPermissionsFactory();
      case TargetPlatform.iOS:
        return IOSPermissionsFactory();
      default:
        return MockPermissionsFactory();
    }
  }

  PermissionServicesInitializer getPermissionServicesInitializer();

  PermissionsManager getPermissionsManager();
}

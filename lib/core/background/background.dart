import 'package:flutter_background/flutter_background.dart';

Future<void> initBackground() async {
  bool success = await _tryInitBackground();
  if (!success) {
    _tryInitBackground();
  }
}

Future<bool> _tryInitBackground() {
   const androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "You can close the app and the download will continue !",
    notificationText: "(you can delete this message)",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(name: 'notifications_icon', defType: 'drawable'),
  );

  return FlutterBackground.initialize(androidConfig: androidConfig);
}

import 'package:flutter_background/flutter_background.dart';

Future<void> initBackground() async {
  bool success = await _tryInitBackground();
  if (!success) {
    _tryInitBackground();
  }
}

Future<bool> _tryInitBackground() async {
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "App working in background",
    notificationText: "^_^",
    notificationImportance: AndroidNotificationImportance.normal,
    notificationIcon: const AndroidResource(name: 'notifications_icon', defType: 'drawable'),
  );

  return FlutterBackground.initialize(androidConfig: androidConfig);
}

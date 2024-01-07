import 'package:flutter_background/flutter_background.dart';
import 'package:spotify_downloader/generated/l10n.dart';

Future<void> initBackground() async {
  bool success = await _tryInitBackground();
  if (!success) {
    _tryInitBackground();
  }
}

Future<bool> _tryInitBackground() {
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: S().youCanCloseTheAppAndTheDownloadWillContinue,
    notificationText: S().youCanDeleteThisMessage,
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: const AndroidResource(name: 'notifications_icon', defType: 'drawable'),
  );

  return FlutterBackground.initialize(androidConfig: androidConfig);
}

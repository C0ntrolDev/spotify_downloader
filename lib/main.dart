import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/core/notifications/notifications.dart';
import 'package:spotify_downloader/features/domain/settings/use_cases/get_language.dart';
import 'package:spotify_downloader/features/presentation/tracks_collections_loading_notification/view/tracks_collections_loading_notifications_sender.dart';
import 'core/app/spotify_downloader_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MetadataGod.initialize();
  await initInjector();
  await initAwesomeNotifications();

  await TracksCollectionsLoadingNotificationsSender().startSendNotifications();

  final getLanguageResult = await injector.get<GetLanguage>().call(null);
  runApp(SpotifyDownloaderApp(
    locale: getLanguageResult.result ?? 'en',
  ));
}

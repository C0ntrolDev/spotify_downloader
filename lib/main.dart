import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:spotify_downloader/core/di/injector.dart';

import 'core/app/spotify_downloader_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MetadataGod.initialize();
  await initInjector();
  runApp(const SpotifyDownloaderApp());
}

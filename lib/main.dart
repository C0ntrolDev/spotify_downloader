import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/di/injector.dart';

import 'core/app/spotify_downloader_app.dart';

Future<void> main() async {
  initCore();
  runApp(const SpotifyDownloaderApp());
}

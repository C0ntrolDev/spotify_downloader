import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/use_cases/get_language.dart';
import 'core/app/spotify_downloader_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MetadataGod.initialize();
  await initInjector();  

  final locale = await injector.get<GetLanguage>().call(null);
  runApp(SpotifyDownloaderApp(locale: locale.result));
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spotify_downloader/core/app/cubit/language_cubit/language_cubit.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'core/app/spotify_downloader_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MetadataGod.initialize();
  await initInjector(defaultTargetPlatform);

  final languageCubit = injector.get<LanguageCubit>();
  await languageCubit.loadLanguage();

  final packageInfo = await PackageInfo.fromPlatform();
  runApp(SpotifyDownloaderApp(packageInfo: packageInfo));
}
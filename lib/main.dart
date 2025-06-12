import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/use_cases/get_language.dart';
import 'core/app/spotify_downloader_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MetadataGod.initialize();
  await initInjector(defaultTargetPlatform);  

  final locale = await injector.get<GetLanguage>().call(null);
  final packageInfo = await PackageInfo.fromPlatform();
  runApp(SpotifyDownloaderApp(locale: locale.result, packageInfo: packageInfo));
}

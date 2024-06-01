import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/core/permissions/requiring_permission_services_initializer.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/use_cases/get_language.dart';
import 'core/app/spotify_downloader_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MetadataGod.initialize();
  await initInjector();  
  await injector.get<RequiringPermissionServicesInitializer>().initialize();

  final getLanguageResult = await injector.get<GetLanguage>().call(null);
  runApp(SpotifyDownloaderApp(
    locale: getLanguageResult.result ?? 'en',
  ));
}

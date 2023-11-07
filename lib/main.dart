import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/models/db/local/local_playlist.dart';
import 'package:spotify_downloader/models/db/local/local_track.dart';
import 'package:spotify_downloader/repositories/spotify_api_repository.dart';
import 'package:spotify_downloader/services/local_data_serivces/spotify_local_credentials_service.dart';
import 'package:spotify_downloader/services/local_data_serivces/spotify_local_data_service.dart';
import 'package:spotify_downloader/services/spotify_api_data_service/spotify_api_data_service.dart';
import 'package:spotify_downloader/services/spotify_autorization_service/spotify_autorization_service.dart';
import 'package:flutter/src/widgets/image.dart' as image;

void main() {
  const clientId = '6bbc592f2e4f4030b827563640609dbc';
  const clientSecret = '3b1a82e64eb44bcda2a80afc879ed6a8';

  GetIt.I.registerSingleton<SpotifyAutorizationService>(
      SpotifyAutorizationService(clientId: clientId, clientSecret: clientSecret));
  GetIt.I.registerSingleton<SpotifyLocalCredentialsService>(SpotifyLocalCredentialsService());
  GetIt.I.registerSingleton<SpotifyApiDataService>(SpotifyApiDataService(
      clientId: clientId,
      clientSecret: clientSecret));
  GetIt.I.registerSingletonAsync<SpotifyLocalDataService>(() => SpotifyLocalDataService.create());
  GetIt.I.registerSingleton<>

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 21, 255, 0)),
        useMaterial3: true,
      ),
      routes: ,
    );
  }
}

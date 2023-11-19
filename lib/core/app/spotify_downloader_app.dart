import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';

class SpotifyDownloaderApp extends StatefulWidget {
  const SpotifyDownloaderApp({super.key});

  @override
  State<SpotifyDownloaderApp> createState() => _SpotifyDownloaderAppState();
}

class _SpotifyDownloaderAppState extends State<SpotifyDownloaderApp> {
  final _appRouter = AppRouter(); 
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      theme: mainTheme,
    );
  }
}

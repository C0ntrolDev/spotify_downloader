import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/features/presentation/home/view/home_screen.dart';

class SpotifyDownloaderApp extends StatelessWidget {
  const SpotifyDownloaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      home: const HomeScreen(),
    );
  }
}

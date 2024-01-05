import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/generated/l10n.dart';

class SpotifyDownloaderApp extends StatefulWidget {
  const SpotifyDownloaderApp({super.key, required this.locale});

  final String locale;

  static void setLanguage(BuildContext context, String newLanguage) async {
    final state = context.findAncestorStateOfType<_SpotifyDownloaderAppState>();
    state?.changeLanguage(newLanguage);
  }

  @override
  State<SpotifyDownloaderApp> createState() => _SpotifyDownloaderAppState();
}

class _SpotifyDownloaderAppState extends State<SpotifyDownloaderApp> {
  final _appRouter = AppRouter();
  String _language = 'en';

  @override
  void initState() {
    _language = widget.locale;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: Locale(_language),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      routerConfig: _appRouter.config(navigatorObservers: () => [AutoRouteObserver()]),
      theme: mainTheme,
    );
  }

  changeLanguage(String language) {
    setState(() {
      _language = language;
    });
  }
}

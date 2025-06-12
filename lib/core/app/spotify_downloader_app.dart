import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spotify_downloader/core/app/cubit/language_cubit.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/accessors/package_info/package_info_accessor.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/l10n/app_localizations.dart';

class SpotifyDownloaderApp extends StatefulWidget {
  const SpotifyDownloaderApp({super.key, required this.packageInfo});

  final PackageInfo packageInfo;

  @override
  State<SpotifyDownloaderApp> createState() => _SpotifyDownloaderAppState();
}

class _SpotifyDownloaderAppState extends State<SpotifyDownloaderApp> {
  final languageCubit = injector.get<LanguageCubit>();

  final navigatorKey = GlobalKey();
  final _appRouter = AppRouter();

  @override
  void initState() {
    super.initState();

    languageCubit.loadLanguage();
    initTheme();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return MaterialApp.router(
            locale: Locale((state as LanguageLoaded).language),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: _appRouter.config(navigatorObservers: () => [AutoRouteObserver()]),
            theme: mainTheme,
            builder: (context, child) {
              return ScrollConfiguration(
                  behavior: const ClampingScrollPhysicsBehavior().copyWith(overscroll: false),
                  child: PackageInfoAccessor(packageInfo: widget.packageInfo, child: child!));
            });
      },
    );
  }
}

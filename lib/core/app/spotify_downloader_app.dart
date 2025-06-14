import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:listen_sharing_intent/listen_sharing_intent.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spotify_downloader/core/app/cubit/language_cubit/language_cubit.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/core/accessors/package_info/package_info_accessor.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/generated/l10n.dart';

class SpotifyDownloaderApp extends StatefulWidget {
  const SpotifyDownloaderApp({super.key, required this.packageInfo});

  final PackageInfo packageInfo;

  @override
  State<SpotifyDownloaderApp> createState() => _SpotifyDownloaderAppState();
}

class _SpotifyDownloaderAppState extends State<SpotifyDownloaderApp> {
  final LanguageCubit _languageCubit = injector.get<LanguageCubit>();

  final navigatorKey = GlobalKey();
  final _appRouter = AppRouter();

  StreamSubscription? _intentSub;

  @override
  void initState() {
    super.initState();
    _initIntent();

    initTheme();
  }

  @override
  void dispose() {
    _intentSub?.cancel();
    super.dispose();
  }

  void _initIntent() {
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(_onMediaGot, onError: (err) {});

    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      _onMediaGot(value);
      ReceiveSharingIntent.instance.reset();
    });
  }

  void _onMediaGot(List<SharedMediaFile> value) {
    if (value.isEmpty) {
      return;
    }

    final media = value.last;
    if (media.type.value != "url" && media.type.value != "text") {
      return;
    }

    if(!media.path.startsWith("https://")) {
      return;
    }
    
    _appRouter.push(DownloadTracksCollectionRouteWithUrl(url: media.path));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      bloc: _languageCubit,
      builder: (context, state) {
        if (state is! LanguageLoaded) {
          return Container();
        }

        return MaterialApp.router(
            locale: Locale(state.language),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
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

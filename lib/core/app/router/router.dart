import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/track.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/history_tracks_collections/domain/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/presentation/about_app/view/about_app_screen.dart';
import 'package:spotify_downloader/features/presentation/change_source_video/view/change_source_video_screen.dart';
import 'package:spotify_downloader/features/presentation/history/view/history_screen.dart';
import 'package:spotify_downloader/features/presentation/home/view/home_screen.dart';
import 'package:spotify_downloader/features/presentation/main/view/main_screen.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/view/download_tracks_collection_screen.dart';
import 'package:spotify_downloader/features/presentation/packages_info/view/packages_info_screen.dart';
import 'package:spotify_downloader/features/presentation/settings/view/settings_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: MainRoute.page, path: '/', children: [
          RedirectRoute(path: '', redirectTo: 'home'),
          CustomRoute(
              page: HomeRoute.page,
              path: 'home',
              transitionsBuilder: TransitionsBuildersExtension.fadeInWithBackground),
          CustomRoute(
              page: HistoryRoute.page,
              path: 'history',
              transitionsBuilder: TransitionsBuildersExtension.fadeInWithBackground),
          CustomRoute(
              page: DownloadTracksCollectionRouteWithHistoryTracksCollection.page,
              path: 'downloadTracksCollectionFromHistory',
              transitionsBuilder: TransitionsBuildersExtension.fadeInWithBackground),
          CustomRoute(
              page: DownloadTracksCollectionRouteWithUrl.page,
              path: 'downloadTracksCollectionFromUrl',
              transitionsBuilder: TransitionsBuildersExtension.fadeInWithBackground),
          CustomRoute(
              page: ChangeSourceVideoRoute.page,
              path: 'changeSourceVideo',
              transitionsBuilder: TransitionsBuildersExtension.fadeInWithBackground),
          CustomRoute(
              page: SettingsRoute.page,
              path: 'settings',
              transitionsBuilder: TransitionsBuildersExtension.fadeInWithBackground),
          CustomRoute(
              page: AboutAppRoute.page,
              path: 'about',
              transitionsBuilder: TransitionsBuildersExtension.fadeInWithBackground),
          CustomRoute(
              page: PackagesInfoRoute.page,
              path: 'packages_info',
              transitionsBuilder: TransitionsBuildersExtension.fadeInWithBackground)
        ]),
      ];
}

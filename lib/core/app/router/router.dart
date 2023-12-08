import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/view/download_tracks_collection_screen.dart';
import 'package:spotify_downloader/features/presentation/history/view/history_screen.dart';
import 'package:spotify_downloader/features/presentation/home/view/home_screen.dart';
import 'package:spotify_downloader/features/presentation/main/view/main_screen.dart';

part 'router.gr.dart';            
              
@AutoRouterConfig()      
class AppRouter extends _$AppRouter {      
    
  @override      
  List<AutoRoute> get routes => [
    AutoRoute(page: MainRoute.page, path: '/', children: [
      AutoRoute(page: HomeRoute.page, path: 'home'),
      AutoRoute(page: HistoryRoute.page, path: 'history'),
    ]),
    AutoRoute(page: DownloadTracksCollectionRouteWithHistoryTracksCollection.page),
    AutoRoute(page: DownloadTracksCollectionRouteWithUrl.page)
  ];
 }     
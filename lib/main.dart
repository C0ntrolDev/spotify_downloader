import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/entities/loading_tracks_collection/loading_tracks_collection_info.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/use_cases/get_loading_tracks_collections_observer.dart';

import 'core/app/spotify_downloader_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MetadataGod.initialize();
  await initInjector();
  runApp(const SpotifyDownloaderApp());

  injector.get<GetLoadingTracksCollectionsObserver>().call(null).then((value) {
    value.result!.loadingTracksCollectionsChangedStream.listen((event) {
      for (var element in value.result!.loadingTracksCollections) {
        element.changedStream.listen((event) {
          printLoadingInfo(element.loadingInfo);
        });
      }
    });
  });
}

void printLoadingInfo(LoadingTracksCollectionInfo loadingTracksCollectionInfo) {
  print(loadingTracksCollectionInfo.tracksCollection!.name);
  print('total tracks:${loadingTracksCollectionInfo.totalTracks}');
  print('loading tracks:${loadingTracksCollectionInfo.loadingTracks}');
  print('loaded tracks:${loadingTracksCollectionInfo.loadedTracks}');
  print('failured tracks:${loadingTracksCollectionInfo.failuredTracks}');
  print('--------------------------------------------------------');
}

import 'dart:async';

import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/entities/loading_tracks_collection/loading_track_observer_with_id.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/entities/loading_tracks_collection/loading_tracks_collection_controller.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/entities/repository/loading_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/entities/repository/loading_tracks_collection_id.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/repository/observe_tracks_loading_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

import '../entities/repository/loading_tracks_collections_observer.dart';

class ObserveTracksLoadingRepositoryImpl implements ObserveTracksLoadingRepository {
  ObserveTracksLoadingRepositoryImpl() {
    _observer = LoadingTracksCollectionsObserver(
        loadingTracksCollectionsChangedStream: _loadingCollectionsChangedStreamController.stream.asBroadcastStream(),
        getLoadingTracksCollections: () => _loadingCollections.map((c) => c.controller.observer).toList());
  }

  final List<LoadingTracksCollection> _loadingCollections = List.empty(growable: true);

  final StreamController<void> _loadingCollectionsChangedStreamController = StreamController();
  late final LoadingTracksCollectionsObserver _observer;

  @override
  Future<LoadingTracksCollectionsObserver> getTracksCollectionsLoadingObserver() async {
    return _observer;
  }

  @override
  void observeLoadingTrack(LoadingTrackObserver loadingTrack, Track track) {
    final loadingTracksCollectionId = LoadingTracksCollectionId(
        spotifyId: track.parentCollection.spotifyId, tracksCollectionType: track.parentCollection.type);

    var loadingCollection = _loadingCollections.where((c) => c.id == loadingTracksCollectionId).firstOrNull;
    if (loadingCollection == null) {
      loadingCollection = LoadingTracksCollection(
          id: loadingTracksCollectionId, controller: LoadingTracksCollectionController(track.parentCollection));
      _loadingCollections.add(loadingCollection);
      _loadingCollectionsChangedStreamController.add(null);
    }

    loadingCollection.controller
        .addLoadingTrack(LoadingTrackObserverWithId(loadingTrackObserver: loadingTrack, spotifyId: track.spotifyId));
  }
}

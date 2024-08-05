import 'dart:async';

import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/observe_tracks_loading/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';



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
  void observeLoadingTrack(LoadingTrackObserver loadingTrackObserver, Track track) {
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
        .observeLoadingTrack(loadingTrackObserver, track);
  }
}

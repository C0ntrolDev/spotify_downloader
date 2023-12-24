import 'dart:async';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/entities/loading_tracks_collection/loading_track_observer_with_id.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/entities/loading_tracks_collection/loading_tracks_collection_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection.dart';

import 'loading_tracks_collection_info.dart';

class LoadingTracksCollectionController {
  LoadingTracksCollectionController(this._sourceTracksCollection) {
    _observer = LoadingTracksCollectionObserver(
        changedStream: _changedStreamController.stream.asBroadcastStream(),
        allLoadedStream: _allLoadedStreamController.stream.asBroadcastStream(),
        getLoadingInfo: () => _loadingInfo);
  }

  final List<LoadingTrackObserverWithId> _loadingTracks = List.empty(growable: true);

  late final LoadingTracksCollectionObserver _observer;
  LoadingTracksCollectionObserver get observer => _observer;

  final TracksCollection _sourceTracksCollection;
  LoadingTracksCollectionInfo _loadingInfo = const LoadingTracksCollectionInfo.empty();

  final StreamController<void> _changedStreamController = StreamController();
  final StreamController<void> _allLoadedStreamController = StreamController();

  void addLoadingTrack(LoadingTrackObserverWithId loadingTrack) {
    final foundLoadingTrack = _loadingTracks.where((l) => l.spotifyId == loadingTrack.spotifyId).firstOrNull;
    if (foundLoadingTrack != null) {
      if (foundLoadingTrack.loadingTrackObserver.status == LoadingTrackStatus.loading ||
          foundLoadingTrack.loadingTrackObserver.status == LoadingTrackStatus.waitInLoadingQueue) return;

      _loadingTracks.remove(foundLoadingTrack);
    }

    _subscribeToLoadingTrack(loadingTrack);
    _loadingTracks.add(loadingTrack);
    _update();
  }

  void _subscribeToLoadingTrack(LoadingTrackObserverWithId loadingTrack) {
    loadingTrack.loadingTrackObserver.loadedStream.listen((event) => _update());
    loadingTrack.loadingTrackObserver.loadingFailureStream.listen((event) => _update());

    loadingTrack.loadingTrackObserver.loadingCancelledStream.listen((event) {
      if (_loadingTracks.contains(loadingTrack)) {
        _loadingTracks.remove(loadingTrack);
      }
      _update();
    });
  }

  void _update() {
    _updateLoadingTracksCollectionInfo();
    _changedStreamController.add(null);
    if (_loadingInfo.loadingTracks == 0) {
      _allLoadedStreamController.add(null);
    }
  }

  void _updateLoadingTracksCollectionInfo() {
    int totalTracks = _loadingTracks.length;
    int loadedTracks = 0;
    int loadingTracks = 0;
    int failuredTracks = 0;

    for (var loadingTrack in _loadingTracks) {
      if (loadingTrack.loadingTrackObserver.status == LoadingTrackStatus.loading ||
          loadingTrack.loadingTrackObserver.status == LoadingTrackStatus.waitInLoadingQueue) {
        loadingTracks++;
        continue;
      }

      if (loadingTrack.loadingTrackObserver.status == LoadingTrackStatus.failure) {
        failuredTracks++;
        continue;
      }

      if (loadingTrack.loadingTrackObserver.status == LoadingTrackStatus.loaded) {
        loadedTracks++;
        continue;
      }
    }

    _loadingInfo = LoadingTracksCollectionInfo(
        totalTracks: totalTracks,
        loadedTracks: loadedTracks,
        loadingTracks: loadingTracks,
        failuredTracks: failuredTracks,
        tracksCollection: _sourceTracksCollection);
  }
}

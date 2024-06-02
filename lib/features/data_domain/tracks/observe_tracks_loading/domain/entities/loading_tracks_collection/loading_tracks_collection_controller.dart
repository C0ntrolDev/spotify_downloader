import 'dart:async';

import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/entities.dart';
import 'package:spotify_downloader/features/data_domain/tracks/observe_tracks_loading/domain/entities/loading_tracks_collection/loading_tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/entities.dart';

class LoadingTracksCollectionController {
  LoadingTracksCollectionController(this._sourceTracksCollection) {
    _observer = LoadingTracksCollectionObserver(
        changedStream: _changedStreamController.stream.asBroadcastStream(),
        allLoadedStream: _allLoadedStreamController.stream.asBroadcastStream(),
        loadingStatusChangedStream: _loadingStatusChangedStreamController.stream.asBroadcastStream(),
        getLoadingInfo: () => _loadingInfo,
        getLoadingStatus: () => _loadingStatus);
  }

  final Map<String, LoadingTrackStatus> _loadingEndedTracks = Map();
  final List<LoadingTrackObserverSubscriptionWithId> _loadingTracks = List.empty(growable: true);

  late final LoadingTracksCollectionObserver _observer;
  LoadingTracksCollectionObserver get observer => _observer;

  final TracksCollection _sourceTracksCollection;
  LoadingTracksCollectionInfo _loadingInfo = const LoadingTracksCollectionInfo.empty();

  LoadingTracksCollectionStatus _loadingStatusField = LoadingTracksCollectionStatus.loading;
  LoadingTracksCollectionStatus get _loadingStatus => _loadingStatusField;
  set _loadingStatus(LoadingTracksCollectionStatus newStatus) {
    if (newStatus != _loadingStatusField) {
      _loadingStatusChangedStreamController.add(null);
    }
    _loadingStatusField = newStatus;
  }

  final StreamController<void> _changedStreamController = StreamController();
  final StreamController<void> _allLoadedStreamController = StreamController();
  final StreamController<void> _loadingStatusChangedStreamController = StreamController();

  void observeLoadingTrack(LoadingTrackObserver loadingTrackObserver, Track track) {
    if (loadingTrackObserver.status == LoadingTrackStatus.loadingCancelled) {
      return;
    }

    final foundLoadingTrack = _loadingTracks.where((l) => l.spotifyId == track.spotifyId).firstOrNull;
    if (foundLoadingTrack != null) {
      return;
    }

    if (_loadingEndedTracks.containsKey(track.spotifyId)) {
      _loadingEndedTracks.remove(track.spotifyId);
    }

    if (loadingTrackObserver.status == LoadingTrackStatus.waitInLoadingQueue ||
        loadingTrackObserver.status == LoadingTrackStatus.loading) {
      _startLoadingTrackObserve(loadingTrackObserver, track);
    } else {
      _loadingEndedTracks[track.spotifyId] = loadingTrackObserver.status;
    }

    _update();
  }

  void _startLoadingTrackObserve(LoadingTrackObserver loadingTrackObserver, Track track) {
    var subs = List<StreamSubscription>.empty(growable: true);
    var loadingTrack = LoadingTrackObserverSubscriptionWithId(
      loadingTrackObserver: loadingTrackObserver, 
      spotifyId: track.spotifyId, 
      loadingTrackObserverSubscribtions: subs);

    var loadedSubscription = loadingTrackObserver.loadedStream.listen((event) => _onTrackLoadingEnded(loadingTrack));
    var failureSubscription = loadingTrackObserver.loadingFailureStream.listen((event) => _onTrackLoadingEnded(loadingTrack));
    var cancelSubscription = loadingTrackObserver.loadingCancelledStream.listen((event) => _onTrackLoadingEnded(loadingTrack));

    subs.addAll([loadedSubscription, failureSubscription, cancelSubscription]);

    _loadingTracks.add(loadingTrack);
  }

  Future _onTrackLoadingEnded(LoadingTrackObserverSubscriptionWithId loadingTrack) async {
    _endLoadingTrackObserve(loadingTrack);

    if(loadingTrack.loadingTrackObserver.status != LoadingTrackStatus.loadingCancelled) {
      _loadingEndedTracks[loadingTrack.spotifyId] = loadingTrack.loadingTrackObserver.status;
    }

    _update();
  }

  Future _endLoadingTrackObserve(LoadingTrackObserverSubscriptionWithId loadingTrack) async {
    if(_loadingTracks.contains(loadingTrack)) {
      _loadingTracks.remove(loadingTrack);
    }

    for (var sub in loadingTrack.loadingTrackObserverSubscribtions) {
      await sub.cancel();
    }
  }

  void _update() {
    _updateLoadingTracksCollectionInfo();
    _changedStreamController.add(null);

    if (_loadingInfo.loadingTracks == 0) {
      _allLoadedStreamController.add(null);
      _loadingStatus = LoadingTracksCollectionStatus.loaded;
    } else {
      _loadingStatus = LoadingTracksCollectionStatus.loading;
    }
  }

  void _updateLoadingTracksCollectionInfo() {
    int totalTracks = _loadingTracks.length + _loadingEndedTracks.length;
    int loadedTracks = 0;
    int loadingTracks = 0;
    int failuredTracks = 0;

    for (var loadingEndTrackStatus in _loadingEndedTracks.values) {
      if (loadingEndTrackStatus == LoadingTrackStatus.failure) {
        failuredTracks++;
        continue;
      }

      if (loadingEndTrackStatus == LoadingTrackStatus.loaded) {
        loadedTracks++;
        continue;
      }
    }

    loadingTracks = _loadingTracks.length;

    _loadingInfo = LoadingTracksCollectionInfo(
        totalTracks: totalTracks,
        loadedTracks: loadedTracks,
        loadingTracks: loadingTracks,
        failuredTracks: failuredTracks,
        tracksCollection: _sourceTracksCollection);
  }
}

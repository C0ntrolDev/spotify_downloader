import 'dart:async';

import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/track.dart';

class TrackWithLoadingObserver {
  TrackWithLoadingObserver({required this.track, LoadingTrackObserver? loadingObserver})
      : _loadingObserver = loadingObserver,
        _onTrackObserverChangedStreamController = StreamController<LoadingTrackObserver?>() {
    onLoadingTrackObserverChangedStream = _onTrackObserverChangedStreamController.stream.asBroadcastStream();
  }

  final Track track;

  LoadingTrackObserver? _loadingObserver;
  LoadingTrackObserver? get loadingObserver => _loadingObserver;
  set loadingObserver(LoadingTrackObserver? value) {
    _loadingObserver = value;
    _onTrackObserverChangedStreamController.add(value);
  }

  final StreamController<LoadingTrackObserver?> _onTrackObserverChangedStreamController;
  late final Stream<LoadingTrackObserver?> onLoadingTrackObserverChangedStream;
}

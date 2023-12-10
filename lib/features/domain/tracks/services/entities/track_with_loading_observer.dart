import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

class TrackWithLoadingObserver {
  TrackWithLoadingObserver({required this.track, LoadingTrackObserver? loadingObserver}) : _loadingObserver = loadingObserver;

  final Track track;

  LoadingTrackObserver? _loadingObserver;
  LoadingTrackObserver? get loadingObserver => _loadingObserver;
  set loadingObserver(LoadingTrackObserver? value) {
    _loadingObserver = value;
    onTrackObserverChanged?.call(value);
  }

  void Function(LoadingTrackObserver?)? onTrackObserverChanged;
}

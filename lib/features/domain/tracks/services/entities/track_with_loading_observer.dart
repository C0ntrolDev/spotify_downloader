import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

class TrackWithLoadingObserver {
  TrackWithLoadingObserver({required this.track});

  final Track track;

  LoadingTrackObserver? _trackObserver;
  LoadingTrackObserver? get loadingObserver => _trackObserver;
  set loadingObserver(LoadingTrackObserver? value) {
    _trackObserver = value;
    onTrackObserverChanged?.call(value);
  }

  void Function(LoadingTrackObserver?)? onTrackObserverChanged;
}

import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

class TrackWithLoadingObserver {
  TrackWithLoadingObserver({required this.track});

  final Track track;

  LoadingTrackObserver? _trackObserver;
  LoadingTrackObserver? get trackObserver => _trackObserver;
  set trackObserver(LoadingTrackObserver? value) {
    _trackObserver = value;
    onTrackObserverChanged?.call();
  }

  void Function()? onTrackObserverChanged;
}

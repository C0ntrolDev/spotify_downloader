import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';

class LoadingTrackObserverWithId {
  LoadingTrackObserverWithId({required this.loadingTrackObserver, required this.spotifyId});
  
  final LoadingTrackObserver loadingTrackObserver;
  final String spotifyId;
}

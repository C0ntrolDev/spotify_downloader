import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_observer.dart';

class LoadingTrackObserverWithId {
  LoadingTrackObserverWithId({required this.loadingTrackObserver, required this.spotifyId});
  
  final LoadingTrackObserver loadingTrackObserver;
  final String spotifyId;
}

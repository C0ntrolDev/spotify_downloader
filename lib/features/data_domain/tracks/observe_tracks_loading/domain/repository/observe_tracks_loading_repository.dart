import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/observe_tracks_loading/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';

abstract class ObserveTracksLoadingRepository {
  void observeLoadingTrack(LoadingTrackObserver loadingTrack, Track track);
  Future<LoadingTracksCollectionsObserver> getTracksCollectionsLoadingObserver();
}

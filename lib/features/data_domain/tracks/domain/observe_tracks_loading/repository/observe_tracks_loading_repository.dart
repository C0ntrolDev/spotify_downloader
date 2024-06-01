import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/track.dart';

import '../entities/repository/loading_tracks_collections_observer.dart';

abstract class ObserveTracksLoadingRepository {
  void observeLoadingTrack(LoadingTrackObserver loadingTrack, Track track);
  Future<LoadingTracksCollectionsObserver> getTracksCollectionsLoadingObserver();
}

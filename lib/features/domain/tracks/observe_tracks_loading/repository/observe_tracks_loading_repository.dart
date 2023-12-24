import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

import '../entities/repository/loading_tracks_collections_observer.dart';

abstract class ObserveTracksLoadingRepository {
  void observeLoadingTrack(LoadingTrackObserver loadingTrack, Track track);
  Future<LoadingTracksCollectionsObserver> getTracksCollectionsLoadingObserver();
}

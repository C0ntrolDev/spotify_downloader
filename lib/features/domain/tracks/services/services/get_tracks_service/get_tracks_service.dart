import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_observer.dart';

abstract class GetTracksService {
  Future<TracksWithLoadingObserverGettingObserver> getTracksWithLoadingObserversFromTracksColleciton(
      {required TracksCollection tracksCollection, required int offset});
      
  TracksWithLoadingObserverGettingObserver getLikedTracksWithLoadingObservers(
      List<TrackWithLoadingObserver> responseList);
}

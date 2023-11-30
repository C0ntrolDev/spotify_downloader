import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_controller.dart';

abstract class TracksService {
  TracksWithLoadingObserverGettingController getTracksWithLoadingObserversFromTracksColleciton(TracksCollection tracksCollection, List<TrackWithLoadingObserver> responseList);
  TracksWithLoadingObserverGettingController getLikedTracksWithLoadingObservers(List<TrackWithLoadingObserver> responseList); 
}
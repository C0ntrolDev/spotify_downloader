import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/domain/entities/tracks_getting_ended_status.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/track_with_loading_observer.dart';

class TracksWithLoadingObserverGettingObserver {
    TracksWithLoadingObserverGettingObserver({
    required this.onEnded,
    required this.onPartGot,
  });


  Stream<Result<Failure, TracksGettingEndedStatus>> onEnded;
  Stream<List<TrackWithLoadingObserver>> onPartGot;
}

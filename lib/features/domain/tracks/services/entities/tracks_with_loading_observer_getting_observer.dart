import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/tracks_getting_ended_status.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';

class TracksWithLoadingObserverGettingObserver {
    TracksWithLoadingObserverGettingObserver({
    required this.onEnded,
    required this.onPartGot,
  });


  Stream<Result<Failure, TracksGettingEndedStatus>> onEnded;
  Stream<List<TrackWithLoadingObserver>> onPartGot;
}

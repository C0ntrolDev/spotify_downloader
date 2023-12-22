import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

abstract class DownloadTracksService {
  Future<Result<Failure, LoadingTrackObserver>> downloadTrack(Track track);

  Future<Result<Failure, void>> dowloadTracksRange(List<TrackWithLoadingObserver> tracksWithLoadingObservers);

  Future<Result<Failure, void>> downloadTracksFromGettingStream(
      TracksWithLoadingObserverGettingObserver tracksWithLoadingObserverGettingObserver);
}

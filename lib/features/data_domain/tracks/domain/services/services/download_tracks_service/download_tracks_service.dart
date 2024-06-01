import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/entities/tracks_with_loading_observer_getting_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/track.dart';

abstract class DownloadTracksService {
  Future<Result<Failure, LoadingTrackObserver>> downloadTrack(Track track);

  Future<Result<Failure, void>> downloadTracksRange(List<TrackWithLoadingObserver> tracksWithLoadingObservers);

  Future<Result<Failure, void>> downloadTracksFromGettingObserver(
      TracksWithLoadingObserverGettingObserver tracksWithLoadingObserverGettingObserver);
  
  Future<Result<Failure , void>> cancelTrackLoading(Track track);
}

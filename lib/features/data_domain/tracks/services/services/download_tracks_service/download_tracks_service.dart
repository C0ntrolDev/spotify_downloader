import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/entities.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/track.dart';

abstract class DownloadTracksService {
  Future<Result<Failure, LoadingTrackObserver>> downloadTrack(Track track);

  Future<Result<Failure, void>> downloadTracksRange(List<TrackWithLoadingObserver> tracksWithLoadingObservers);

  Future<Result<Failure, void>> downloadTracksFromGettingObserver(
      TracksWithLoadingObserverGettingObserver tracksWithLoadingObserverGettingObserver);
  
  Future<Result<Failure , void>> cancelTrackLoading(Track track);
}

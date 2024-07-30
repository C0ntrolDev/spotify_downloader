import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/entities.dart';

abstract class DownloadTracksService {
  Future<Result<Failure, void>> downloadTrack(TrackWithLoadingObserver trackWithLoadingObserver, [String? preselectedYouTubeUrl]);

  Future<Result<Failure, void>> downloadTracksRange(List<TrackWithLoadingObserver> tracksWithLoadingObservers, [Map<TrackWithLoadingObserver, String>? preselectedYouTubeUrls]);

  Future<Result<Failure, void>> downloadTracksFromGettingObserver(
      TracksWithLoadingObserverGettingObserver tracksWithLoadingObserverGettingObserver);
  
  Future<Result<Failure , void>> cancelTrackLoading(TrackWithLoadingObserver track);
}

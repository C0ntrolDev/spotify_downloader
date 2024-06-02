import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services.dart';

class DownloadTracksFromGettingObserver implements UseCase<Failure, void, TracksWithLoadingObserverGettingObserver> {
  DownloadTracksFromGettingObserver({required DownloadTracksService downloadTracksService})
      : _downloadTracksService = downloadTracksService;

  final DownloadTracksService _downloadTracksService;

  @override
  Future<Result<Failure, void>> call(TracksWithLoadingObserverGettingObserver gettingObserver) {
    return _downloadTracksService.downloadTracksFromGettingObserver(gettingObserver);
  }
}

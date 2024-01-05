import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/download_tracks_service/download_tracks_service.dart';

class DownloadTracksFromGettingObserver implements UseCase<Failure, void, TracksWithLoadingObserverGettingObserver> {
  DownloadTracksFromGettingObserver({required DownloadTracksService downloadTracksService})
      : _downloadTracksService = downloadTracksService;

  final DownloadTracksService _downloadTracksService;

  @override
  Future<Result<Failure, void>> call(TracksWithLoadingObserverGettingObserver gettingObserver) {
    return _downloadTracksService.downloadTracksFromGettingObserver(gettingObserver);
  }
}

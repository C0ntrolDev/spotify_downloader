import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services.dart';

class DownloadTracksRange implements UseCase<Failure, void, List<TrackWithLoadingObserver>> {
  DownloadTracksRange({required DownloadTracksService downloadTracksService}) : _downloadTracksService = downloadTracksService;

  final DownloadTracksService _downloadTracksService;

  @override
  Future<Result<Failure, void>> call(List<TrackWithLoadingObserver> tracks) async {
    return _downloadTracksService.downloadTracksRange(tracks);
  }
}
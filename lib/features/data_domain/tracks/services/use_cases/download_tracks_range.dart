import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services.dart';

class DownloadTracksRange implements UseCase<Failure, void, (List<TrackWithLoadingObserver>, Map<TrackWithLoadingObserver, String>)> {
  DownloadTracksRange({required DownloadTracksService downloadTracksService}) : _downloadTracksService = downloadTracksService;

  final DownloadTracksService _downloadTracksService;

  @override
  Future<Result<Failure, void>> call((List<TrackWithLoadingObserver> tracks, Map<TrackWithLoadingObserver, String> preselectedYouTubeUrls) params) async {
    return _downloadTracksService.downloadTracksRange(params.$1, params.$2);
  }
}
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services.dart';

class DownloadTrack implements UseCase<Failure, void, (TrackWithLoadingObserver, String?)> {
  DownloadTrack({required DownloadTracksService downloadTracksService}) : _downloadTracksService = downloadTracksService;

  final DownloadTracksService _downloadTracksService;

  @override
  Future<Result<Failure, void>> call((TrackWithLoadingObserver trackWithLoadingObserver, String? preselectedTracksYouTubeUrl) params) async {
    return _downloadTracksService.downloadTrack(params.$1, params.$2);
  }
}

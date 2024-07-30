import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/entities.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services/services.dart';

class CancelTrackLoading implements UseCase<Failure, void, TrackWithLoadingObserver> {
  CancelTrackLoading({required DownloadTracksService dowloadTracksService})
      : _dowloadTracksService = dowloadTracksService;

  final DownloadTracksService _dowloadTracksService;

  @override
  Future<Result<Failure, void>> call(TrackWithLoadingObserver trackWithLoadingObserver) async {
    return _dowloadTracksService.cancelTrackLoading(trackWithLoadingObserver);
  }
}

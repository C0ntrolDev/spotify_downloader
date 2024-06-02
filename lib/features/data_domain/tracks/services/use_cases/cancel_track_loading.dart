import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services/services.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';

class CancelTrackLoading implements UseCase<Failure, void, Track> {
  CancelTrackLoading({required DownloadTracksService dowloadTracksService})
      : _dowloadTracksService = dowloadTracksService;

  final DownloadTracksService _dowloadTracksService;

  @override
  Future<Result<Failure, void>> call(Track track) async {
    return _dowloadTracksService.cancelTrackLoading(track);
  }
}

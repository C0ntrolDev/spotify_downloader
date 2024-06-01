import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/core/utils/use_case/use_case.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/services/download_tracks_service/download_tracks_service.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/track.dart';

class CancelTrackLoading implements UseCase<Failure, void, Track> {
  CancelTrackLoading({required DownloadTracksService dowloadTracksService})
      : _dowloadTracksService = dowloadTracksService;

  final DownloadTracksService _dowloadTracksService;

  @override
  Future<Result<Failure, void>> call(Track track) async {
    return _dowloadTracksService.cancelTrackLoading(track);
  }
}

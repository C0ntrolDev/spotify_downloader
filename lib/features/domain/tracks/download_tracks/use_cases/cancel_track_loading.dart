import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/repositories/dowload_tracks_repository.dart';

class CancelTrackLoading implements UseCase<Failure, void, Track> {
  CancelTrackLoading({required DownloadTracksRepository dowloadTracksRepository})
      : _dowloadTracksRepository = dowloadTracksRepository;

  final DownloadTracksRepository _dowloadTracksRepository;

  @override
  Future<Result<Failure, void>> call(Track track) async {
    return _dowloadTracksRepository.cancelTrackLoading(track);
  }
}

import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/repositories/dowload_tracks_repository.dart';

class DowloadTrack implements UseCase<Failure, LoadingTrackObserver, Track> {
  DowloadTrack({required DowloadTracksRepository dowloadTracksRepository})
      : _dowloadTracksRepository = dowloadTracksRepository;

  final DowloadTracksRepository _dowloadTracksRepository;

  @override
  Future<Result<Failure, LoadingTrackObserver>> call(Track track) {
    return _dowloadTracksRepository.dowloadTrack(track);
  }
}

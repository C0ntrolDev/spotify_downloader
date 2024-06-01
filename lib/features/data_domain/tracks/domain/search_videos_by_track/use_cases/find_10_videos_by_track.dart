import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/core/utils/use_case/use_case.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/search_videos_by_track/entities/video.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/search_videos_by_track/repositories/search_videos_by_track_repository.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/track.dart';

class Find10VideosByTrack implements UseCase<Failure, List<Video>, Track> {
  Find10VideosByTrack({required SearchVideosByTrackRepository searchVideosByTrackRepository})
      : _searchVideosByTrackRepository = searchVideosByTrackRepository;

  final SearchVideosByTrackRepository _searchVideosByTrackRepository;

  @override
  Future<Result<Failure, List<Video>>> call(Track track) {
    return _searchVideosByTrackRepository.findVideosByTrack(track, 10);
  }
}

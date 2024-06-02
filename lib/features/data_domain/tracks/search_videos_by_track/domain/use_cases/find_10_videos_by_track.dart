import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/search_videos_by_track/search_videos_by_track.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/track.dart';

class Find10VideosByTrack implements UseCase<Failure, List<Video>, Track> {
  Find10VideosByTrack({required SearchVideosByTrackRepository searchVideosByTrackRepository})
      : _searchVideosByTrackRepository = searchVideosByTrackRepository;

  final SearchVideosByTrackRepository _searchVideosByTrackRepository;

  @override
  Future<Result<Failure, List<Video>>> call(Track track) {
    return _searchVideosByTrackRepository.findVideosByTrack(track, 10);
  }
}

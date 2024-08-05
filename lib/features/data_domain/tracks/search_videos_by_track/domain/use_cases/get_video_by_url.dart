import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/search_videos_by_track/search_videos_by_track.dart';

class GetVideoByUrl implements UseCase<Failure, Video, String> {
  GetVideoByUrl({required SearchVideosByTrackRepository searchVideosByTrackRepository})
      : _searchVideosByTrackRepository = searchVideosByTrackRepository;

  final SearchVideosByTrackRepository _searchVideosByTrackRepository;

  @override
  Future<Result<Failure, Video>> call(String url) {
    return _searchVideosByTrackRepository.getVideoByUrl(url);
  }
}

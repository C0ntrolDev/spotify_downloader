import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/tracks/search_videos_by_track/entities/video.dart';
import 'package:spotify_downloader/features/domain/tracks/search_videos_by_track/repositories/search_videos_by_track_repository.dart';

class GetVideoByUrl implements UseCase<Failure, Video, String> {
  GetVideoByUrl({required SearchVideosByTrackRepository searchVideosByTrackRepository})
      : _searchVideosByTrackRepository = searchVideosByTrackRepository;

  final SearchVideosByTrackRepository _searchVideosByTrackRepository;

  @override
  Future<Result<Failure, Video>> call(String url) {
    return _searchVideosByTrackRepository.getVideoByUrl(url);
  }
}

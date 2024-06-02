import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/search_videos_by_track/domain/entities/video.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/track.dart';

abstract class SearchVideosByTrackRepository {
  Future<Result<Failure, Video?>> findVideoByTrack(Track track);
  Future<Result<Failure, List<Video>>> findVideosByTrack(Track track, int count);
  Future<Result<Failure, Video>> getVideoByUrl(String url);
}
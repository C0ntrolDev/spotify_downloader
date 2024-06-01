import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/search_videos_by_track/entities/video.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/track.dart';

abstract class SearchVideosByTrackRepository {
  Future<Result<Failure, Video?>> findVideoByTrack(Track track);
  Future<Result<Failure, List<Video>>> findVideosByTrack(Track track, int count);
  Future<Result<Failure, Video>> getVideoByUrl(String url);
}
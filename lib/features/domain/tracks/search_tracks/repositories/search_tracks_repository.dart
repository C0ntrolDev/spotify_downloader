import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/tracks/search_tracks/entities/video.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

abstract class SearchTracksRepository {
  Future<Result<Failure, Video?>> findVideoByTrack(Track track);
  Future<Result<Failure, List<Video>>> find10VideosByTrack(Track track);
  
}
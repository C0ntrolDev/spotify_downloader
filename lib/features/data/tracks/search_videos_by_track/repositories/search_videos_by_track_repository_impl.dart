import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/tracks/search_videos_by_track/data_sources/search_video_on_youtube_data_source.dart';
import 'package:spotify_downloader/features/data/tracks/search_videos_by_track/repositories/converters/video_dto_to_video_converter.dart';
import 'package:spotify_downloader/features/domain/tracks/search_videos_by_track/entities/video.dart';
import 'package:spotify_downloader/features/domain/tracks/search_videos_by_track/repositories/search_videos_by_track_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

class SearchVideosByTrackRepositoryImpl implements SearchVideosByTrackRepository {
  SearchVideosByTrackRepositoryImpl({required SearchVideoOnYoutubeDataSource searchVideoOnYoutubeDataSource})
      : _searchVideoOnYoutubeDataSource = searchVideoOnYoutubeDataSource;

  final SearchVideoOnYoutubeDataSource _searchVideoOnYoutubeDataSource;
  final VideoDtoToVideoConverter _videoDtoToVideoConverter = VideoDtoToVideoConverter();

  @override
  Future<Result<Failure, List<Video>>> find10VideosByTrack(Track track) async {
    final videosResult = await _searchVideoOnYoutubeDataSource.find10VideosOnYoutube(_generateQuery(track));
    if (videosResult.isSuccessful) {
      final videos = videosResult.result!.map((v) => _videoDtoToVideoConverter.convert(v)).toList();
      return Result.isSuccessful(videos);
    } else {
      return Result.notSuccessful(videosResult.failure);
    }
  }

  @override
  Future<Result<Failure, Video?>> findVideoByTrack(Track track) async {
    final videoResult = await _searchVideoOnYoutubeDataSource.findVideoOnYoutube(_generateQuery(track));
    if (videoResult.isSuccessful) {
      final video = _videoDtoToVideoConverter.convert(videoResult.result!);
      return Result.isSuccessful(video);
    } else {
      return Result.notSuccessful(videoResult.failure);
    }
  }

  @override
  Future<Result<Failure, Video>> getVideoByUrl(String url) async {
    final videoResult = await _searchVideoOnYoutubeDataSource.getVideoByUrl(url);
    if (videoResult.isSuccessful) {
      final video = _videoDtoToVideoConverter.convert(videoResult.result!);
      return Result.isSuccessful(video);
    } else {
      return Result.notSuccessful(videoResult.failure);
    }
  }

  String _generateQuery(Track track) {
    return '${track.name} ${track.artists?.join(', ') ?? ''} audio';
  }
}

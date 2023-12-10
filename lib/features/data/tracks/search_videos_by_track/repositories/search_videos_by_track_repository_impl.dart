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
  Future<Result<Failure, List<Video>>> findVideosByTrack(Track track, int count) async {
    final videosResult =
        await _searchVideoOnYoutubeDataSource.findVideosOnYoutube(_generateQuery(track), count: count);
    if (videosResult.isSuccessful) {
      final videos = videosResult.result!.map((v) => _videoDtoToVideoConverter.convert(v)).toList();
      return Result.isSuccessful(videos);
    } else {
      return Result.notSuccessful(videosResult.failure);
    }
  }

  @override
  Future<Result<Failure, Video?>> findVideoByTrack(Track track) async {
    final videoResult = (await findVideosByTrack(track, 5));
    if (videoResult.isSuccessful) {
      if (videoResult.result?.isEmpty ?? true) {
        return const Result.isSuccessful(null);
      }
      final video = _selectMostAppropriateVideo(videoResult.result!, track);
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

  Video _selectMostAppropriateVideo(List<Video> videos, Track track) {
    List<(int, Video)> videosWithRating = videos.map((video) => (_calculateVideoRating(video, track), video)).toList();
    videosWithRating.sort((first, second) => first.$1.compareTo(second.$1));
    return videosWithRating.reversed.first.$2;
  }

  int _calculateVideoRating(Video video, Track track) {
    int videoRating = 0;

    if (video.title.contains(track.name)) {
      videoRating += 2;
    }

    if (!video.title.contains('video')) {
      videoRating++;
    }

    if (video.title.contains('audio')) {
      videoRating++;
    }

    if (track.artists?.where((artist) => video.author.contains(artist)).isNotEmpty ?? false) {
      videoRating + 3;
    }

    if (track.artists?.where((artist) => video.title.contains(artist)).isNotEmpty ?? false) {
      videoRating++;
    }

    if (track.duration != null && video.duration != null) {
      const durationTolerance = 10;
      if (video.duration!.inSeconds - durationTolerance <= track.duration!.inSeconds &&
          track.duration!.inSeconds <= video.duration!.inSeconds + durationTolerance) {
        videoRating += 3;
      }
    }

    return videoRating;
  }
}

String _generateQuery(Track track) {
  return '${track.name} ${track.artists?.join(', ') ?? ''}';
}

import 'dart:io';
import 'dart:math';

import 'package:http/http.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchVideoOnYoutubeDataSource {
  late final IsolatePool _isolatePool;

  Future<void> init() async {
    _isolatePool = await IsolatePool.create();
  }

  Future<Result<Failure, List<Video>>> findVideosOnYoutube(String searchQuery, {int count = 10}) async {
    final compute = await _isolatePool.compute((searchQuery, token) async {
      final yt = YoutubeExplode();
      try {
        final videos = await yt.search.search(searchQuery);
        yt.close();

        final maxCount = videos.length;
        return Result.isSuccessful(videos.getRange(0, min(maxCount, count)).toList());
      } catch (e, s) {
        yt.close();
        if (e is ClientException || e is SocketException) {
          return Result.notSuccessful(NetworkFailure(stackTrace: s));
        }
        return Result.notSuccessful(Failure(message: e, stackTrace: s));
      }
    }, searchQuery);

    final result = await compute.future;

    if (result.isSuccessful) {
      return Result.isSuccessful(result.result);
    } else {
      return Result.notSuccessful(result.failure);
    }
  }

  Future<Result<Failure, Video>> getVideoByUrl(String url) async {
    final compute = await _isolatePool.compute((url, token) async {
      YoutubeExplode yt = YoutubeExplode();
      try {
        final video = await yt.videos.get(VideoId.parseVideoId(url));
        yt.close();
        return Result.isSuccessful(video);
      } catch (e, s) {
        yt.close();

        if (e is ArgumentError) {
          return Result.notSuccessful(NotFoundFailure(message: 'video with this url not found: $url', stackTrace: s));
        }

        if (e is ClientException || e is SocketException) {
          return Result.notSuccessful(NetworkFailure(stackTrace: s));
        }

        return Result.notSuccessful(Failure(message: e, stackTrace: s));
      }
    }, url);

    final result = await compute.future;

    if (result.isSuccessful) {
      return Result.isSuccessful(result.result);
    } else {
      return Result.notSuccessful(result.failure);
    }
  }
}

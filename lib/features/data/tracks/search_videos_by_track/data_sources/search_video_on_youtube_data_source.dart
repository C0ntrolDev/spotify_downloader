import 'dart:io';
import 'dart:math';

import 'package:http/http.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/isolate_pool/isolate_pool.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
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
      } catch (e) {
        yt.close();
        if (e is ClientException || e is SocketException) {
          return const Result.notSuccessful(NetworkFailure());
        }
        return Result.notSuccessful(Failure(message: e));
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
      } catch (e) {
        yt.close();

        if (e is ArgumentError) {
          return Result.notSuccessful(NotFoundFailure(message: 'video with this url not found: $url'));
        }

        if (e is ClientException || e is SocketException) {
          return const Result.notSuccessful(NetworkFailure());
        }

        return Result.notSuccessful(Failure(message: e));
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

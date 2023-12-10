import 'dart:io';
import 'dart:math';

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

  Future<Result<Failure, Video?>> findVideoOnYoutube(String searchQuery) async {
    final compute = await _isolatePool.compute((searchQuery, token) async {
      final yt = YoutubeExplode();
      try {
        final videos = await yt.search.search(searchQuery);
        yt.close();
        return Result.isSuccessful(videos.firstOrNull);
      } on SocketException {
        yt.close();
        return const Result.notSuccessful(NetworkFailure());
      }
    }, searchQuery);

    final result = await compute.future;

    if (result.isSuccessful) {
      return Result.isSuccessful(result.result);
    } else {
      return Result.notSuccessful(result.failure);
    }
  }

  Future<Result<Failure, List<Video>>> findVideosOnYoutube(String searchQuery, {int count = 10}) async {
    final compute = await _isolatePool.compute((searchQuery, token) async {
      YoutubeExplode yt = YoutubeExplode();
      try {
        final videos = await yt.search.search(searchQuery);
        yt.close();

        final maxCount = videos.length;
        return Result.isSuccessful(videos.getRange(0, min(maxCount, count)).toList());
      } on SocketException {
        yt.close();
        return const Result.notSuccessful(NetworkFailure());
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
      } on SocketException {
        yt.close();
        return const Result.notSuccessful(NetworkFailure());
      } on ArgumentError {
        yt.close();
        return Result.notSuccessful(NotFoundFailure(message: 'video with this url not found: $url'));
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

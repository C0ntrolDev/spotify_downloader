import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchVideoOnYoutubeDataSource {
  Future<Result<Failure, Video?>> findVideoOnYoutube(String searchQuery) async {
    final yt = YoutubeExplode();
    try {
      final videos = await compute((searchQuery) => yt.search.search(searchQuery), searchQuery);
      yt.close();
      return Result.isSuccessful(videos.firstOrNull);
    } on SocketException {
      yt.close();
      return const Result.notSuccessful(NetworkFailure());
    }
  }

  Future<Result<Failure, List<Video>>> find10VideosOnYoutube(String searchQuery) async {
    YoutubeExplode yt = YoutubeExplode();
    try {
      final videos = await yt.search.search(searchQuery);
      yt.close();
      return Result.isSuccessful(videos.getRange(0, 10).toList());
    } on SocketException {
      yt.close();
      return const Result.notSuccessful(NetworkFailure());
    }
  }

  Future<Result<Failure, Video>> getVideoByUrl(String url) async {
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
  }
}

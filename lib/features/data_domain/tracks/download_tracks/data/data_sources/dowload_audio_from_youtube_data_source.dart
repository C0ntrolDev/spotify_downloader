import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' as p;
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/data/data.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/data/data_sources/tools/tools.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DownloadAudioFromYoutubeDataSource {
  DownloadAudioFromYoutubeDataSource(
      {required AudioMetadataEditor audioMetadataEditor, required FileToMp3Converter fileToMp3Converter})
      : _audioMetadataEditor = audioMetadataEditor,
        _fileToMp3Converter = fileToMp3Converter;

  final AudioMetadataEditor _audioMetadataEditor;
  final FileToMp3Converter _fileToMp3Converter;

  late final IsolatePool _isolatePool;

  Future<void> init() async {
    _isolatePool = await IsolatePool.create();
  }

  Future<AudioLoadingStream> dowloadAudioFromYoutube(DownloadAudioFromYoutubeArgs args) async {
    void Function() cancelFunction = () {};

    return AudioLoadingStream(streamFunction: (setLoadingPercent) async {
      try {
        CancellationTokenSource cancellationTokenSource = CancellationTokenSource();
        final token = cancellationTokenSource.token;
        cancelFunction = cancellationTokenSource.cancel;

        final getDownloadStreamInfoCompute = await _isolatePool.compute(_getDownloadStreamInfo, args);
        if (token.isCancelled) {
          getDownloadStreamInfoCompute.cancel();
          return const CancellableResult.isCancelled();
        }

        cancelFunction = getDownloadStreamInfoCompute.cancel;
        final getDownloadStreamInfoResult = await Future.any([
          getDownloadStreamInfoCompute.future,
          Future(() async {
            await Connectivity().onConnectivityChanged.firstWhere((connectivityResult) =>
                connectivityResult == ConnectivityResult.none || connectivityResult == ConnectivityResult.other);
            return const CancellableResult.notSuccessful(NetworkFailure());
          })
        ]);

        if (getDownloadStreamInfoResult.isCancelled) {
          return const CancellableResult.isCancelled();
        } else if (!getDownloadStreamInfoResult.isSuccessful) {
          return CancellableResult.notSuccessful(getDownloadStreamInfoResult.failure);
        }

        final downloadStreamInfo = getDownloadStreamInfoResult.result!;

        final videoPath =
            p.join(args.saveDirectoryPath, '${args.audioMetadata.name}.${downloadStreamInfo.container.name}');
        final audioPath = p.join(args.saveDirectoryPath, '${args.audioMetadata.name}.mp3');

        cancelFunction = cancellationTokenSource.cancel;

        await Directory(args.saveDirectoryPath).create(recursive: true);

        final downloadVideoResult =
            await _downloadVideoFromYoutube(downloadStreamInfo, videoPath, setLoadingPercent, token);

        if (downloadVideoResult.isCancelled) {
          return const CancellableResult.isCancelled();
        } else if (!downloadVideoResult.isSuccessful) {
          return CancellableResult.notSuccessful(downloadVideoResult.failure);
        }

        await _convertFileToMp3(videoPath, audioPath);

        setLoadingPercent.call(95);
        await File(videoPath).delete();

        if (token.isCancelled) {
          await File(audioPath).delete();
          return const CancellableResult.isCancelled();
        }

        final changeMetadataResult =
            await _audioMetadataEditor.changeAudioMetadata(audioPath: audioPath, audioMetadata: args.audioMetadata);
        if (!changeMetadataResult.isSuccessful) {
          await File(audioPath).delete();
          return CancellableResult.notSuccessful(changeMetadataResult.failure);
        }

        if (token.isCancelled) {
          await File(audioPath).delete();
          return const CancellableResult.isCancelled();
        }

        setLoadingPercent.call(100);
        return CancellableResult.isSuccessful(audioPath);
      } catch (e) {
        return CancellableResult.notSuccessful(Failure(message: e));
      }
    }, cancelFunction: () {
      cancelFunction();
    });
  }

  Future<CancellableResult<Failure, AudioOnlyStreamInfo>> _getDownloadStreamInfo(
      DownloadAudioFromYoutubeArgs args, CancellationToken token) async {
    final yt = YoutubeExplode();
    if (token.isCancelled) return const CancellableResult.isCancelled();

    late final Video video;
    late final AudioOnlyStreamInfo downloadStreamInfo;

    try {
      video = await yt.videos.get(VideoId.parseVideoId(args.youtubeUrl));
      if (token.isCancelled) return const CancellableResult.isCancelled();

      final manifest = await yt.videos.streamsClient.getManifest(video.id);
      if (token.isCancelled) return const CancellableResult.isCancelled();

      downloadStreamInfo = manifest.audioOnly.withHighestBitrate();
    } catch (e) {
      yt.close();
      if (e is ClientException || e is SocketException) {
        return const CancellableResult.notSuccessful(NetworkFailure());
      }

      if (e is ArgumentError) {
        return CancellableResult.notSuccessful(
            NotFoundFailure(message: 'video with this url not found: ${args.youtubeUrl}'));
      }

      return CancellableResult.notSuccessful(Failure(message: e));
    }

    yt.close();
    return CancellableResult.isSuccessful(downloadStreamInfo);
  }

  Future<CancellableResult<Failure, void>> _downloadVideoFromYoutube(AudioOnlyStreamInfo downloadStreamInfo,
      String savePath, void Function(double percent) setLoadingPercent, CancellationToken token) async {
    try {
      final yt = YoutubeExplode();
      final downloadStream = yt.videos.streamsClient.get(downloadStreamInfo);
      final videoFile = File(savePath);

      if (await videoFile.exists()) {
        await videoFile.delete();
      }

      await videoFile.create();
      final videoFileStream = videoFile.openWrite();

      late final StreamSubscription<List<int>> downloadStreamListener;

      final videoFileSize = downloadStreamInfo.size.totalBytes;
      int loadedBytesCount = 0;

      final cancellationTokenCompleter = Completer<Void?>();
      final failureCompleter = Completer<Failure>();

      downloadStreamListener = downloadStream.listen((chunk) async {
        if (token.isCancelled) {
          if (!cancellationTokenCompleter.isCompleted) {
            cancellationTokenCompleter.complete(null);
          }
          return;
        }

        try {
          videoFileStream.add(chunk);
        } catch (e) {
          if (!failureCompleter.isCompleted) {
            failureCompleter.complete(Failure(message: e));
          }
        }

        loadedBytesCount += chunk.length;
        setLoadingPercent.call((loadedBytesCount / videoFileSize) * 90);
      })
        ..onError((e) {
          if (!failureCompleter.isCompleted) {
            failureCompleter.complete(Failure(message: e));
          }
        });

      Failure failure = const Failure(message: '');

      var connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) async {
        if(result == ConnectivityResult.none || result == ConnectivityResult.other) {
          if (!failureCompleter.isCompleted) {
            failureCompleter.complete(const NetworkFailure());
          }
        }
      });

      await Future.any([
        downloadStreamListener.asFuture(),
        cancellationTokenCompleter.future,
        (() async {
          failure = await failureCompleter.future;
        }).call(),
      ]);

      await videoFileStream.flush();
      await videoFileStream.close();
      yt.close();

      await connectivitySubscription.cancel();

      if (failureCompleter.isCompleted) {
        return CancellableResult.notSuccessful(failure);
      }

      if (cancellationTokenCompleter.isCompleted) {
        await videoFile.delete();
        return const CancellableResult.isCancelled();
      }

      return const CancellableResult.isSuccessful(null);
    } catch (e) {
      return CancellableResult.notSuccessful(Failure(message: e));
    }
  }

  Future<void> _convertFileToMp3(String rawPath, String audioPath) async {
    final audioFile = File(audioPath);
    if (await audioFile.exists()) {
      await audioFile.delete();
    }
    await _fileToMp3Converter.convertFileToMp3(rawPath, audioPath);
  }
}

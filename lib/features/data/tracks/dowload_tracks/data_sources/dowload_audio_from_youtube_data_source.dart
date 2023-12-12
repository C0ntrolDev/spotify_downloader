import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path/path.dart' as p;
import 'package:spotify_downloader/core/util/cancellation_token/cancellation_token.dart';
import 'package:spotify_downloader/core/util/cancellation_token/cancellation_token_source.dart';
import 'package:spotify_downloader/core/util/isolate_pool/isolate_pool.dart';
import 'package:spotify_downloader/core/util/result/cancellable_result.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';

import 'package:spotify_downloader/features/data/tracks/dowload_tracks/data_sources/tools/audio_metadata_editor/audio_metadata_editor.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/data_sources/tools/file_to_mp3_converter/file_to_mp3_converter.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/dowload_audio_from_youtube_args.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/loading_stream/audio_loading_stream.dart';

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

        final getDownloadStreamInfoResult = await getDownloadStreamInfoCompute.future;
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
    } on SocketException {
      yt.close();
      return const CancellableResult.notSuccessful(NetworkFailure());
    } on ArgumentError {
      yt.close();
      return CancellableResult.notSuccessful(
          NotFoundFailure(message: 'video with this url not found: ${args.youtubeUrl}'));
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

          videoFileStream.add(chunk);

          loadedBytesCount += chunk.length;
          setLoadingPercent.call((loadedBytesCount / videoFileSize) * 90);

      })..onError((e) {
         if (!failureCompleter.isCompleted) {
            failureCompleter.complete(Failure(message: e));
          }
      });

      Failure failure = const Failure(message: '');

      Connectivity()
          .onConnectivityChanged
          .firstWhere((result) => result == ConnectivityResult.none || result == ConnectivityResult.other)
          .then((value) {
        if (!failureCompleter.isCompleted) {
          failureCompleter.complete(const NetworkFailure());
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

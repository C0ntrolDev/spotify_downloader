import 'dart:async';
import 'dart:ffi';
import 'dart:io';

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
      final videoLoadingStream = await _isolatePool.add((sendPort, params, token) async {
        final downloadingResult = await _downloadVideoFromYoutubeByArgs((
          args,
          (value) {
            sendPort.send(value);
          }
        ), token);

        sendPort.send(downloadingResult);
      }, (null));

      videoLoadingStream.stream.listen((message) {
        if (message is double) {
          setLoadingPercent(message);
        }
      });
      cancelFunction = videoLoadingStream.cancel;

      final videoLoadingResult =
          await videoLoadingStream.stream.firstWhere((element) => element is CancellableResult<Failure, String>);
      if (videoLoadingResult.isCancelled) {
        return const CancellableResult.isCancelled();
      }
      if (!videoLoadingResult.isSuccessful) {
        return CancellableResult.notSuccessful(videoLoadingResult.failure);
      }
      final rawPath = videoLoadingResult.result!;
      final audioPath = p.join(args.saveDirectoryPath, '${args.audioMetadata.name}.mp3');

      CancellationTokenSource cancellationTokenSource = CancellationTokenSource();
      cancelFunction = cancellationTokenSource.cancel;
      final token = cancellationTokenSource.token;

      await _convertFileToMp3(rawPath, audioPath);

      setLoadingPercent.call(95);
      await File(rawPath).delete();

      if (token.isCancelled) {
        return const CancellableResult.isCancelled();
      }

      await _audioMetadataEditor.changeAudioMetadata(audioPath: audioPath, audioMetadata: args.audioMetadata);

      if (token.isCancelled) {
        final audioFile = File(audioPath);
        audioFile.delete();
        return const CancellableResult.isCancelled();
      }

      setLoadingPercent.call(100);
      return CancellableResult.isSuccessful(audioPath);
    }, cancelFunction: () {
      cancelFunction();
    });
  }

  Future<CancellableResult<Failure, String>> _downloadVideoFromYoutubeByArgs(
      (DownloadAudioFromYoutubeArgs args, Function(double) setLoadingPercent) params, CancellationToken token) async {
    final args = params.$1;
    final setLoadingPercent = params.$2;

    final yt = YoutubeExplode();

    late final Video video;
    late final AudioOnlyStreamInfo downloadStreamInfo;

    try {
      video = await yt.videos.get(VideoId.parseVideoId(args.youtubeUrl));
      final manifest = await yt.videos.streamsClient.getManifest(video.id);
      downloadStreamInfo = manifest.audioOnly.withHighestBitrate();
    } on SocketException {
      yt.close();
      return const CancellableResult.notSuccessful(NetworkFailure());
    } on ArgumentError {
      yt.close();
      return CancellableResult.notSuccessful(
          NotFoundFailure(message: 'video with this url not found: ${args.youtubeUrl}'));
    }

    final videoPath =
        p.join(args.saveDirectoryPath, '${args.audioMetadata.name}.${downloadStreamInfo.container.name}');
    final downloadResult =
        await _downloadVideoFromYoutube(yt, downloadStreamInfo, videoPath, setLoadingPercent, token);

    yt.close();

    if (downloadResult.isCancelled) {
      return const CancellableResult.isCancelled();
    }

    if (!downloadResult.isSuccessful) {
      return CancellableResult.notSuccessful(downloadResult.failure);
    }

    return CancellableResult.isSuccessful(videoPath);
  }

  Future<CancellableResult<Failure, File>> _downloadVideoFromYoutube(
      YoutubeExplode yt,
      AudioOnlyStreamInfo downloadStreamInfo,
      String rawPath,
      void Function(double percent) setLoadingPercent,
      CancellationToken token) async {
    final downloadStream = yt.videos.streamsClient.get(downloadStreamInfo);
    final videoFileSize = downloadStreamInfo.size.totalBytes;
    final videoFile = File(rawPath);
    final videoFileStream = videoFile.openWrite();

    late final StreamSubscription<List<int>> downloadStreamListener;
    int loadedBytesCount = 0;

    final cancellationTokenCompleter = Completer<Void?>();

    downloadStreamListener = downloadStream.listen((chunk) {
      try {
        videoFileStream.add(chunk);

        loadedBytesCount += chunk.length;
        setLoadingPercent.call((loadedBytesCount / videoFileSize) * 90);

        if (token.isCancelled) {
          cancellationTokenCompleter.complete(null);
        }
      // ignore: empty_catches
      } catch (e) {}
    });

    await Future.any([
      downloadStreamListener.asFuture(),
      cancellationTokenCompleter.future,
    ]);

    await videoFileStream.flush();
    await videoFileStream.close();

    if (token.isCancelled) {
      await videoFile.delete();
      return const CancellableResult.isCancelled();
    } else {
      return CancellableResult.isSuccessful(videoFile);
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

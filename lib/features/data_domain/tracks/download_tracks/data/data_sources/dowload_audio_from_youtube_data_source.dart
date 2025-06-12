import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' as p;
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/data/data.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/data/data_sources/tools/bitrate_editor/audio_bitrate_editor.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/data/data_sources/tools/tools.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DownloadAudioFromYoutubeDataSource {
  DownloadAudioFromYoutubeDataSource(
      {required AudioMetadataEditor audioMetadataEditor,
      required FileToMp3Converter fileToMp3Converter,
      required AudioBitrateEditor audioBitrateEditor})
      : _audioMetadataEditor = audioMetadataEditor,
        _fileToMp3Converter = fileToMp3Converter,
        _audioBitrateEditor = audioBitrateEditor;

  final AudioMetadataEditor _audioMetadataEditor;
  final FileToMp3Converter _fileToMp3Converter;
  final AudioBitrateEditor _audioBitrateEditor;

  late final IsolatePool _isolatePool;

  Future<void> init() async {
    _isolatePool = await IsolatePool.create();
  }

  Future<AudioLoadingStream> dowloadAudioFromYoutube(DownloadAudioFromYoutubeArgs args) async {
    CancellationTokenSource cancellationTokenSource = CancellationTokenSource();
    final token = cancellationTokenSource.token;

    return AudioLoadingStream(streamFunction: (setLoadingPercent) async {
      try {
        final downloadVideoResult = await _getAndDownloadVideoFromYoutube(args, token, setLoadingPercent);
        if (!downloadVideoResult.isSuccessful) {
          if (downloadVideoResult.isCancelled) {
            return const CancellableResult.isCancelled();
          } else {
            return CancellableResult.notSuccessful(downloadVideoResult.failure);
          }
        }

        final videoPath = downloadVideoResult.result!.$1;
        final bitrate = downloadVideoResult.result!.$2;
        final audioPath = p.join(
          args.saveDirectoryPath,
          '${args.audioMetadata.name}.mp3',
        );

        await _convertFileToMp3(videoPath, audioPath);

        setLoadingPercent.call(95);
        await File(videoPath).delete();

        if (token.isCancelled) {
          await File(audioPath).delete();
          return const CancellableResult.isCancelled();
        }

        final changeBitrateResult = await _audioBitrateEditor.changeBitrate(audioPath, bitrate.floor());
        if (!changeBitrateResult.isSuccessful) {
          await File(audioPath).delete();
          return CancellableResult.notSuccessful(changeBitrateResult.failure);
        }

        setLoadingPercent.call(97);

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
      } catch (e, s) {
        return CancellableResult.notSuccessful(Failure(message: e, stackTrace: s));
      }
    }, cancelFunction: () {
      cancellationTokenSource.cancel();
    });
  }

  Future<CancellableResult<Failure, (String, double)>> _getAndDownloadVideoFromYoutube(
      DownloadAudioFromYoutubeArgs args, CancellationToken token, Function(double) setLoadingPercent) async {
    Completer noNetworkCompleter = Completer();
    final noNetworkSub = Connectivity().onConnectivityChanged.listen((connection) {
      if (connection == ConnectivityResult.none || connection == ConnectivityResult.other) {
        noNetworkCompleter.complete();
      }
    });

    try {
      final getDownloadStreamInfoCompute = await _isolatePool.compute(_getDownloadStreamInfo, args);
      if (token.isCancelled) {
        getDownloadStreamInfoCompute.cancel();
        return const CancellableResult.isCancelled();
      } else if (noNetworkCompleter.isCompleted) {
        getDownloadStreamInfoCompute.cancel();
        return const CancellableResult.notSuccessful(NetworkFailure());
      }

      noNetworkCompleter = Completer();
      final tokenWhileGettingStreamSub =
          token.cancelationStream.listen((event) => getDownloadStreamInfoCompute.cancel());
      final getDownloadStreamInfoResult =
          await Future.any([getDownloadStreamInfoCompute.future, noNetworkCompleter.future]);

      try {
        if (noNetworkCompleter.isCompleted) {
          getDownloadStreamInfoCompute.cancel();
          return const CancellableResult.notSuccessful(NetworkFailure());
        }

        if (getDownloadStreamInfoResult.isCancelled) {
          return const CancellableResult.isCancelled();
        } else if (!getDownloadStreamInfoResult.isSuccessful) {
          return CancellableResult.notSuccessful(getDownloadStreamInfoResult.failure);
        }
      } finally {
        tokenWhileGettingStreamSub.cancel();
      }

      final downloadStreamInfo = getDownloadStreamInfoResult.result! as AudioOnlyStreamInfo;
      //---------------------------------------------------------------------------------

      final videoPath =
          p.join(args.saveDirectoryPath, '${args.audioMetadata.name}.${downloadStreamInfo.container.name}');

      await Directory(args.saveDirectoryPath).create(recursive: true);

      final downloadVideoStream = await _isolatePool
          .add<(AudioOnlyStreamInfo, String)>(_downloadVideoFromYoutubeInIsolate, (downloadStreamInfo, videoPath));
      if (token.isCancelled) {
        downloadVideoStream.cancel();
        return const CancellableResult.isCancelled();
      } else if (noNetworkCompleter.isCompleted) {
        downloadVideoStream.cancel();
        return const CancellableResult.notSuccessful(NetworkFailure());
      }

      noNetworkCompleter = Completer();
      final tokenWhileDownloadVideoSub = token.cancelationStream.listen((event) => downloadVideoStream.cancel());
      final downloadVideoResult =
          await Future.any([_handleDownloadStream(downloadVideoStream, setLoadingPercent), noNetworkCompleter.future]);

      try {
        if (noNetworkCompleter.isCompleted) {
          downloadVideoStream.cancel();
          return const CancellableResult.notSuccessful(NetworkFailure());
        }

        if (downloadVideoResult.isCancelled) {
          return const CancellableResult.isCancelled();
        } else if (!downloadVideoResult.isSuccessful) {
          return CancellableResult.notSuccessful(downloadVideoResult.failure);
        }
      } finally {
        tokenWhileDownloadVideoSub.cancel();
      }

      return CancellableResult.isSuccessful((videoPath, downloadStreamInfo.bitrate.kiloBitsPerSecond));
    } finally {
      noNetworkSub.cancel();
    }
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

      final manifest = await yt.videos.streams.getManifest(video.id, ytClients: [YoutubeApiClient.android, YoutubeApiClient.ios]);
      if (token.isCancelled) return const CancellableResult.isCancelled();

      downloadStreamInfo = manifest.audioOnly.withHighestBitrate();
      return CancellableResult.isSuccessful(downloadStreamInfo);
    } catch (e, s) {
      if (e is ClientException || e is SocketException) {
        return CancellableResult.notSuccessful(NetworkFailure(stackTrace: s));
      }

      if (e is ArgumentError) {
        return CancellableResult.notSuccessful(
            NotFoundFailure(message: 'video with this url not found: ${args.youtubeUrl}', stackTrace: s));
      }

      return CancellableResult.notSuccessful(Failure(message: e));
    } finally {
      yt.close();
    }
  }

  Future<void> _downloadVideoFromYoutubeInIsolate(
      SendPort sendPort, (AudioOnlyStreamInfo, String) params, CancellationToken token) async {
    final downloadStreamInfo = params.$1;
    final savePath = params.$2;

    YoutubeExplode? yt;
    StreamSubscription<List<int>>? downloadStreamListener;
    IOSink? videoFileStream;

    try {
      yt = YoutubeExplode();
      final downloadStream = yt.videos.streamsClient.get(downloadStreamInfo);
      final videoFile = File(savePath);

      if (await videoFile.exists()) {
        await videoFile.delete();
      }

      await videoFile.create();
      videoFileStream = videoFile.openWrite();

      final videoFileSize = downloadStreamInfo.size.totalBytes;
      int loadedBytesCount = 0;

      double previousSendedPercent = 0;

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
          videoFileStream!.add(chunk);
        } catch (e, s) {
          if (!failureCompleter.isCompleted) {
            failureCompleter.complete(Failure(message: e, stackTrace: s));
          }
        }

        loadedBytesCount += chunk.length;

        final percent = (loadedBytesCount / videoFileSize) * 90;
        if (percent - previousSendedPercent >= 2 || percent > 90 - 1) {
          sendPort.send(percent);
          previousSendedPercent = percent;
        }
      })
        ..onError((e) {
          if (!failureCompleter.isCompleted) {
            failureCompleter.complete(Failure(message: e));
          }
        });

      Failure failure = const Failure(message: '');

      await Future.any(
          [downloadStreamListener.asFuture(), cancellationTokenCompleter.future, failureCompleter.future]);

      if (failureCompleter.isCompleted) {
        sendPort.send(CancellableResult.notSuccessful(failure));
        return;
      }

      if (cancellationTokenCompleter.isCompleted) {
        await videoFile.delete();
        sendPort.send(const CancellableResult.isCancelled());
        return;
      }

      sendPort.send(const CancellableResult.isSuccessful(null));
    } catch (e, s) {
      sendPort.send(CancellableResult.notSuccessful(Failure(message: e, stackTrace: s)));
    } finally {
      yt?.close();
      downloadStreamListener?.cancel();
      await videoFileStream?.flush();
      await videoFileStream?.close();
    }
  }

  Future<CancellableResult> _handleDownloadStream(
      CancellableStream downloadVideoStream, Function(double) setLoadingPercent) async {
    final downloadVideoCompleter = Completer<CancellableResult>();

    final downloadVideoStreamSub = downloadVideoStream.stream.listen((event) {
      if (event is double) {
        setLoadingPercent(event);
      }

      if (event is CancellableResult) {
        downloadVideoCompleter.complete(event);
      }
    });

    final result = await downloadVideoCompleter.future;
    downloadVideoStreamSub.cancel();
    return result;
  }

  Future<void> _convertFileToMp3(String rawPath, String audioPath) async {
    final audioFile = File(audioPath);
    if (await audioFile.exists()) {
      await audioFile.delete();
    }
    await _fileToMp3Converter.convertFileToMp3(rawPath, audioPath);
  }
}

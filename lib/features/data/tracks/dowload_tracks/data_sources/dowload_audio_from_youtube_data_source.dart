// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:io'; 

import 'package:path/path.dart' as p;
import 'package:spotify_downloader/core/util/cancellation_token/cancellation_token.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/loading_stream/audio_loading_result.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';

import 'package:spotify_downloader/features/data/tracks/dowload_tracks/data_sources/tools/audio_metadata_editor/audio_metadata_editor.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/data_sources/tools/file_to_mp3_converter/file_to_mp3_converter.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/dowload_audio_from_youtube_args.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/loading_stream/audio_loading_stream.dart';

class DowloadAudioFromYoutubeDataSource {
  DowloadAudioFromYoutubeDataSource(
      {required AudioMetadataEditor audioMetadataEditor, required FileToMp3Converter fileToMp3Converter})
      : _audioMetadataEditor = audioMetadataEditor,
        _fileToMp3Converter = fileToMp3Converter;

  final AudioMetadataEditor _audioMetadataEditor;
  final FileToMp3Converter _fileToMp3Converter;

  AudioLoadingStream dowloadAudioFromYoutube(DowloadAudioFromYoutubeArgs args) {
    return AudioLoadingStream((cancellationToken, setLoadingPercent) async {
      try {
        final yt = YoutubeExplode();

        final Video video;
        final AudioOnlyStreamInfo downloadStreamInfo;

        try {
          video = await yt.videos.get(VideoId.parseVideoId(args.youtubeUrl));
          final manifest = await yt.videos.streamsClient.getManifest(video.id);
          downloadStreamInfo = manifest.audioOnly.withHighestBitrate();
        } on SocketException {
          yt.close(); 
          return Result.notSuccessful(NetworkFailure());
        } on ArgumentError {
          yt.close();
          return Result.notSuccessful(NotFoundFailure(message: 'video with this url not found: ${args.youtubeUrl}'));
        }
        final rawPath =
            p.join(args.saveDirectoryPath, '${args.audioMetadata.name}${downloadStreamInfo.container.name}');
        final audioPath = p.join(args.saveDirectoryPath, '${args.audioMetadata.name}.mp3');

        if (downloadStreamInfo != null) {
          File rawFile =
              await _downloadVideoFromYoutube(yt, downloadStreamInfo, rawPath, setLoadingPercent, cancellationToken);
          yt.close();

          if (cancellationToken.isCancelled) {
            await rawFile.delete();
            return const Result.isSuccessful(AudioLoadingResult.isCancelled());
          }

          _convertFileToMp3(rawPath, audioPath);

          setLoadingPercent.call(95);
          await rawFile.delete();

          if (cancellationToken.isCancelled) {
            return const Result.isSuccessful(AudioLoadingResult.isCancelled());
          }

          await _audioMetadataEditor.changeAudioMetadata(
              audioPath: audioPath,
              audioMetadata: args.audioMetadata.copyWith(durationMs: video.duration?.inMilliseconds.toDouble()));

          if (cancellationToken.isCancelled) {
            final audioFile = File(audioPath);
            audioFile.delete();
            return const Result.isSuccessful(AudioLoadingResult.isCancelled());
          }

          setLoadingPercent.call(100);
          return Result.isSuccessful(AudioLoadingResult.isLoaded(audioPath));
        } else {
          return Result.notSuccessful(NotFoundFailure());
        }
      } catch (e) {
        return Result.notSuccessful(Failure(message: e));
      }
    });
  }

  Future<File> _downloadVideoFromYoutube(YoutubeExplode yt, AudioOnlyStreamInfo downloadStreamInfo, String rawPath,
      Function(double percent) setLoadingPercent, CancellationToken cancellationToken) async {
    final downloadStream = yt.videos.streamsClient.get(downloadStreamInfo);
    final rawFileSize = downloadStreamInfo.size.totalBytes;
    final rawFile = File(rawPath);
    final rawFileStream = rawFile.openWrite();

    late final StreamSubscription<List<int>> downloadStreamListener;
    int loadedBytesCount = 0;
    downloadStreamListener = downloadStream.listen((chunk) {
      rawFileStream.add(chunk);

      loadedBytesCount += chunk.length;
      setLoadingPercent.call((loadedBytesCount / rawFileSize) * 90);

      if (cancellationToken.isCancelled) {
        downloadStreamListener.cancel();
      }
    });

    await downloadStreamListener.asFuture();
    await rawFileStream.flush();
    await rawFileStream.close();
    return rawFile;
  }

  Future<void> _convertFileToMp3(String rawPath, String audioPath) async {
    final audioFile = File(audioPath);
    if (await audioFile.exists()) {
      await audioFile.delete();
    }

    await _fileToMp3Converter.convertFileToMp3(rawPath, audioPath);
  }
}

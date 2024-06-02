import 'dart:async';

import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_status.dart';

class LoadingTrackObserver {
  LoadingTrackObserver(
      {required this.startLoadingStream,
      required this.loadingPercentChangedStream,
      required this.loadedStream,
      required this.loadingCancelledStream,
      required this.loadingFailureStream,
      required LoadingTrackStatus Function() getLoadingTrackStatus})
      : _getLoadingTrackStatus = getLoadingTrackStatus {

    startLoadingStream.listen((youtubeUrl) => _youtubeUrl = youtubeUrl);
    loadingPercentChangedStream.listen((percent) => _loadingPercent = percent);
    loadedStream.listen((savePath) => _resultSavePath = savePath);
    loadingFailureStream.listen((failure) => _failure = failure);
  }

  final Stream<String> startLoadingStream;
  final Stream<double?> loadingPercentChangedStream;
  final Stream<String> loadedStream;
  final Stream<void> loadingCancelledStream;
  final Stream<Failure?> loadingFailureStream;

  final LoadingTrackStatus Function() _getLoadingTrackStatus;
  LoadingTrackStatus get status => _getLoadingTrackStatus.call();

  String? _youtubeUrl;
  String? get youtubeUrl => _youtubeUrl;


  double? _loadingPercent;
  double? get loadingPercent => _loadingPercent;

  String? _resultSavePath;
  String? get resultSavePath => _resultSavePath;

  Failure? _failure;
  Failure? get failure => _failure;
}

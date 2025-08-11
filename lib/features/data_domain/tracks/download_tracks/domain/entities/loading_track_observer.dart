import 'dart:async';

import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_status.dart';

class LoadingTrackObserver {
  LoadingTrackObserver(
      {
      required this.loadingTrackStatusStream,
      required LoadingTrackStatus Function() getLoadingTrackStatus})
      : _getLoadingTrackStatus = getLoadingTrackStatus {
    
    loadingTrackStatusStream.listen((status) {
      if (status is LoadingTrackStatusLoading) {
        _youtubeUrl = status.youTubeUrl;
        _loadingPercent = status.percent;
      }
      if (status is LoadingTrackStatusLoaded) {
        _resultSavePath = status.savePath;
      }

      if (status is LoadingTrackStatusFailure) {
        _failure = status.failure;
      }

      if (status is LoadingTrackStatusFailure || status is LoadingTrackStatusCancelled) {
        _loadingPercent = null;
      }
    });
  }

  final LoadingTrackStatus Function() _getLoadingTrackStatus;
  LoadingTrackStatus get status => _getLoadingTrackStatus.call();
  final Stream<LoadingTrackStatus> loadingTrackStatusStream;

  String? _youtubeUrl;
  String? get youtubeUrl => _youtubeUrl;

  double? _loadingPercent;
  double? get loadingPercent => _loadingPercent;

  String? _resultSavePath;
  String? get resultSavePath => _resultSavePath;

  Failure? _failure;
  Failure? get failure => _failure;
}

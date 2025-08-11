import 'dart:async';

import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_status.dart';

class TrackLoadingNotifier {
  final StreamController<LoadingTrackStatus> _loadingTrackStatusStreamController =
      StreamController<LoadingTrackStatus>();

  LoadingTrackObserver? _loadingTrackObserver;
  LoadingTrackObserver get loadingTrackObserver => _loadingTrackObserver ??= LoadingTrackObserver(
      loadingTrackStatusStream: _loadingTrackStatusStreamController.stream.asBroadcastStream(),
      getLoadingTrackStatus: () => _status);

  LoadingTrackStatus _statusField = LoadingTrackStatusWaitInLoadingQueue();
  LoadingTrackStatus get _status => _statusField;
  set _status(LoadingTrackStatus newStatus) {
    _statusField = newStatus;
    _loadingTrackStatusStreamController.add(newStatus);
  }

  void startLoading(String youtubeUrl) {
    if (_status is LoadingTrackStatusWaitInLoadingQueue) {
      _status = LoadingTrackStatusLoading(youTubeUrl: youtubeUrl);
    }
  }

  void loadingPercentChanged(double? percent) {
    if (_status is LoadingTrackStatusLoading) {
      _status = LoadingTrackStatusLoading(youTubeUrl: (_status as LoadingTrackStatusLoading).youTubeUrl, percent: percent);
    }
  }

  void loaded(String savePath) {
    if (_status is LoadingTrackStatusLoading) {
      _status = LoadingTrackStatusLoaded(savePath: savePath);
      _closeAllStreams();
    }
  }

  void loadingCancelled() {
    if (_status is LoadingTrackStatusLoading || _status is LoadingTrackStatusWaitInLoadingQueue) {
      _status = LoadingTrackStatusCancelled();
      _closeAllStreams();
    }
  }

  void loadingFailure(Failure? failure) {
    if (_status is LoadingTrackStatusLoading ||
        _status is LoadingTrackStatusWaitInLoadingQueue ||
        _status is LoadingTrackStatusCancelled) {
      _status = LoadingTrackStatusFailure(failure: failure);
      _closeAllStreams();
    }
  }

  Future<void> _closeAllStreams() async {
    await _loadingTrackStatusStreamController.close();
  }
}

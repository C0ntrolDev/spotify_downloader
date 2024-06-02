import 'dart:async';

import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_status.dart';

class TrackLoadingNotifier {
  final StreamController<String> _startLoadingStreamController = StreamController<String>();
  final StreamController<double?> _loadingPercentChangedStreamController = StreamController<double?>();
  final StreamController<String> _loadedStreamController = StreamController<String>();
  final StreamController<void> _loadingCancelledStreamController = StreamController<void>();
  final StreamController<Failure?> _loadingFailureStreamController = StreamController<Failure?>();

  LoadingTrackObserver? _loadingTrackObserver;
  LoadingTrackObserver get loadingTrackObserver => _loadingTrackObserver ??= LoadingTrackObserver(
      startLoadingStream: _startLoadingStreamController.stream.asBroadcastStream(),
      loadingPercentChangedStream: _loadingPercentChangedStreamController.stream.asBroadcastStream(),
      loadedStream: _loadedStreamController.stream.asBroadcastStream(),
      loadingCancelledStream: _loadingCancelledStreamController.stream.asBroadcastStream(),
      loadingFailureStream: _loadingFailureStreamController.stream.asBroadcastStream(),
      getLoadingTrackStatus: () => _status);

  LoadingTrackStatus _status = LoadingTrackStatus.waitInLoadingQueue;

  void startLoading(String youtubeUrl) {
    if (_status == LoadingTrackStatus.waitInLoadingQueue) {
      _status = LoadingTrackStatus.loading;
      _startLoadingStreamController.add(youtubeUrl);
    }
  }

  void loadingPercentChanged(double? percent) {
    if (_status == LoadingTrackStatus.loading) {
      _status = LoadingTrackStatus.loading;
      _loadingPercentChangedStreamController.add(percent);
    }
  }

  void loaded(String savePath) {
    if (_status == LoadingTrackStatus.loading) {
      _status = LoadingTrackStatus.loaded;
      _loadedStreamController.add(savePath);
      _closeAllStreams();
    }
  }

  void loadingCancelled() {
    if (_status == LoadingTrackStatus.loading || _status == LoadingTrackStatus.waitInLoadingQueue) {
      _status = LoadingTrackStatus.loadingCancelled;
      _loadingCancelledStreamController.add(null);
      _closeAllStreams();
    }
  }

  void loadingFailure(Failure? failure) {
    if (_status == LoadingTrackStatus.loading ||
        _status == LoadingTrackStatus.waitInLoadingQueue ||
        _status == LoadingTrackStatus.loadingCancelled) {
      _status = LoadingTrackStatus.failure;
      _loadingFailureStreamController.add(failure);
      _closeAllStreams();
    }
  }

  Future<void> _closeAllStreams() async {
    await _startLoadingStreamController.close();
    await _loadingPercentChangedStreamController.close();
    await _loadedStreamController.close();
    await _loadingCancelledStreamController.close();
    await _loadingFailureStreamController.close();
  }
}

import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

class LoadingTrackObserver {
  LoadingTrackObserver({required this.track, this.status = LoadingTrackStatus.waitInLoadingQueue});

  Function()? onStartLoading;


  void Function(double percent)? _onLoadingPercentChanged;
  set onLoadingPercentChanged(void Function(double percent)? value) => _onLoadingPercentChanged = value;
  void Function(double percent)? get onLoadingPercentChanged => (percent) {
    loadingPercent = percent;
    _onLoadingPercentChanged?.call(percent);
  };

  void Function(String savePath)? _onLoaded;
  set onLoaded(void Function(String savePath)? value) => _onLoaded = value;
  void Function(String savePath)? get onLoaded => (savePath) {
    savePath = savePath;
    _onLoaded?.call(savePath);
  };

  void Function()? onLoadingCancelled;

  void Function(Failure failure)? _onFailure;
  set onFailure(void Function(Failure failure)? value) => _onFailure = value;
  void Function(Failure failure)? get onFailure => (failure) {
    failure = failure;
    _onFailure?.call(failure);
  };

  LoadingTrackStatus status;

  double? loadingPercent;
  String? resultSavePath;
  Failure? failure;

  final Track track;
}

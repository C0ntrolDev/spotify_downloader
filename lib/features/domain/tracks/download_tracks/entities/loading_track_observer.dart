import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

class LoadingTrackObserver {
  LoadingTrackObserver({required this.track, this.status = LoadingTrackStatus.waitInLoadingQueue});

  Function()? onStartLoading;
  void Function(double percent)? onLoadingPercentChanged;
  Function(String savePath)? onLoaded;
  Function()? onLoadingCancelled;
  void Function(Failure failure)? onFailure;

  LoadingTrackStatus status;

  final Track track;
}

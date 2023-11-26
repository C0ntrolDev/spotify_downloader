import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/features/domain/dowload_tracks/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/domain/shared/entities/track.dart';

class TrackObserver {
  TrackObserver({required this.track, this.status = LoadingTrackStatus.waitInLoadingQueue});

  Function? onStartLoading;
  void Function(double percent)? onLoadingPercentChanged;
  Function? onLoaded;
  Function? onLoadingCancelled;
  void Function(Failure failure)? onFailure;

  LoadingTrackStatus status;

  final Track track;
}

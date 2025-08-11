import 'package:spotify_downloader/core/utils/failures/failure.dart';

sealed class LoadingTrackStatus {}

final class LoadingTrackStatusWaitInLoadingQueue extends LoadingTrackStatus {}

final class LoadingTrackStatusLoading extends LoadingTrackStatus {
  LoadingTrackStatusLoading({this.percent, required this.youTubeUrl});

  final double? percent;
  final String youTubeUrl;
}

final class LoadingTrackStatusLoaded extends LoadingTrackStatus {
  LoadingTrackStatusLoaded({required this.savePath});

  final String savePath;
}

final class LoadingTrackStatusFailure extends LoadingTrackStatus {
  LoadingTrackStatusFailure({this.failure});

  final Failure? failure;
}

final class LoadingTrackStatusCancelled extends LoadingTrackStatus { }

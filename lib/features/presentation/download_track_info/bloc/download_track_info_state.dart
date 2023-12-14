part of 'download_track_info_bloc.dart';

sealed class DownloadTrackInfoState extends Equatable {
  const DownloadTrackInfoState({required this.trackWithLoadingObserver});

  final TrackWithLoadingObserver trackWithLoadingObserver;

  @override
  List<Object?> get props => [trackWithLoadingObserver];

}

final class DownloadTrackInfoLoaded extends DownloadTrackInfoState {
  const DownloadTrackInfoLoaded({required super.trackWithLoadingObserver});
 }

final class DownloadTrackInfoFailure extends DownloadTrackInfoState {
  const DownloadTrackInfoFailure({required this.failure, required super.trackWithLoadingObserver});

  final Failure? failure;

  @override
  List<Object?> get props => [failure];
}

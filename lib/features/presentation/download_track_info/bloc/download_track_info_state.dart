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

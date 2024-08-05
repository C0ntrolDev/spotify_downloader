part of 'download_tracks_cubit.dart';

sealed class DownloadTracksState extends Equatable {
  final Map<TrackWithLoadingObserver, String> preselectedTracksYouTubeUrls;

  const DownloadTracksState({required this.preselectedTracksYouTubeUrls});

  @override
  List<Object?> get props => [];
}

final class DownloadTracksDeffault extends DownloadTracksState {
  const DownloadTracksDeffault({required super.preselectedTracksYouTubeUrls});

  @override
  List<Object?> get props => [];
}

final class DownloadTracksFailure extends DownloadTracksState {
  const DownloadTracksFailure({required this.failure, required super.preselectedTracksYouTubeUrls});

  final Failure? failure;

  @override
  List<Object?> get props => [failure];
}

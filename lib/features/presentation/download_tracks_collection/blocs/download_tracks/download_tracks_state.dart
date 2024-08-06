part of 'download_tracks_cubit.dart';

sealed class DownloadTracksState {
  final Map<TrackWithLoadingObserver, String> preselectedTracksYouTubeUrls;

  const DownloadTracksState({required this.preselectedTracksYouTubeUrls});
}

final class DownloadTracksDefault extends DownloadTracksState {
  const DownloadTracksDefault({required super.preselectedTracksYouTubeUrls});
}

final class DownloadTracksFailure extends DownloadTracksState {
  const DownloadTracksFailure({required this.failure, required super.preselectedTracksYouTubeUrls});

  final Failure? failure;
}

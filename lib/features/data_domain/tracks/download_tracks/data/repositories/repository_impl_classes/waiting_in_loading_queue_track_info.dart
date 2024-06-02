import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/entities.dart';

class WaitingInLoadingQueueTrackInfo {
  WaitingInLoadingQueueTrackInfo(
      {required this.loadingTrackId, required this.trackWithLazyYoutubeUrl, required this.trackLoadingNotifier});

  final LoadingTrackId loadingTrackId;
  final TrackWithLazyYoutubeUrl trackWithLazyYoutubeUrl;
  final TrackLoadingNotifier trackLoadingNotifier;
}

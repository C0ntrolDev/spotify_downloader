import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/entities/loading_track_id.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/entities/track_loading_notifier.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/entities/track_with_lazy_youtube_url.dart';

class WaitingInLoadingQueueTrackInfo {
  WaitingInLoadingQueueTrackInfo(
      {required this.loadingTrackId, required this.trackWithLazyYoutubeUrl, required this.trackLoadingNotifier});

  final LoadingTrackId loadingTrackId;
  final TrackWithLazyYoutubeUrl trackWithLazyYoutubeUrl;
  final TrackLoadingNotifier trackLoadingNotifier;
}

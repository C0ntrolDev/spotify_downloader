import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/download_tracks.dart';

class LoadingTrackInfo {
  LoadingTrackInfo(
      {required this.loadingTrackId, required this.audioLoadingStream, required this.trackLoadingNotifier});

  final LoadingTrackId loadingTrackId;
  AudioLoadingStream? audioLoadingStream;
  TrackLoadingNotifier trackLoadingNotifier;
}

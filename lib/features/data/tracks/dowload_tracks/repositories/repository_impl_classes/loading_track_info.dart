import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/loading_stream/audio_loading_stream.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_id.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/track_loading_notifier.dart';

class LoadingTrackInfo {
  LoadingTrackInfo(
      {required this.loadingTrackId, required this.audioLoadingStream, required this.trackLoadingNotifier});

  final LoadingTrackId loadingTrackId;
  AudioLoadingStream? audioLoadingStream;
  TrackLoadingNotifier trackLoadingNotifier;
}

import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/download_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/entities.dart';

class DownloadTrack implements UseCase<Failure, LoadingTrackObserver, Track> {
  DownloadTrack({required DownloadTracksService downloadTracksService}) : _downloadTracksService = downloadTracksService;

  final DownloadTracksService _downloadTracksService;

  @override
  Future<Result<Failure, LoadingTrackObserver>> call(Track track) async {
    return _downloadTracksService.downloadTrack(track);
  }
}

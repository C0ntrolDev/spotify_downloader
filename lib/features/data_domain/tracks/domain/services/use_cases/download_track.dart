import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/core/utils/use_case/use_case.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/services/download_tracks_service/download_tracks_service.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/track.dart';

class DownloadTrack implements UseCase<Failure, LoadingTrackObserver, Track> {
  DownloadTrack({required DownloadTracksService downloadTracksService}) : _downloadTracksService = downloadTracksService;

  final DownloadTracksService _downloadTracksService;

  @override
  Future<Result<Failure, LoadingTrackObserver>> call(Track track) async {
    return _downloadTracksService.downloadTrack(track);
  }
}

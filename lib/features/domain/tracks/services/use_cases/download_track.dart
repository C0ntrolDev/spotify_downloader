import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/tracks_service.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

class DownloadTrack implements UseCase<Failure, LoadingTrackObserver, Track> {
  DownloadTrack({required TracksService tracksService}) : _tracksService = tracksService;

  final TracksService _tracksService;

  @override
  Future<Result<Failure, LoadingTrackObserver>> call(Track track) async {
    return _tracksService.downloadTrack(track);
  }
}

import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/tracks_service.dart';

class DownloadTracksRange implements UseCase<Failure, void, List<TrackWithLoadingObserver>> {
  DownloadTracksRange({required TracksService tracksService}) : _tracksService = tracksService;

  final TracksService _tracksService;

  @override
  Future<Result<Failure, void>> call(List<TrackWithLoadingObserver> tracks) async {
    return _tracksService.dowloadTracksRange(tracks);
  }
}
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/repositories/dowload_tracks_repository.dart';

class RemoveLoadingTrackObserver implements UseCase<Failure, void, LoadingTrackObserver> {
  RemoveLoadingTrackObserver({required DowloadTracksRepository dowloadTracksRepository})
      : _dowloadTracksRepository = dowloadTracksRepository;

  final DowloadTracksRepository _dowloadTracksRepository;

  @override
  Future<Result<Failure, void>> call(LoadingTrackObserver loadingTrackObserver) {
    return _dowloadTracksRepository.removeLoadingTrackObserver(loadingTrackObserver);
  }
}

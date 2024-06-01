import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/core/utils/use_case/use_case.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/observe_tracks_loading/entities/repository/loading_tracks_collections_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/observe_tracks_loading/repository/observe_tracks_loading_repository.dart';

class GetLoadingTracksCollectionsObserver implements UseCase<Failure, LoadingTracksCollectionsObserver, void> {
  final ObserveTracksLoadingRepository _observeTracksLoading;

  GetLoadingTracksCollectionsObserver({required ObserveTracksLoadingRepository repository})
      : _observeTracksLoading = repository;

  @override
  Future<Result<Failure, LoadingTracksCollectionsObserver>> call(void params) async {
    return Result.isSuccessful(await _observeTracksLoading.getTracksCollectionsLoadingObserver());
  }
}

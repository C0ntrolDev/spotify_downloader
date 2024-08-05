import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/observe_tracks_loading/domain/domain.dart';

class GetLoadingTracksCollectionsObserver implements UseCase<Failure, LoadingTracksCollectionsObserver, void> {
  final ObserveTracksLoadingRepository _observeTracksLoading;

  GetLoadingTracksCollectionsObserver({required ObserveTracksLoadingRepository repository})
      : _observeTracksLoading = repository;

  @override
  Future<Result<Failure, LoadingTracksCollectionsObserver>> call(void params) async {
    return Result.isSuccessful(await _observeTracksLoading.getTracksCollectionsLoadingObserver());
  }
}

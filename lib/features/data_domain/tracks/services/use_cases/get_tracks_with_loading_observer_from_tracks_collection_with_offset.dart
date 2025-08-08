import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';

class GetTracksWithLoadingObserverFromTracksCollectionWithOffset
    implements
        UseCase<Failure, TracksWithLoadingObserverGettingObserver,
            (TracksCollection, int)> {
  GetTracksWithLoadingObserverFromTracksCollectionWithOffset({required GetTracksService getTracksService})
      : _getTracksService = getTracksService;

  final GetTracksService _getTracksService;

  @override
  Future<Result<Failure, TracksWithLoadingObserverGettingObserver>> call(
      (TracksCollection, int) params) async {
    return  _getTracksService.getTracksWithLoadingObserversFromTracksColleciton(
        tracksCollection: params.$1, offset: params.$2);
  }
}

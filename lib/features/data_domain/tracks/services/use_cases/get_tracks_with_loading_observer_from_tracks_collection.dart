import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';

class GetTracksWithLoadingObserverFromTracksCollection
    implements UseCase<Failure, TracksWithLoadingObserverGettingObserver, TracksCollection> {
  GetTracksWithLoadingObserverFromTracksCollection({required GetTracksService getTracksService})
      : _getTracksService = getTracksService;

  final GetTracksService _getTracksService;

  @override
  Future<Result<Failure, TracksWithLoadingObserverGettingObserver>> call(TracksCollection tracksCollection) async {
        return _getTracksService.getTracksWithLoadingObserversFromTracksColleciton(
        tracksCollection: tracksCollection, offset: 0);
  }
}

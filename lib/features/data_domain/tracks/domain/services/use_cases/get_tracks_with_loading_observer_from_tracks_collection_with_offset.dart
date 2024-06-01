import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/core/utils/use_case/use_case.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/services/get_tracks_service/get_tracks_service.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/entities/tracks_with_loading_observer_getting_observer.dart';

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

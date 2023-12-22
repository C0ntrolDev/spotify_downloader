import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/get_tracks_service/get_tracks_service.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_observer.dart';

class GetTracksWithLoadingObserverFromTracksCollection
    implements UseCase<Failure, TracksWithLoadingObserverGettingObserver, TracksCollection> {
  GetTracksWithLoadingObserverFromTracksCollection({required GetTracksService getTracksService})
      : _getTracksService = getTracksService;

  final GetTracksService _getTracksService;

  @override
  Future<Result<Failure, TracksWithLoadingObserverGettingObserver>> call(TracksCollection tracksCollection) async {
        return Result.isSuccessful(await _getTracksService.getTracksWithLoadingObserversFromTracksColleciton(
        tracksCollection: tracksCollection, offset: 0));
  }
}

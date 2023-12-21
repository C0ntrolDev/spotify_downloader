import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/tracks_service.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_controller.dart';

class GetTracksWithLoadingObserverFromTracksCollection
    implements UseCase<Failure, TracksWithLoadingObserverGettingObserver, TracksCollection> {
  GetTracksWithLoadingObserverFromTracksCollection({required TracksService tracksService})
      : _tracksService = tracksService;

  final TracksService _tracksService;

  @override
  Future<Result<Failure, TracksWithLoadingObserverGettingObserver>> call(TracksCollection tracksCollection) async {
        return Result.isSuccessful(await _tracksService.getTracksWithLoadingObserversFromTracksColleciton(
        tracksCollection: tracksCollection, offset: 0));
  }
}

import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/tracks_with_loading_observer_getting_observer.dart';

abstract class GetTracksService {
  Future<Result<Failure, TracksWithLoadingObserverGettingObserver>> getTracksWithLoadingObserversFromTracksColleciton(
      {required TracksCollection tracksCollection, required int offset});
}
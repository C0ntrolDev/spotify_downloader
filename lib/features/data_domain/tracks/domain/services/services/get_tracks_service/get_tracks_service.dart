import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/entities/tracks_with_loading_observer_getting_observer.dart';

abstract class GetTracksService {
  Future<Result<Failure, TracksWithLoadingObserverGettingObserver>> getTracksWithLoadingObserversFromTracksColleciton(
      {required TracksCollection tracksCollection, required int offset});
}
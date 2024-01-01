import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_observer.dart';

abstract class GetTracksService {
  Future<Result<Failure, TracksWithLoadingObserverGettingObserver>> getTracksWithLoadingObserversFromTracksColleciton(
      {required TracksCollection tracksCollection, required int offset});
}
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/get_tracks_from_tracks_collection_args.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/repositories/network_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_controller.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/tracks_service.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

class TracksServiceImpl implements TracksService {
  TracksServiceImpl({required NetworkTracksRepository networkTracksRepository})
      : _networkTracksRepository = networkTracksRepository;

  final NetworkTracksRepository _networkTracksRepository;

  @override
  TracksWithLoadingObserverGettingController getTracksLoadingObserversFromTracksColleciton(
      TracksCollection tracksCollection, List<TrackWithLoadingObserver> responseList) {
    final rawResponseList = List<Track?>.empty();
    final rawController = _networkTracksRepository.getTracksFromTracksCollection(
        GetTracksFromTracksCollectionArgs(tracksCollection: tracksCollection, responseList: rawResponseList));
    final trackGettingController =
        TracksWithLoadingObserverGettingController(cancelFunction: () => rawController.cancelGetting());

    rawController.onEnded = (result) => trackGettingController.onEnded?.call(result);
    rawController.onPartGetted = (rawPart) {
      final part = rawPart.where((track) => track != null).map((track) {
        return _findAllInfoAboutTrack(track!);
      });

      responseList.addAll(part);
      trackGettingController.onPartGetted?.call();
    };

    return trackGettingController;
  }

  @override
  TracksWithLoadingObserverGettingController getLikedTracksLoadingObservers(List<TrackWithLoadingObserver> responseList) {
    throw UnimplementedError();
  }

  TrackWithLoadingObserver _findAllInfoAboutTrack(Track track) {
    return TrackWithLoadingObserver(track: track);
  }
}

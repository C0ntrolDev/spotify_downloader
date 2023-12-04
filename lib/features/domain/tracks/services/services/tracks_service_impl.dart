import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/get_tracks_from_tracks_collection_args.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/repositories/network_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_controller.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/tracks_service.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

class TracksServiceImpl implements TracksService {
  TracksServiceImpl(
      {required NetworkTracksRepository networkTracksRepository})
      : _networkTracksRepository = networkTracksRepository;

  final NetworkTracksRepository _networkTracksRepository;

  @override
  Future<TracksWithLoadingObserverGettingController> getTracksWithLoadingObserversFromTracksColleciton(
      {required TracksCollection tracksCollection,
      required List<TrackWithLoadingObserver> responseList,
      int offset = 0}) async {

    final rawResponseList = List<Track?>.empty(growable: true);
    final rawController = _networkTracksRepository.getTracksFromTracksCollection(GetTracksFromTracksCollectionArgs(
        tracksCollection: tracksCollection, responseList: rawResponseList, offset: offset));

    final trackGettingController =
        TracksWithLoadingObserverGettingController(cancelFunction: () => rawController.cancelGetting());

    rawController.onPartGot = (rawPart) {
      final part = rawPart.where((track) => track != null).map((track) {
        return _findAllInfoAboutTrack(track!);
      });
      responseList.addAll(part);
      trackGettingController.onPartGot?.call();
    };
    rawController.onEnded = trackGettingController.onEnded;

    return trackGettingController;
  }

  @override
  TracksWithLoadingObserverGettingController getLikedTracksWithLoadingObservers(
      List<TrackWithLoadingObserver> responseList) {
    throw UnimplementedError();
  }

  TrackWithLoadingObserver _findAllInfoAboutTrack(Track track) {
    return TrackWithLoadingObserver(track: track);
  }

  Future<Result<Failure, void>> dowloadTracksWithLoadingObserverRange(
      List<TrackWithLoadingObserver> tracksWithLoadingObservers) async {
    for (var trackWithLoadingObserver in tracksWithLoadingObservers) {
      if (trackWithLoadingObserver.trackObserver == null ||
          trackWithLoadingObserver.trackObserver!.status == LoadingTrackStatus.loaded ||
          trackWithLoadingObserver.trackObserver!.status == LoadingTrackStatus.loadingCancelled) {
        final trackObserverResult = await downloadTrack(trackWithLoadingObserver.track);
        if (trackObserverResult.isSuccessful) {
          trackWithLoadingObserver.trackObserver = trackObserverResult.result;
        } else {
          return Result.notSuccessful(trackObserverResult.failure);
        }
      }
    }

    return const Result.isSuccessful(null);
  }

  Future<Result<Failure, LoadingTrackObserver>> downloadTrack(Track track) async {
    throw UnimplementedError();
  }
}

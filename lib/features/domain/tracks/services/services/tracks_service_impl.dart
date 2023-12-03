import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/get_tracks_from_tracks_collection_args.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/repositories/network_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_service_isolate_message_type.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_controller.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/tracks_service.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';
import 'dart:isolate';

class TracksServiceImpl implements TracksService {
  TracksServiceImpl({required NetworkTracksRepository networkTracksRepository})
      : _networkTracksRepository = networkTracksRepository;

  final NetworkTracksRepository _networkTracksRepository;

  @override
  Future<TracksWithLoadingObserverGettingController> getTracksWithLoadingObserversFromTracksColleciton(
      {required TracksCollection tracksCollection,
      required List<TrackWithLoadingObserver> responseList,
      int offset = 0}) async {
    void Function()? cancelFunction;
    final trackGettingController =
        TracksWithLoadingObserverGettingController(cancelFunction: () => cancelFunction?.call());

    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(
        _getTracksWithLoadingObserverFromTracksCollecitonIsolate, (receivePort.sendPort, tracksCollection, offset));
    receivePort.listen((message) {
      if (message is (TracksServiceIsolateMessageType, dynamic)) {
        switch (message.$1) {
          case TracksServiceIsolateMessageType.cancelReceivePort:
            cancelFunction = () => (message.$2 as SendPort).send(1);
          case TracksServiceIsolateMessageType.partGot:
            responseList.addAll(message.$2);
            trackGettingController.onPartGot?.call();
          case TracksServiceIsolateMessageType.ended:
            trackGettingController.onEnded?.call(message.$2);
            isolate.kill();
        }
      }
    });

    return trackGettingController;
  }

  void _getTracksWithLoadingObserverFromTracksCollecitonIsolate(
      (SendPort sendPort, TracksCollection tracksCollection, int offset) params) {
    final sendPort = params.$1;
    final tracksCollection = params.$2;
    final offset = params.$3;

    final rawResponseList = List<Track?>.empty(growable: true);
    final cancelReceivePort = ReceivePort();
    sendPort.send((TracksServiceIsolateMessageType.cancelReceivePort, cancelReceivePort.sendPort));

    final rawController = _networkTracksRepository.getTracksFromTracksCollection(GetTracksFromTracksCollectionArgs(
        tracksCollection: tracksCollection, responseList: rawResponseList, offset: offset));
    cancelReceivePort.listen((message) {
      rawController.cancelGetting();
    });

    rawController.onEnded = (result) {
      sendPort.send((TracksServiceIsolateMessageType.ended, result));
    };

    rawController.onPartGot = (rawPart) {
      final part = rawPart.where((track) => track != null).map((track) {
        return _findAllInfoAboutTrack(track!);
      });
      sendPort.send((TracksServiceIsolateMessageType.partGot, part));
    };
  }

  @override
  TracksWithLoadingObserverGettingController getLikedTracksWithLoadingObservers(
      List<TrackWithLoadingObserver> responseList) {
    throw UnimplementedError();
  }

  TrackWithLoadingObserver _findAllInfoAboutTrack(Track track) {
    return TrackWithLoadingObserver(track: track);
  }
}

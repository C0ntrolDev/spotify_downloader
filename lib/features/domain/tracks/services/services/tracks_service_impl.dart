import 'dart:io';

import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_track.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_tracks_collection_type.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/repositories/local_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/tracks_getting_ended_status.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/track_with_lazy_youtube_url.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/repositories/dowload_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/get_tracks_from_tracks_collection_args.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/repositories/network_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/search_videos_by_track/repositories/search_videos_by_track_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_controller.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/tracks_service.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection_type.dart';

class TracksServiceImpl implements TracksService {
  TracksServiceImpl(
      {required NetworkTracksRepository networkTracksRepository,
      required DowloadTracksRepository dowloadTracksRepository,
      required SearchVideosByTrackRepository searchVideosByTrackRepository,
      required LocalTracksRepository localTracksRepository})
      : _networkTracksRepository = networkTracksRepository,
        _dowloadTracksRepository = dowloadTracksRepository,
        _searchVideosByTrackRepository = searchVideosByTrackRepository,
        _localTracksRepository = localTracksRepository;

  final NetworkTracksRepository _networkTracksRepository;
  final DowloadTracksRepository _dowloadTracksRepository;
  final SearchVideosByTrackRepository _searchVideosByTrackRepository;
  final LocalTracksRepository _localTracksRepository;

  @override
  Future<TracksWithLoadingObserverGettingObserver> getTracksWithLoadingObserversFromTracksColleciton(
      {required TracksCollection tracksCollection,
      required List<TrackWithLoadingObserver> responseList,
      int offset = 0}) async {
    final rawResponseList = List<Track?>.empty(growable: true);
    final rawObserver = await _networkTracksRepository.getTracksFromTracksCollection(GetTracksFromTracksCollectionArgs(
        tracksCollection: tracksCollection, responseList: rawResponseList, offset: offset));

    final tracksGettingObserver =
        TracksWithLoadingObserverGettingObserver(cancelFunction: () => rawObserver.cancelGetting());

    bool isRawPartLast = false;
    late Result<Failure, TracksGettingEndedStatus> tracksGettingResult;

    rawObserver.onPartGot = (rawPart) async {
      final filteredRawPart = rawPart.where((track) => track != null);
      List<TrackWithLoadingObserver> part = List.empty(growable: true);

      for (var rawPartElement in filteredRawPart) {
        final partElement = await _findAllInfoAboutTrack(rawPartElement!);
        part.add(partElement);
      }

      responseList.addAll(part);
      tracksGettingObserver.onPartGot?.call();

      if (isRawPartLast) {
        tracksGettingObserver.onEnded?.call(tracksGettingResult);
      }
    };

    rawObserver.onEnded = (result) {
      if (!result.isSuccessful || result.result == TracksGettingEndedStatus.cancelled) {
        tracksGettingObserver.onEnded?.call(result);
      } else {
        isRawPartLast = true;
        tracksGettingResult = result;
      }
    };

    return tracksGettingObserver;
  }

  @override
  TracksWithLoadingObserverGettingObserver getLikedTracksWithLoadingObservers(
      List<TrackWithLoadingObserver> responseList) {
    throw UnimplementedError();
  }

  Future<TrackWithLoadingObserver> _findAllInfoAboutTrack(Track track) async {
    final getloadingTrackObserverResult = await _dowloadTracksRepository.getLoadingTrackObserver(track);
    final localTrackResult = await _localTracksRepository.getLocalTrack(
        LocalTracksCollection(
            spotifyId: track.parentCollection.spotifyId,
            type: _convertTracksCollectionTypeToLocalTracksCollectionType(track.parentCollection.type)),
        track.spotifyId);

    final localTrack = localTrackResult.result;

    if (localTrack != null) {
      if (await checkLocalTrackToExistence(localTrack)) {
        track.isLoaded = true;
        track.youtubeUrl = localTrack.spotifyId;
      } else {
        _localTracksRepository.removeLocalTrack(localTrack);
      }
    }

    return TrackWithLoadingObserver(track: track, loadingObserver: getloadingTrackObserverResult.result);
  }

  Future<bool> checkLocalTrackToExistence(LocalTrack localTrack) async {
    return await File(localTrack.savePath).exists();
  }

  Future<Result<Failure, void>> dowloadTracksWithLoadingObserverRange(
      List<TrackWithLoadingObserver> tracksWithLoadingObservers) async {
    for (var trackWithLoadingObserver in tracksWithLoadingObservers) {
      if (trackWithLoadingObserver.loadingObserver == null ||
          trackWithLoadingObserver.loadingObserver!.status == LoadingTrackStatus.loaded ||
          trackWithLoadingObserver.loadingObserver!.status == LoadingTrackStatus.loadingCancelled) {
        final trackObserverResult = await downloadTrack(trackWithLoadingObserver.track);
        if (trackObserverResult.isSuccessful) {
          trackWithLoadingObserver.loadingObserver = trackObserverResult.result;
        } else {
          return Result.notSuccessful(trackObserverResult.failure);
        }
      }
    }

    return const Result.isSuccessful(null);
  }

  @override
  Future<Result<Failure, LoadingTrackObserver>> downloadTrack(Track track) async {
    final resultTrackObsever = await _dowloadTracksRepository.dowloadTrack(TrackWithLazyYoutubeUrl(
        track: track,
        getYoutubeUrlFunction: () async {
          final videoResult = await _searchVideosByTrackRepository.findVideoByTrack(track);

          if (!videoResult.isSuccessful) {
            return Result.notSuccessful(videoResult.failure);
          }

          if (videoResult.result == null) {
            return const Result.notSuccessful(NotFoundFailure(message: 'track not found on youtube'));
          }

          return Result.isSuccessful(videoResult.result!.url);
        }));

    final serviceTrackObserver = resultTrackObsever.result!;
    serviceTrackObserver.loadedStream.listen((savePath) {
      _localTracksRepository.saveLocalTrack(LocalTrack(
          spotifyId: track.spotifyId,
          savePath: savePath,
          tracksCollection: LocalTracksCollection(
              spotifyId: track.parentCollection.spotifyId,
              type: _convertTracksCollectionTypeToLocalTracksCollectionType(track.parentCollection.type)),
          youtubeUrl: track.youtubeUrl!));
    });

    return resultTrackObsever;
  }

  LocalTracksCollectionType _convertTracksCollectionTypeToLocalTracksCollectionType(
      TracksCollectionType tracksCollectionType) {
    switch (tracksCollectionType) {
      case TracksCollectionType.likedTracks:
        return LocalTracksCollectionType.likedTracks;
      case TracksCollectionType.playlist:
        return LocalTracksCollectionType.playlist;
      case TracksCollectionType.album:
        return LocalTracksCollectionType.album;
      case TracksCollectionType.track:
        return LocalTracksCollectionType.track;
    }
  }
}

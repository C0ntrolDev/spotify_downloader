import 'dart:async';
import 'dart:io';

import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/repositories/local_full_auth_repository.dart';

import 'package:spotify_downloader/features/domain/settings/enitities/save_mode.dart';
import 'package:spotify_downloader/features/domain/settings/repository/download_tracks_settings_repository.dart';
import 'package:spotify_downloader/features/domain/shared/spotify_repository_request.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_track.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_tracks_collection_group.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/repositories/local_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/tracks_getting_ended_status.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/tools/save_path_generator.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/tools/tracks_collection_type_to_local_tracks_collection_type_converter.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/get_tracks_service/get_tracks_service.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/repositories/dowload_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/get_tracks_from_tracks_collection_args.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/repositories/network_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

class GetTracksServiceImpl implements GetTracksService {
  GetTracksServiceImpl(
      {required NetworkTracksRepository networkTracksRepository,
      required DownloadTracksRepository downloadTracksRepository,
      required LocalTracksRepository localTracksRepository,
      required LocalFullAuthRepository authRepository,
      required DownloadTracksSettingsRepository downloadTracksSettingsRepository})
      : _networkTracksRepository = networkTracksRepository,
        _downloadTracksRepository = downloadTracksRepository,
        _localTracksRepository = localTracksRepository,
        _authRepository = authRepository,
        _downloadTracksSettingsRepository = downloadTracksSettingsRepository;

  final NetworkTracksRepository _networkTracksRepository;
  final DownloadTracksRepository _downloadTracksRepository;
  final LocalTracksRepository _localTracksRepository;
  final LocalFullAuthRepository _authRepository;
  final DownloadTracksSettingsRepository _downloadTracksSettingsRepository;

  final TracksCollectionTypeToLocalTracksCollectionTypeConverter _collectionTypeConverter =
      TracksCollectionTypeToLocalTracksCollectionTypeConverter();
  final SavePathGenerator _savePathGenerator = SavePathGenerator();

  @override
  Future<Result<Failure, TracksWithLoadingObserverGettingObserver>> getTracksWithLoadingObserversFromTracksColleciton(
      {required TracksCollection tracksCollection, int offset = 0}) async {
    final getFullCredentialsResult = await _authRepository.getFullCredentials();
    if (!getFullCredentialsResult.isSuccessful) {
      return Result.notSuccessful(getFullCredentialsResult.failure);
    }

    final rawObserver = await _networkTracksRepository.getTracksFromTracksCollection(GetTracksFromTracksCollectionArgs(
        spotifyRepositoryRequest: SpotifyRepositoryRequest(
            credentials: getFullCredentialsResult.result!,
            onCredentialsRefreshed: _authRepository.saveFullCredentials),
        tracksCollection: tracksCollection,
        offset: offset));

    final onPartGotStreamController = StreamController<List<TrackWithLoadingObserver>>();
    final onEndedSteamController = StreamController<Result<Failure, TracksGettingEndedStatus>>();

    final tracksGettingObserver = TracksWithLoadingObserverGettingObserver(
        onPartGot: onPartGotStreamController.stream.asBroadcastStream(),
        onEnded: onEndedSteamController.stream.asBroadcastStream());

    bool isRawPartLast = false;
    late Result<Failure, TracksGettingEndedStatus> tracksGettingResult;

    rawObserver.onPartGot = (rawPart) async {
      final filteredRawPart = rawPart.where((track) => track != null);
      List<TrackWithLoadingObserver> part = List.empty(growable: true);

      for (var rawPartElement in filteredRawPart) {
        final partElement = await _findAllInfoAboutTrack(rawPartElement!);
        part.add(partElement);
      }

      onPartGotStreamController.add(part);

      if (isRawPartLast) {
        onEndedSteamController.add(tracksGettingResult);
      }
    };

    rawObserver.onEnded = (result) {
      if (!result.isSuccessful || result.result == TracksGettingEndedStatus.cancelled) {
        onEndedSteamController.add(result);
      } else {
        isRawPartLast = true;
        tracksGettingResult = result;
      }
    };

    return Result.isSuccessful(tracksGettingObserver);
  }

  Future<TrackWithLoadingObserver> _findAllInfoAboutTrack(Track track) async {
    final getDownloadTracksSettings = await _downloadTracksSettingsRepository.getDownloadTracksSettings();
    if (getDownloadTracksSettings.isSuccessful) {
      final trackSavePath = _savePathGenerator.generateSavePath(track, getDownloadTracksSettings.result!);
      final getloadingTrackObserverResult =
          await _downloadTracksRepository.getLoadingTrackObserver(track, trackSavePath);

      final localTrackResult = await _localTracksRepository.getLocalTrack(
          getDownloadTracksSettings.result!.saveMode == SaveMode.folderForTracksCollection
              ? LocalTracksCollection(
                  spotifyId: track.parentCollection.spotifyId,
                  type: _collectionTypeConverter.convert(track.parentCollection.type),
                  group: LocalTracksCollectionsGroup(directoryPath: getDownloadTracksSettings.result!.savePath))
              : LocalTracksCollection.getAllTracksCollection(getDownloadTracksSettings.result!.savePath),
          track.spotifyId);

      final localTrack = localTrackResult.result;

      if (localTrack != null) {
        if (await _checkLocalTrackToExistence(localTrack)) {
          track.isLoaded = true;
          track.youtubeUrl = localTrack.youtubeUrl;
        }
      }

      return TrackWithLoadingObserver(track: track, loadingObserver: getloadingTrackObserverResult.result);
    }

    return TrackWithLoadingObserver(track: track, loadingObserver: null);
  }

  Future<bool> _checkLocalTrackToExistence(LocalTrack localTrack) async {
    return await File(localTrack.savePath).exists();
  }
}

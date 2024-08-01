import 'dart:async';
import 'dart:io';

import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/auth/local_auth/local_auth.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/enitities/enitities.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/repository/download_tracks_settings_repository.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/spotify_repository_request.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/download_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/local_tracks/local_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/network_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services/tools/save_path_generator.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services/tools/tracks_collection_type_to_local_tracks_collection_type_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/entities.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/liked_track.dart';

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
          if (track is LikedTrack) {
             track = LikedTrack(
              spotifyId: track.spotifyId,
              parentCollection: track.parentCollection,
              name: track.name,
              album: track.album,
              artists: track.artists,
              duration: track.duration,
              isLoaded: true,
              addedAt: track.addedAt,
              localYoutubeUrl: localTrack.youtubeUrl);
          } else {
             track = Track(
              spotifyId: track.spotifyId,
              parentCollection: track.parentCollection,
              name: track.name,
              album: track.album,
              artists: track.artists,
              duration: track.duration,
              isLoaded: true,
              localYoutubeUrl: localTrack.youtubeUrl);
          }
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

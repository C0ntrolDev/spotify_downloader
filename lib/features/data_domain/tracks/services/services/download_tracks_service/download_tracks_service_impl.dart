import 'dart:io';

import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/settings/settings.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/entities/track.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/download_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/local_tracks/local_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/observe_tracks_loading/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks/search_videos_by_track/search_videos_by_track.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/entities.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services/tools/tools.dart';

class DownloadTracksServiceImpl implements DownloadTracksService {
  DownloadTracksServiceImpl(
      {required DownloadTracksRepository downloadTracksRepository,
      required SearchVideosByTrackRepository searchVideosByTrackRepository,
      required LocalTracksRepository localTracksRepository,
      required ObserveTracksLoadingRepository observeTracksLoadingRepository,
      required DownloadTracksSettingsRepository downloadTracksSettingsRepository})
      : _downloadTracksRepository = downloadTracksRepository,
        _searchVideosByTrackRepository = searchVideosByTrackRepository,
        _localTracksRepository = localTracksRepository,
        _observeTracksLoadingRepository = observeTracksLoadingRepository,
        _downloadTracksSettingsRepository = downloadTracksSettingsRepository;

  final DownloadTracksRepository _downloadTracksRepository;
  final SearchVideosByTrackRepository _searchVideosByTrackRepository;
  final LocalTracksRepository _localTracksRepository;
  final ObserveTracksLoadingRepository _observeTracksLoadingRepository;
  final DownloadTracksSettingsRepository _downloadTracksSettingsRepository;

  final TracksCollectionTypeToLocalTracksCollectionTypeConverter _collectionTypeConverter =
      TracksCollectionTypeToLocalTracksCollectionTypeConverter();
  final LoadingTrackStatusToServiceLoadingTrackStatusConverter _statusesConverter =
      LoadingTrackStatusToServiceLoadingTrackStatusConverter();
  final SavePathGenerator _savePathGenerator = SavePathGenerator();

  final Map<ServiceLoadingTrackId, ServiceLoadingTrackStatus> _tracksStatuses = {};
  final Map<ServiceLoadingTracksCollectionId, List<ServiceLoadingTracksStatusesObserver>> _collectionsObservers = {};

  @override
  Future<Result<Failure, void>> downloadTrack(Track track) async {
    final getTrackIdResult = await _getOrCreateEntryFromTrack(track);
    if (!getTrackIdResult.isSuccessful) {
      return Result.notSuccessful(getTrackIdResult.failure);
    }
    final trackId = getTrackIdResult.result!;

    final getDownloadTracksSettings = await _downloadTracksSettingsRepository.getDownloadTracksSettings();
    if (!getDownloadTracksSettings.isSuccessful) {
      return Result.notSuccessful(getDownloadTracksSettings.failure);
    }
    final String trackSavePath = _savePathGenerator.generateSavePath(track, getDownloadTracksSettings.result!);

    final downloadTrackResult = await _downloadTracksRepository.dowloadTrack(
        TrackWithLazyYoutubeUrl(
            track: track,
            getYoutubeUrl: () async {
              if (_tracksStatuses[trackId]!.youTubeUrl != null) {
                return Result.isSuccessful(_tracksStatuses[trackId]!.youTubeUrl);
              }

              final videoResult = await _searchVideosByTrackRepository.findVideoByTrack(track);

              if (!videoResult.isSuccessful) {
                return Result.notSuccessful(videoResult.failure);
              }
              if (videoResult.result == null) {
                return const Result.notSuccessful(NotFoundFailure(message: 'track not found on youtube'));
              }

              return Result.isSuccessful(videoResult.result!.url);
            }),
        trackSavePath);

    if (!downloadTrackResult.isSuccessful) {
      return Result.notSuccessful(downloadTrackResult.failure);
    }

    _observeLoadingTrackStatus(trackId, downloadTrackResult.result!, getDownloadTracksSettings.result!.savePath);
    _observeTracksLoadingRepository.observeLoadingTrack(downloadTrackResult.result!, track);

    return const Result.isSuccessful(null);
  }

  void _observeLoadingTrackStatus(ServiceLoadingTrackId id, LoadingTrackObserver observer, String directoryPath) {
    observer.loadingTrackStatusStream.listen((status) {
      if (status is! LoadingTrackStatusLoaded) return;

      _localTracksRepository.saveLocalTrack(LocalTrack(
          spotifyId: id.spotifyId,
          savePath: status.savePath,
          tracksCollection: LocalTracksCollection(
              spotifyId: id.parentCollectionId.spotifyId,
              type: _collectionTypeConverter.convert(id.parentCollectionId.type),
              group: LocalTracksCollectionsGroup(directoryPath: directoryPath)),
          youtubeUrl: observer.youtubeUrl ?? ""));
    });

    observer.loadingTrackStatusStream.listen((repositoryStatus) {
      final serviceStatus = _statusesConverter.convert((repositoryStatus, _tracksStatuses[id]!));
      _updateEntry(id, serviceStatus);
    });
  }

  @override
  Future<Result<Failure, void>> cancelTrackLoading(Track track) async {
    final getTrackIdResult = await _getOrCreateEntryFromTrack(track);
    if (!getTrackIdResult.isSuccessful) {
      return Result.notSuccessful(getTrackIdResult.failure);
    }
    final trackId = getTrackIdResult.result!;

    if (_tracksStatuses[trackId]! is! ServiceLoadingTrackStatusLoading) {
      return const Result.notSuccessful(NotFoundFailure(message: 'this track isn\'t dowloading'));
    }

    final getDownloadTracksSettings = await _downloadTracksSettingsRepository.getDownloadTracksSettings();
    if (!getDownloadTracksSettings.isSuccessful) {
      return Result.notSuccessful(getDownloadTracksSettings.failure);
    }
    final String trackSavePath = _savePathGenerator.generateSavePath(track, getDownloadTracksSettings.result!);

    return _downloadTracksRepository.cancelTrackLoading(track, trackSavePath);
  }

  @override
  Future<Result<Failure, void>> preselectYouTubeUrl(Track track, String preselectedYouTubeUrl) async {
    final getTrackIdResult = await _getOrCreateEntryFromTrack(track);
    if (!getTrackIdResult.isSuccessful) {
      return Result.notSuccessful(getTrackIdResult.failure);
    }
    final trackId = getTrackIdResult.result!;

    if (_tracksStatuses[trackId]! is ServiceLoadingTrackStatusLoading) {
      return const Result.notSuccessful(Failure(message: 'this track is already loading'));
    }

    if (_tracksStatuses[trackId] is ServiceLoadingTrackStatusLoaded &&
        _tracksStatuses[trackId]!.youTubeUrl == preselectedYouTubeUrl) {
      return const Result.isSuccessful(null);
    }

    _updateEntry(trackId, ServiceLoadingTrackStatusNotLoaded(youTubeUrl: preselectedYouTubeUrl));

    return const Result.isSuccessful(null);
  }

  @override
  Future<Result<Failure, ServiceLoadingTracksStatusesObserver>> observeTracksDownloadStatuses(
      TracksCollection tracksCollection) async {
    final getDownloadTracksSettings = await _downloadTracksSettingsRepository.getDownloadTracksSettings();
    if (!getDownloadTracksSettings.isSuccessful) {
      return Result.notSuccessful(getDownloadTracksSettings.failure);
    }

    final tracksCollectionId = ServiceLoadingTracksCollectionId(
        spotifyId: tracksCollection.spotifyId,
        type: tracksCollection.type,
        directoryPath: getDownloadTracksSettings.result!.savePath);
    
    if (!_collectionsObservers.containsKey(tracksCollectionId)) {
      _collectionsObservers[tracksCollectionId] = List.empty(growable: true);
    }

    final observer = ServiceLoadingTracksStatusesObserver();
    _collectionsObservers[tracksCollectionId]!.add(observer);

    return Result.isSuccessful(observer);
  }

  @override
  Future<Result<Failure, void>> removeTracksDownloadStatusesObserver(ServiceLoadingTracksStatusesObserver observer) async {
    for (var key in _collectionsObservers.keys) {
      while (_collectionsObservers[key]!.contains(observer)) {
        _collectionsObservers[key]!.remove(observer);
      }
    }

    return const Result.isSuccessful(null);
  }

  Future<Result<Failure, ServiceLoadingTrackId>> _getOrCreateEntryFromTrack(Track track) async {
    final getDownloadTracksSettings = await _downloadTracksSettingsRepository.getDownloadTracksSettings();
    if (!getDownloadTracksSettings.isSuccessful) {
      return Result.notSuccessful(getDownloadTracksSettings.failure);
    }
    final downloadSettings = getDownloadTracksSettings.result!;

    final id = _createId(track, downloadSettings.savePath);

    if (_tracksStatuses.containsKey(id)) {
      return Result.isSuccessful(id);
    }

    final getLocalTrackResult = await _localTracksRepository.getLocalTrack(
        LocalTracksCollection(
            spotifyId: id.parentCollectionId.spotifyId,
            type: _collectionTypeConverter.convert(id.parentCollectionId.type),
            group: LocalTracksCollectionsGroup(directoryPath: downloadSettings.savePath)),
        id.spotifyId);
    if (!getLocalTrackResult.isSuccessful) {
      return Result.notSuccessful(getLocalTrackResult.failure);
    }
    final localTrack = getLocalTrackResult.result;

    if (localTrack != null && await _checkLocalTrackToExistence(localTrack)) {
      _tracksStatuses[id] =
          ServiceLoadingTrackStatusLoaded(youTubeUrl: localTrack.youtubeUrl, savePath: localTrack.savePath);
    } else {
      _tracksStatuses[id] = const ServiceLoadingTrackStatusNotLoaded();
    }

    return Result.isSuccessful(id);
  }

  ServiceLoadingTrackId _createId(Track track, String directoryPath) => ServiceLoadingTrackId(
        parentCollectionId: ServiceLoadingTracksCollectionId(
            spotifyId: track.parentCollection.spotifyId,
            type: track.parentCollection.type,
            directoryPath: directoryPath),
        spotifyId: track.spotifyId,
      );

  Future<bool> _checkLocalTrackToExistence(LocalTrack localTrack) async {
    return await File(localTrack.savePath).exists();
  }

  void _updateEntry(ServiceLoadingTrackId id, ServiceLoadingTrackStatus newStatus) {
    if (_tracksStatuses[id] == newStatus) return;

    _tracksStatuses[id] = newStatus;
    if (_collectionsObservers.containsKey(id.parentCollectionId)) {
      for (var observer in _collectionsObservers[id.parentCollectionId]!) {
        observer.onUpdate?.call([(id, newStatus)]);
      }
    }
  }
}

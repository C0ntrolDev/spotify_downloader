import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/enitities/enitities.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/repository/download_tracks_settings_repository.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/download_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/local_tracks/local_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/observe_tracks_loading/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks/search_videos_by_track/search_videos_by_track.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services/tools/save_path_generator.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services/tools/tracks_collection_type_to_local_tracks_collection_type_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/entities.dart';

class DownloadTracksServiceImpl implements DownloadTracksService {
  DownloadTracksServiceImpl(
      {required DownloadTracksRepository dowloadTracksRepository,
      required SearchVideosByTrackRepository searchVideosByTrackRepository,
      required LocalTracksRepository localTracksRepository,
      required ObserveTracksLoadingRepository observeTracksLoadingRepository,
      required DownloadTracksSettingsRepository downloadTracksSettingsRepository})
      : _dowloadTracksRepository = dowloadTracksRepository,
        _searchVideosByTrackRepository = searchVideosByTrackRepository,
        _localTracksRepository = localTracksRepository,
        _observeTracksLoadingRepository = observeTracksLoadingRepository,
        _downloadTracksSettingsRepository = downloadTracksSettingsRepository;

  final DownloadTracksRepository _dowloadTracksRepository;
  final SearchVideosByTrackRepository _searchVideosByTrackRepository;
  final LocalTracksRepository _localTracksRepository;
  final ObserveTracksLoadingRepository _observeTracksLoadingRepository;
  final DownloadTracksSettingsRepository _downloadTracksSettingsRepository;

  final TracksCollectionTypeToLocalTracksCollectionTypeConverter _collectionTypeConverter =
      TracksCollectionTypeToLocalTracksCollectionTypeConverter();
  final SavePathGenerator _savePathGenerator = SavePathGenerator();

  @override
  Future<Result<Failure, void>> downloadTracksFromGettingObserver(
      TracksWithLoadingObserverGettingObserver tracksWithLoadingObserverGettingObserver) async {
    tracksWithLoadingObserverGettingObserver.onPartGot.listen((part) async {
      await downloadTracksRange(part);
    });
    return const Result.isSuccessful(null);
  }

  @override
  Future<Result<Failure, void>> downloadTracksRange(List<TrackWithLoadingObserver> tracksWithLoadingObservers) async {
    for (var trackWithLoadingObserver in tracksWithLoadingObservers) {
      if (!trackWithLoadingObserver.track.isLoaded &&
          (trackWithLoadingObserver.loadingObserver == null ||
              trackWithLoadingObserver.loadingObserver!.status == LoadingTrackStatus.failure ||
              trackWithLoadingObserver.loadingObserver!.status == LoadingTrackStatus.loadingCancelled)) {
        final trackObserverResult = await downloadTrack(trackWithLoadingObserver.track);
        if (trackObserverResult.isSuccessful) {
          trackWithLoadingObserver.loadingObserver = trackObserverResult.result;
        } else {
          final fakeLoadingNotifier = TrackLoadingNotifier();
          trackWithLoadingObserver.loadingObserver = fakeLoadingNotifier.loadingTrackObserver;
          fakeLoadingNotifier.loadingFailure(trackObserverResult.failure);
        }
      }
    }

    return const Result.isSuccessful(null);
  }

  @override
  Future<Result<Failure, LoadingTrackObserver>> downloadTrack(Track track) async {
    final getDownloadTracksSettings = await _downloadTracksSettingsRepository.getDownloadTracksSettings();
    if (!getDownloadTracksSettings.isSuccessful) {
      return Result.notSuccessful(getDownloadTracksSettings.failure);
    }

    final String trackSavePath = _savePathGenerator.generateSavePath(track, getDownloadTracksSettings.result!);
    final resultTrackObsever = await _dowloadTracksRepository.dowloadTrack(
        TrackWithLazyYoutubeUrl(
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
            }),
        trackSavePath);

    final serviceTrackObserver = resultTrackObsever.result!;
    serviceTrackObserver.loadedStream.listen((savePath) {
      _localTracksRepository.saveLocalTrack(LocalTrack(
          spotifyId: track.spotifyId,
          savePath: savePath,
          tracksCollection: getDownloadTracksSettings.result!.saveMode == SaveMode.folderForTracksCollection
              ? LocalTracksCollection(
                  spotifyId: track.parentCollection.spotifyId,
                  type: _collectionTypeConverter.convert(track.parentCollection.type),
                  group: LocalTracksCollectionsGroup(directoryPath: getDownloadTracksSettings.result!.savePath))
              : LocalTracksCollection.getAllTracksCollection(getDownloadTracksSettings.result!.savePath),
          youtubeUrl: track.youtubeUrl!));
    });

    _observeTracksLoadingRepository.observeLoadingTrack(serviceTrackObserver, track);

    return resultTrackObsever;
  }

  @override
  Future<Result<Failure, void>> cancelTrackLoading(Track track) async {
    final getDownloadTracksSettings = await _downloadTracksSettingsRepository.getDownloadTracksSettings();
    if (!getDownloadTracksSettings.isSuccessful) {
      return Result.notSuccessful(getDownloadTracksSettings.failure);
    }

    final trackSavePath = _savePathGenerator.generateSavePath(track, getDownloadTracksSettings.result!);
    return _dowloadTracksRepository.cancelTrackLoading(track, trackSavePath);
  }
}

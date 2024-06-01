import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/enitities/save_mode.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/repository/download_tracks_settings_repository.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/entities/track_loading_notifier.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/entities/track_with_lazy_youtube_url.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/repositories/dowload_tracks_repository.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/local_tracks/entities/local_track.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/local_tracks/entities/local_tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/local_tracks/entities/local_tracks_collection_group.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/local_tracks/repositories/local_tracks_repository.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/observe_tracks_loading/repository/observe_tracks_loading_repository.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/search_videos_by_track/repositories/search_videos_by_track_repository.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/entities/tracks_with_loading_observer_getting_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/services/tools/save_path_generator.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/services/tools/tracks_collection_type_to_local_tracks_collection_type_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/services/download_tracks_service/download_tracks_service.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/track.dart';

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

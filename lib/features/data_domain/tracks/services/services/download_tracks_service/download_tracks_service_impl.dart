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
  Future<Result<Failure, void>> downloadTracksRange(List<TrackWithLoadingObserver> tracksWithLoadingObservers,
      [Map<TrackWithLoadingObserver, String>? preselectedYoutubeUrls]) async {
    for (var trackWithLoadingObserver in tracksWithLoadingObservers) {
      if (!trackWithLoadingObserver.track.isLoaded &&
          (trackWithLoadingObserver.loadingObserver == null ||
              trackWithLoadingObserver.loadingObserver!.status == LoadingTrackStatus.failure ||
              trackWithLoadingObserver.loadingObserver!.status == LoadingTrackStatus.loadingCancelled)) {
        final trackObserverResult =
            await downloadTrack(trackWithLoadingObserver, preselectedYoutubeUrls?[trackWithLoadingObserver]);
        if (!trackObserverResult.isSuccessful) {
          final fakeLoadingNotifier = TrackLoadingNotifier();
          trackWithLoadingObserver.loadingObserver = fakeLoadingNotifier.loadingTrackObserver;
          fakeLoadingNotifier.loadingFailure(trackObserverResult.failure);
        }
      }
    }

    return const Result.isSuccessful(null);
  }

  @override
  Future<Result<Failure, void>> downloadTrack(TrackWithLoadingObserver trackWithLoadingObserver,
      [String? preselectedYoutubeUrl]) async {
    final getDownloadTracksSettings = await _downloadTracksSettingsRepository.getDownloadTracksSettings();
    if (!getDownloadTracksSettings.isSuccessful) {
      return Result.notSuccessful(getDownloadTracksSettings.failure);
    }

    final String trackSavePath =
        _savePathGenerator.generateSavePath(trackWithLoadingObserver.track, getDownloadTracksSettings.result!);
    final downloadTrackResult = await _dowloadTracksRepository.dowloadTrack(
        TrackWithLazyYoutubeUrl(
            track: trackWithLoadingObserver.track,
            getYoutubeUrl: () async {
              if (preselectedYoutubeUrl != null) {
                return Result.isSuccessful(preselectedYoutubeUrl);
              }

              final videoResult =
                  await _searchVideosByTrackRepository.findVideoByTrack(trackWithLoadingObserver.track);

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

    downloadTrackResult.result!.loadedStream.listen((savePath) {
      _localTracksRepository.saveLocalTrack(LocalTrack(
          spotifyId: trackWithLoadingObserver.track.spotifyId,
          savePath: savePath,
          tracksCollection: getDownloadTracksSettings.result!.saveMode == SaveMode.folderForTracksCollection
              ? LocalTracksCollection(
                  spotifyId: trackWithLoadingObserver.track.parentCollection.spotifyId,
                  type: _collectionTypeConverter.convert(trackWithLoadingObserver.track.parentCollection.type),
                  group: LocalTracksCollectionsGroup(directoryPath: getDownloadTracksSettings.result!.savePath))
              : LocalTracksCollection.getAllTracksCollection(getDownloadTracksSettings.result!.savePath),
          youtubeUrl: downloadTrackResult.result!.youtubeUrl ?? ""));
    });

    _observeTracksLoadingRepository.observeLoadingTrack(downloadTrackResult.result!, trackWithLoadingObserver.track);

    trackWithLoadingObserver.loadingObserver = downloadTrackResult.result!;
    return const Result.isSuccessful(null);
  }

  @override
  Future<Result<Failure, void>> cancelTrackLoading(TrackWithLoadingObserver trackWithLoadingObserver) async {
    if (trackWithLoadingObserver.loadingObserver == null ||
        (trackWithLoadingObserver.loadingObserver?.status != LoadingTrackStatus.loading &&
            trackWithLoadingObserver.loadingObserver?.status != LoadingTrackStatus.waitInLoadingQueue)) {

      trackWithLoadingObserver.loadingObserver = null;
      return const Result.isSuccessful(null);
    }

    final getDownloadTracksSettings = await _downloadTracksSettingsRepository.getDownloadTracksSettings();
    if (!getDownloadTracksSettings.isSuccessful) {
      return Result.notSuccessful(getDownloadTracksSettings.failure);
    }

    final trackSavePath =
        _savePathGenerator.generateSavePath(trackWithLoadingObserver.track, getDownloadTracksSettings.result!);
    final cancelTrackLoadingResult =
        _dowloadTracksRepository.cancelTrackLoading(trackWithLoadingObserver.track, trackSavePath);
    if (!cancelTrackLoadingResult.isSuccessful) {
      return Result.notSuccessful(cancelTrackLoadingResult.failure);
    }

    trackWithLoadingObserver.loadingObserver = null;
    return const Result.isSuccessful(null);
  }
}

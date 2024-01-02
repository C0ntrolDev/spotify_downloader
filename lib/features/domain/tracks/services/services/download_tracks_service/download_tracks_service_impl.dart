import 'package:path/path.dart' as p;

import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/util_methods.dart';
import 'package:spotify_downloader/features/domain/settings/enitities/save_mode.dart';
import 'package:spotify_downloader/features/domain/settings/repository/download_tracks_settings_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/track_loading_notifier.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/track_with_lazy_youtube_url.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/repositories/dowload_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_track.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_tracks_collection_group.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/repositories/local_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/repository/observe_tracks_loading_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/search_videos_by_track/repositories/search_videos_by_track_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/converters/tracks_collection_type_to_local_tracks_collection_type_converter.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/download_tracks_service/download_tracks_service.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

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

    late final String trackSavePath;
    if (getDownloadTracksSettings.result!.saveMode == SaveMode.folderForTracksCollection) {
      trackSavePath =
          p.join(getDownloadTracksSettings.result!.savePath, formatStringToFileFormat(track.parentCollection.name));
    } else {
      trackSavePath = p.join(getDownloadTracksSettings.result!.savePath, '_AllTracks');
    }

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
}

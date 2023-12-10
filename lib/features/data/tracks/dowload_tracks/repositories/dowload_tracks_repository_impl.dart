import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/cancellable_result.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/data_sources/dowload_audio_from_youtube_data_source.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/dowload_audio_from_youtube_args.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/loading_stream/audio_loading_stream.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/repositories/converters/track_to_audio_metadata_converter.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_id.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/track_with_lazy_youtube_url.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/repositories/dowload_tracks_repository.dart';

class DowloadTracksRepositoryImpl implements DowloadTracksRepository {
  DowloadTracksRepositoryImpl({required DownloadAudioFromYoutubeDataSource dowloadAudioFromYoutubeDataSource})
      : _dowloadAudioFromYoutubeDataSource = dowloadAudioFromYoutubeDataSource;

  final DownloadAudioFromYoutubeDataSource _dowloadAudioFromYoutubeDataSource;
  final TrackToAudioMetadataConverter _trackToAudioMetadataConverter = TrackToAudioMetadataConverter();

  final List<(LoadingTrackId, TrackWithLazyYoutubeUrl, List<LoadingTrackObserver>)> _loadingTracksQueue =
      List.empty(growable: true);
  final List<(LoadingTrackId, AudioLoadingStream, List<LoadingTrackObserver>)> _loadingTracks =
      List.empty(growable: true);
  final int _sameTimeloadingTracksLimit = 5;

  @override
  Future<Result<Failure, LoadingTrackObserver>> dowloadTrack(TrackWithLazyYoutubeUrl lazyTrack) async {
    final loadingTrackId = LoadingTrackId(
        parentSpotifyId: lazyTrack.track.parentCollection.spotifyId,
        parentType: lazyTrack.track.parentCollection.type,
        spotifyId: lazyTrack.track.spotifyId);

    final alreadyLoadingTrackObserver = (await getLoadingTrackObserver(lazyTrack.track)).result;
    if (alreadyLoadingTrackObserver != null) {
      return Result.isSuccessful(alreadyLoadingTrackObserver);
    }

    final loadingTrackObserver = LoadingTrackObserver(track: lazyTrack.track);
    final trackObservers = List<LoadingTrackObserver>.empty(growable: true)..add(loadingTrackObserver);

    if (_loadingTracks.length < _sameTimeloadingTracksLimit) {
      _startTrackLoading(loadingTrackId, lazyTrack, trackObservers);
      return Result.isSuccessful(loadingTrackObserver);
    } else {
      _loadingTracksQueue.add((loadingTrackId, lazyTrack, trackObservers));
      return Result.isSuccessful(loadingTrackObserver);
    }
  }

  @override
  Result<Failure, void> cancelTrackLoading(Track track) {
    final loadingTrackId = LoadingTrackId(
        parentSpotifyId: track.parentCollection.spotifyId,
        parentType: track.parentCollection.type,
        spotifyId: track.spotifyId);

    final foundLoadingTrack = _loadingTracks.where((e) => e.$1 == loadingTrackId).firstOrNull;
    if (foundLoadingTrack != null) {
      foundLoadingTrack.$2.cancel();
      _loadingTracks.remove(foundLoadingTrack);

      return const Result.isSuccessful(null);
    }

    final foundWaitingTrack = _loadingTracksQueue.where((e) => e.$1 == loadingTrackId).firstOrNull;
    if (foundWaitingTrack != null) {
      _loadingTracksQueue.remove(foundWaitingTrack);

      for (var loadingObserver in foundWaitingTrack.$3) {
        loadingObserver.status = LoadingTrackStatus.loadingCancelled;
        loadingObserver.onLoadingCancelled?.call();
      }

      return const Result.isSuccessful(null);
    }

    return const Result.notSuccessful(NotFoundFailure(message: 'this track isn\'t dowloading'));
  }

  @override
  Future<Result<Failure, LoadingTrackObserver?>> getLoadingTrackObserver(Track track) async {
    final loadingTrackId = LoadingTrackId(
        parentSpotifyId: track.parentCollection.spotifyId,
        parentType: track.parentCollection.type,
        spotifyId: track.spotifyId);
    final loadingTrackObserver = LoadingTrackObserver(track: track);

    final queueLoadingTrack = _loadingTracksQueue.where((e) => e.$1 == loadingTrackId).firstOrNull;
    if (queueLoadingTrack != null) {
      queueLoadingTrack.$3.add(loadingTrackObserver);
      return Result.isSuccessful(loadingTrackObserver);
    }

    final loadingTrack = _loadingTracks.where((e) => e.$1 == loadingTrackId).firstOrNull;
    if (loadingTrack != null) {
      loadingTrackObserver.status = LoadingTrackStatus.loading;
      loadingTrack.$3.add(loadingTrackObserver);
      return Result.isSuccessful(loadingTrackObserver);
    }

    return const Result.isSuccessful(null);
  }

  @override
  Future<Result<Failure, void>> removeLoadingTrackObserver(LoadingTrackObserver loadingTrackObserver) async {
    final queueTrackObserverContainers = _loadingTracksQueue.where((e) => e.$3.contains(loadingTrackObserver));
    for (var queueTrackObserverContainer in queueTrackObserverContainers) {
      queueTrackObserverContainer.$3.remove(loadingTrackObserver);
    }

    final trackObserverContainers = _loadingTracksQueue.where((e) => e.$3.contains(loadingTrackObserver));
    for (var trackObserverContainer in trackObserverContainers) {
      trackObserverContainer.$3.remove(loadingTrackObserver);
    }

    return const Result.isSuccessful(null);
  }

  void _onLoadingStreamEnded(
      CancellableResult<Failure, String> result, List<LoadingTrackObserver> loadingTrackObservers) {
    _loadingTracks.removeWhere((e) => e.$3 == loadingTrackObservers);

    if (result.isSuccessful) {
      for (var trackObserver in loadingTrackObservers) {
        trackObserver.status = LoadingTrackStatus.loaded;
        trackObserver.track.isLoaded = true;
        trackObserver.onLoaded?.call(result.result!);
      }
    } else if (result.isCancelled) {
      for (var trackObserver in loadingTrackObservers) {
        trackObserver.status = LoadingTrackStatus.loadingCancelled;
        trackObserver.onLoadingCancelled?.call();
      }
    } else {
      for (var trackObserver in loadingTrackObservers) {
        trackObserver.status = LoadingTrackStatus.failure;
        trackObserver.onFailure?.call(result.failure!);
      }
    }

    _loadNextTrackInQueue();
  }

  Future<void> _loadNextTrackInQueue() async {
    if (_loadingTracks.length < _sameTimeloadingTracksLimit) {
      if (_loadingTracksQueue.isNotEmpty) {
        final firstQueueObj = _loadingTracksQueue.first;
        _loadingTracksQueue.remove(firstQueueObj);

        _startTrackLoading(firstQueueObj.$1, firstQueueObj.$2, firstQueueObj.$3);
      }
    }
  }

  Future<void> _startTrackLoading(LoadingTrackId loadingTrackId, TrackWithLazyYoutubeUrl lazyTrack,
      List<LoadingTrackObserver> loadingTrackObservers) async {
    const saveDirectoryPath = 'storage/emulated/0/Download/';

    for (var trackObserver in loadingTrackObservers) {
      trackObserver.status = LoadingTrackStatus.loading;
    }

    final trackYoutubeUrlResult = await lazyTrack.getYoutubeUrl();
    if (!trackYoutubeUrlResult.isSuccessful) {
      for (var loadingTrackObserver in loadingTrackObservers) {
        loadingTrackObserver.onFailure?.call(trackYoutubeUrlResult.failure!);
      }

      _loadNextTrackInQueue();
      return;
    }

    for (var loadingTrackObserver in loadingTrackObservers) {
      loadingTrackObserver.track.youtubeUrl = trackYoutubeUrlResult.result;
    }

    final loadingStream = await _dowloadAudioFromYoutubeDataSource.dowloadAudioFromYoutube(
        DownloadAudioFromYoutubeArgs(
            youtubeUrl: trackYoutubeUrlResult.result!,
            saveDirectoryPath: saveDirectoryPath,
            audioMetadata: _trackToAudioMetadataConverter.convert(lazyTrack.track)));

    loadingStream.onEnded = (result) => _onLoadingStreamEnded(result, loadingTrackObservers);
    loadingStream.onLoadingPercentChanged = (newPercent) {
      for (var trackObserver in loadingTrackObservers) {
        trackObserver.onLoadingPercentChanged?.call(newPercent);
      }
    };

    _loadingTracks.add((loadingTrackId, loadingStream, loadingTrackObservers));
  }
}

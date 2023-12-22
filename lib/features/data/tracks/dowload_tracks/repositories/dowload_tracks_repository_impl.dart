import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/cancellable_result.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/data_sources/dowload_audio_from_youtube_data_source.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/dowload_audio_from_youtube_args.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/repositories/converters/track_to_audio_metadata_converter.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/repositories/repository_impl_classes/loading_track_info.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/repositories/repository_impl_classes/waiting_in_loading_queue_track_info.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/track_loading_notifier.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_id.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/track_with_lazy_youtube_url.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/repositories/dowload_tracks_repository.dart';

class DowloadTracksRepositoryImpl implements DownloadTracksRepository {
  DowloadTracksRepositoryImpl({required DownloadAudioFromYoutubeDataSource dowloadAudioFromYoutubeDataSource})
      : _dowloadAudioFromYoutubeDataSource = dowloadAudioFromYoutubeDataSource;

  final DownloadAudioFromYoutubeDataSource _dowloadAudioFromYoutubeDataSource;
  final TrackToAudioMetadataConverter _trackToAudioMetadataConverter = TrackToAudioMetadataConverter();

  final List<WaitingInLoadingQueueTrackInfo> _loadingTracksQueue = List.empty(growable: true);
  final List<LoadingTrackInfo> _loadingTracks = List.empty(growable: true);
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

    final trackLoadingNotifier = TrackLoadingNotifier();
    final trackInfo = WaitingInLoadingQueueTrackInfo(
          loadingTrackId: loadingTrackId,
          trackWithLazyYoutubeUrl: lazyTrack,
          trackLoadingNotifier: trackLoadingNotifier);

    if (_loadingTracks.length < _sameTimeloadingTracksLimit) {
      _startTrackLoading(trackInfo);
      return Result.isSuccessful(trackLoadingNotifier.loadingTrackObserver);
    } else {
      _loadingTracksQueue.add(trackInfo);
      return Result.isSuccessful(trackLoadingNotifier.loadingTrackObserver);
    }
  }

  @override
  Result<Failure, void> cancelTrackLoading(Track track) {
    final loadingTrackId = LoadingTrackId(
        parentSpotifyId: track.parentCollection.spotifyId,
        parentType: track.parentCollection.type,
        spotifyId: track.spotifyId);

    final foundLoadingTrack = _loadingTracks.where((e) => e.loadingTrackId == loadingTrackId).firstOrNull;
    if (foundLoadingTrack != null) {
      foundLoadingTrack.audioLoadingStream?.cancel();
      _loadingTracks.remove(foundLoadingTrack);

      return const Result.isSuccessful(null);
    }

    final foundWaitingTrack = _loadingTracksQueue.where((e) => e.loadingTrackId == loadingTrackId).firstOrNull;
    if (foundWaitingTrack != null) {
      _loadingTracksQueue.remove(foundWaitingTrack);
      foundWaitingTrack.trackLoadingNotifier.loadingCancelled();
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

    final queueLoadingTrack = _loadingTracksQueue.where((e) => e.loadingTrackId == loadingTrackId).firstOrNull;
    if (queueLoadingTrack != null) {
      return Result.isSuccessful(queueLoadingTrack.trackLoadingNotifier.loadingTrackObserver);
    }

    final loadingTrack = _loadingTracks.where((e) => e.loadingTrackId == loadingTrackId).firstOrNull;
    if (loadingTrack != null) {
      return Result.isSuccessful(loadingTrack.trackLoadingNotifier.loadingTrackObserver);
    }

    return const Result.isSuccessful(null);
  }

  void _onLoadingStreamEnded(CancellableResult<Failure, String> result, TrackLoadingNotifier trackLoadingNotifier) {
    _loadingTracks
        .removeWhere((e) => e.trackLoadingNotifier.loadingTrackObserver == trackLoadingNotifier.loadingTrackObserver);

    if (result.isSuccessful) {
      trackLoadingNotifier.loaded(result.result!);
    } else if (result.isCancelled) {
      trackLoadingNotifier.loadingCancelled();
    } else {
      trackLoadingNotifier.loadingFailure(result.failure);
    }

    _loadNextTrackInQueue();
  }

  Future<void> _loadNextTrackInQueue() async {
    if (_loadingTracks.length < _sameTimeloadingTracksLimit) {
      if (_loadingTracksQueue.isNotEmpty) {
        final firstQueueObj = _loadingTracksQueue.first;
        _loadingTracksQueue.remove(firstQueueObj);

        _startTrackLoading(firstQueueObj);
      }
    }
  }

  Future<void> _startTrackLoading(WaitingInLoadingQueueTrackInfo trackInfo) async {
    const saveDirectoryPath = 'storage/emulated/0/Download/';

    final loadingTrackInfo = LoadingTrackInfo(
        loadingTrackId: trackInfo.loadingTrackId,
        audioLoadingStream: null,
        trackLoadingNotifier: trackInfo.trackLoadingNotifier);
    _loadingTracks.add(loadingTrackInfo);

    final trackYoutubeUrlResult = await trackInfo.trackWithLazyYoutubeUrl.getYoutubeUrl();
    if (!trackYoutubeUrlResult.isSuccessful) {
      trackInfo.trackLoadingNotifier.loadingFailure(trackYoutubeUrlResult.failure);
      _loadNextTrackInQueue();
      return;
    }

    trackInfo.trackLoadingNotifier.startLoading(trackYoutubeUrlResult.result!);

    final loadingStream = await _dowloadAudioFromYoutubeDataSource.dowloadAudioFromYoutube(
        DownloadAudioFromYoutubeArgs(
            youtubeUrl: trackYoutubeUrlResult.result!,
            saveDirectoryPath: saveDirectoryPath,
            audioMetadata: _trackToAudioMetadataConverter.convert(trackInfo.trackWithLazyYoutubeUrl.track)));

    loadingStream.onEnded = (result) => _onLoadingStreamEnded(result, trackInfo.trackLoadingNotifier);
    loadingStream.onLoadingPercentChanged = (newPercent) {
      trackInfo.trackLoadingNotifier.loadingPercentChanged(newPercent);
    };

    loadingTrackInfo.audioLoadingStream = loadingStream;
  }
}

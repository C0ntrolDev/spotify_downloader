import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/download_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/entities.dart';

class DowloadTracksRepositoryImpl implements DownloadTracksRepository {
  DowloadTracksRepositoryImpl({required DownloadAudioFromYoutubeDataSource dowloadAudioFromYoutubeDataSource})
      : _dowloadAudioFromYoutubeDataSource = dowloadAudioFromYoutubeDataSource;

  final DownloadAudioFromYoutubeDataSource _dowloadAudioFromYoutubeDataSource;
  final TrackToAudioMetadataConverter _trackToAudioMetadataConverter = TrackToAudioMetadataConverter();

  final List<WaitingInLoadingQueueTrackInfo> _loadingTracksQueue = List.empty(growable: true);
  final List<LoadingTrackInfo> _loadingTracks = List.empty(growable: true);
  final int _sameTimeloadingTracksLimit = 5;

  @override
  Future<Result<Failure, LoadingTrackObserver>> dowloadTrack(TrackWithLazyYoutubeUrl lazyTrack, String savePath) async {
    final loadingTrackId = LoadingTrackId(
        parentSpotifyId: lazyTrack.track.parentCollection.spotifyId,
        parentType: lazyTrack.track.parentCollection.type,
        spotifyId: lazyTrack.track.spotifyId,
        savePath: savePath);

    final alreadyLoadingTrackObserver = (await getLoadingTrackObserver(lazyTrack.track, savePath)).result;
    if (alreadyLoadingTrackObserver != null) {
      return Result.isSuccessful(alreadyLoadingTrackObserver);
    }

    final trackLoadingNotifier = TrackLoadingNotifier();
    final trackInfo = WaitingInLoadingQueueTrackInfo(
        loadingTrackId: loadingTrackId,
        trackWithLazyYoutubeUrl: lazyTrack,
        trackLoadingNotifier: trackLoadingNotifier,);

    if (_loadingTracks.length < _sameTimeloadingTracksLimit) {
      _startTrackLoading(trackInfo);
      return Result.isSuccessful(trackLoadingNotifier.loadingTrackObserver);
    } else {
      _loadingTracksQueue.add(trackInfo);
      return Result.isSuccessful(trackLoadingNotifier.loadingTrackObserver);
    }
  }

  @override
  Result<Failure, void> cancelTrackLoading(Track track, String savePath) {
    final loadingTrackId = LoadingTrackId(
        parentSpotifyId: track.parentCollection.spotifyId,
        parentType: track.parentCollection.type,
        spotifyId: track.spotifyId,
        savePath: savePath);

    final foundLoadingTrack = _loadingTracks.where((e) => e.loadingTrackId == loadingTrackId).firstOrNull;
    if (foundLoadingTrack != null && foundLoadingTrack.audioLoadingStream != null) {
      foundLoadingTrack.audioLoadingStream!.cancel();
      _loadingTracks.remove(foundLoadingTrack);
      foundLoadingTrack.trackLoadingNotifier.loadingCancelled();
      _loadNextTrackInQueue();
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
  Future<Result<Failure, LoadingTrackObserver?>> getLoadingTrackObserver(Track track, String savePat) async {
    final loadingTrackId = LoadingTrackId(
        parentSpotifyId: track.parentCollection.spotifyId,
        parentType: track.parentCollection.type,
        spotifyId: track.spotifyId,
        savePath: savePat);

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

    if (!result.isCancelled) {
      if (result.isSuccessful) {
        trackLoadingNotifier.loaded(result.result!);
      } else {
        trackLoadingNotifier.loadingFailure(result.failure);
      }
      _loadNextTrackInQueue();
    }
  }

  Future<void> _loadNextTrackInQueue() async {
    if (_loadingTracks.length < _sameTimeloadingTracksLimit) {
      if (_loadingTracksQueue.isNotEmpty) {
        final firstQueueObj = _loadingTracksQueue.first;
        _loadingTracksQueue.remove(firstQueueObj);

        _startTrackLoading(firstQueueObj);
        _loadNextTrackInQueue();
      }
    }
  }

  Future<void> _startTrackLoading(WaitingInLoadingQueueTrackInfo trackInfo) async {
    final loadingTrackInfo = LoadingTrackInfo(
        loadingTrackId: trackInfo.loadingTrackId,
        audioLoadingStream: null,
        trackLoadingNotifier: trackInfo.trackLoadingNotifier);
    _loadingTracks.add(loadingTrackInfo);

    final trackYoutubeUrlResult = await trackInfo.trackWithLazyYoutubeUrl.getYoutubeUrl();
    if (!trackYoutubeUrlResult.isSuccessful) {
      _onLoadingStreamEnded(
          CancellableResult.notSuccessful(trackYoutubeUrlResult.failure), trackInfo.trackLoadingNotifier);
      return;
    }

    trackInfo.trackLoadingNotifier.startLoading(trackYoutubeUrlResult.result!);

    final loadingStream = await _dowloadAudioFromYoutubeDataSource.dowloadAudioFromYoutube(
        DownloadAudioFromYoutubeArgs(
            youtubeUrl: trackYoutubeUrlResult.result!,
            saveDirectoryPath: trackInfo.loadingTrackId.savePath,
            audioMetadata: _trackToAudioMetadataConverter.convert(trackInfo.trackWithLazyYoutubeUrl.track)));

    loadingStream.onEnded = (result) => _onLoadingStreamEnded(result, trackInfo.trackLoadingNotifier);
    loadingStream.onLoadingPercentChanged = (newPercent) {
      trackInfo.trackLoadingNotifier.loadingPercentChanged(newPercent);
    };

    loadingTrackInfo.audioLoadingStream = loadingStream;
  }
}

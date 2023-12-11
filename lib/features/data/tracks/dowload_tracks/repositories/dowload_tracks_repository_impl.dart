import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/cancellable_result.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/data_sources/dowload_audio_from_youtube_data_source.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/dowload_audio_from_youtube_args.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/loading_stream/audio_loading_stream.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/repositories/converters/track_to_audio_metadata_converter.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/track_loading_notifier.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_id.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/track_with_lazy_youtube_url.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/repositories/dowload_tracks_repository.dart';

class DowloadTracksRepositoryImpl implements DowloadTracksRepository {
  DowloadTracksRepositoryImpl({required DownloadAudioFromYoutubeDataSource dowloadAudioFromYoutubeDataSource})
      : _dowloadAudioFromYoutubeDataSource = dowloadAudioFromYoutubeDataSource;

  final DownloadAudioFromYoutubeDataSource _dowloadAudioFromYoutubeDataSource;
  final TrackToAudioMetadataConverter _trackToAudioMetadataConverter = TrackToAudioMetadataConverter();

  final List<(LoadingTrackId, TrackWithLazyYoutubeUrl, TrackLoadingNotifier)> _loadingTracksQueue =
      List.empty(growable: true);
  final List<(LoadingTrackId, AudioLoadingStream, TrackLoadingNotifier)> _loadingTracks = List.empty(growable: true);
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

    if (_loadingTracks.length < _sameTimeloadingTracksLimit) {
      _startTrackLoading(loadingTrackId, lazyTrack, trackLoadingNotifier);
      return Result.isSuccessful(trackLoadingNotifier.loadingTrackObserver);
    } else {
      _loadingTracksQueue.add((loadingTrackId, lazyTrack, trackLoadingNotifier));
      return Result.isSuccessful(trackLoadingNotifier.loadingTrackObserver);
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
      foundWaitingTrack.$3.loadingCancelled();
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

    final queueLoadingTrack = _loadingTracksQueue.where((e) => e.$1 == loadingTrackId).firstOrNull;
    if (queueLoadingTrack != null) {
      return Result.isSuccessful(queueLoadingTrack.$3.loadingTrackObserver);
    }

    final loadingTrack = _loadingTracks.where((e) => e.$1 == loadingTrackId).firstOrNull;
    if (loadingTrack != null) {
      return Result.isSuccessful(loadingTrack.$3.loadingTrackObserver);
    }

    return const Result.isSuccessful(null);
  }

  void _onLoadingStreamEnded(CancellableResult<Failure, String> result, TrackLoadingNotifier trackLoadingNotifier) {
    _loadingTracks.removeWhere((e) => e.$3.loadingTrackObserver == trackLoadingNotifier.loadingTrackObserver);

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

        _startTrackLoading(firstQueueObj.$1, firstQueueObj.$2, firstQueueObj.$3);
      }
    }
  }

  Future<void> _startTrackLoading(LoadingTrackId loadingTrackId, TrackWithLazyYoutubeUrl lazyTrack,
      TrackLoadingNotifier trackLoadingNotifier) async {
    const saveDirectoryPath = 'storage/emulated/0/Download/';

    final trackYoutubeUrlResult = await lazyTrack.getYoutubeUrl();
    if (!trackYoutubeUrlResult.isSuccessful) {
      trackLoadingNotifier.loadingFailure(trackYoutubeUrlResult.failure);
      _loadNextTrackInQueue();
      return;
    }

    trackLoadingNotifier.startLoading(trackYoutubeUrlResult.result!);

    final loadingStream = await _dowloadAudioFromYoutubeDataSource.dowloadAudioFromYoutube(
        DownloadAudioFromYoutubeArgs(
            youtubeUrl: trackYoutubeUrlResult.result!,
            saveDirectoryPath: saveDirectoryPath,
            audioMetadata: _trackToAudioMetadataConverter.convert(lazyTrack.track)));

    loadingStream.onEnded = (result) => _onLoadingStreamEnded(result, trackLoadingNotifier);
    loadingStream.onLoadingPercentChanged = (newPercent) {
      trackLoadingNotifier.loadingPercentChanged(newPercent);
    };

    _loadingTracks.add((loadingTrackId, loadingStream, trackLoadingNotifier));
  }
}

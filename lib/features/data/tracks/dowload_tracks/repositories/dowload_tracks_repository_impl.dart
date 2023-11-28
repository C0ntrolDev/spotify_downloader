// ignore_for_file: void_checks

import 'dart:ffi';

import 'package:path_provider/path_provider.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/data_sources/dowload_audio_from_youtube_data_source.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/dowload_audio_from_youtube_args.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/loading_stream/loading_result_status.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/loading_stream/loading_stream.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/repositories/converters/track_to_audio_metadata_converter.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_info.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

import 'package:path/path.dart' as p;
import 'package:spotify_downloader/features/domain/tracks/download_tracks/repositories/dowload_tracks_repository.dart';

class DowloadTracksRepositoryImpl implements DowloadTracksRepository {
  DowloadTracksRepositoryImpl({required DowloadAudioFromYoutubeDataSource dowloadAudioFromYoutubeDataSource})
      : _dowloadAudioFromYoutubeDataSource = dowloadAudioFromYoutubeDataSource;

  final DowloadAudioFromYoutubeDataSource _dowloadAudioFromYoutubeDataSource;
  final TrackToAudioMetadataConverter _trackToAudioMetadataConverter = TrackToAudioMetadataConverter();

  final List<(LoadingTrackId, Track, List<LoadingTrackObserver>)> _loadingTracksQueue = List.empty(growable: true);
  final List<(LoadingTrackId, LoadingStream, List<LoadingTrackObserver>)> _loadingTracks = List.empty(growable: true);

  final int _sameTimeloadingTracksLimit = 5;

  @override
  Future<Result<Failure, LoadingTrackObserver>> dowloadTrack(Track track) async {
    final loadingTrackObserver = LoadingTrackObserver(track: track);
    final loadingTrackId = LoadingTrackId(
        parentSpotifyId: track.parentCollection.spotifyId,
        parentType: track.parentCollection.type,
        spotifyId: track.spotifyId);
    final trackObservers = List<LoadingTrackObserver>.empty()..add(loadingTrackObserver);

    if (_loadingTracks.length < _sameTimeloadingTracksLimit) {
      if (track.youtubeUrl != null) {
        loadingTrackObserver.status = LoadingTrackStatus.loading;
        _startTrackLoading(loadingTrackId, track, trackObservers);
        return Result.isSuccessful(loadingTrackObserver);
      } else {
        return Result.notSuccessful(NotFoundFailure(message: 'youtube url not specified'));
      }
    } else {
      _loadingTracksQueue.add((loadingTrackId, track, trackObservers));
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
      return const Result.isSuccessful(Void);
    }

    return Result.notSuccessful(NotFoundFailure(message: 'this track isn\'t dowloading'));
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

    return const Result.isSuccessful(Void);
  }

  void _onLoadingStreamEnded(
      Result<Failure, LoadingResultStatus> result, List<LoadingTrackObserver> loadingTrackObservers) {
    _loadingTracks.removeWhere((e) => e.$3 == loadingTrackObservers);

    if (result.isSuccessful) {
      if (result.result! == LoadingResultStatus.loaded) {
        for (var trackObserver in loadingTrackObservers) {
          trackObserver.status = LoadingTrackStatus.loaded;
          trackObserver.onLoaded?.call();
        }
      } else {
        for (var trackObserver in loadingTrackObservers) {
          trackObserver.status = LoadingTrackStatus.loadingCancelled;
          trackObserver.onLoadingCancelled?.call();
        }
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

  Future<void> _startTrackLoading(
      LoadingTrackId loadingTrackId, Track track, List<LoadingTrackObserver> loadingTrackObservers) async {
    final saveDirectoryPath =
        p.join((await getApplicationDocumentsDirectory()).path, '/${track.parentCollection.name}');

    final loadingStream = _dowloadAudioFromYoutubeDataSource.dowloadAudioFromYoutube(DowloadAudioFromYoutubeArgs(
        youtubeUrl: track.youtubeUrl!,
        saveDirectoryPath: saveDirectoryPath,
        audioMetadata: _trackToAudioMetadataConverter.convert(track)));

    loadingStream.onEnded = (result) => _onLoadingStreamEnded(result, loadingTrackObservers);
    loadingStream.onLoadingPercentChanged = (newPercent) {
      for (var trackObserver in loadingTrackObservers) {
        trackObserver.onLoadingPercentChanged?.call(newPercent);
      }
    };

    _loadingTracks.add((loadingTrackId, loadingStream, loadingTrackObservers));
  }
}

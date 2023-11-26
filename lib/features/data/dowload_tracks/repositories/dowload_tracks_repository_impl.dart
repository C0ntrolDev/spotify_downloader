import 'dart:ffi';

import 'package:path_provider/path_provider.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/dowload_tracks/data_sources/dowload_audio_from_youtube_data_source.dart';
import 'package:spotify_downloader/features/data/dowload_tracks/models/dowload_audio_from_youtube_args.dart';
import 'package:spotify_downloader/features/data/dowload_tracks/models/loading_stream/loading_result_status.dart';
import 'package:spotify_downloader/features/data/dowload_tracks/models/loading_stream/loading_stream.dart';
import 'package:spotify_downloader/features/data/dowload_tracks/repositories/converters/track_to_audio_metadata_converter.dart';
import 'package:spotify_downloader/features/domain/dowload_tracks/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/domain/shared/entities/track.dart';

import 'package:path/path.dart' as p;
import '../../../domain/dowload_tracks/entities/track_observer.dart';
import '../../../domain/dowload_tracks/entities/loading_track_info.dart';

class DowloadTracksRepositoryImpl {
  DowloadTracksRepositoryImpl({required DowloadAudioFromYoutubeDataSource dowloadAudioFromYoutubeDataSource})
      : _dowloadAudioFromYoutubeDataSource = dowloadAudioFromYoutubeDataSource;

  final DowloadAudioFromYoutubeDataSource _dowloadAudioFromYoutubeDataSource;
  final TrackToAudioMetadataConverter _trackToAudioMetadataConverter = TrackToAudioMetadataConverter();

  final List<(LoadingTrackId, Track, List<TrackObserver>)> _loadingTracksQueue = List.empty(growable: true);
  final List<(LoadingTrackId, LoadingStream, List<TrackObserver>)> _loadingTracks = List.empty(growable: true);

  final int _sameTimeloadingTrackLimit = 5;

  Future<Result<Failure, TrackObserver>> dowloadTrack(Track track) async {
    final trackObserver = TrackObserver(track: track);
    final loadingTrackId = LoadingTrackId(
        parentSpotifyId: track.parentCollection.spotifyId,
        parentType: track.parentCollection.type,
        spotifyId: track.spotifyId);
    final trackObservers = List<TrackObserver>.empty()..add(trackObserver);

    if (_loadingTracks.length >= _sameTimeloadingTrackLimit) {
      _loadingTracksQueue.add((loadingTrackId, track, trackObservers));
      return Result.isSuccessful(trackObserver);
    } else { 
      if (track.youtubeUrl != null) {
        trackObserver.status = LoadingTrackStatus.loading;
        _startTrackLoading(loadingTrackId, track, trackObservers);
        return Result.isSuccessful(trackObserver);
      } else {
        return Result.notSuccessful(NotFoundFailure(message: 'youtube url not specified'));
      }
    }
  }

  Result<Failure, void> cancelTrackLoading(Track track) {
    final loadingTrackId = LoadingTrackId(
        parentSpotifyId: track.parentCollection.spotifyId,
        parentType: track.parentCollection.type,
        spotifyId: track.spotifyId);
    
    final foundLoadingTrack = _loadingTracks.where((e) => e.$1 == loadingTrackId).firstOrNull;
    if (foundLoadingTrack != null) {
      foundLoadingTrack.$2.cancel();
      _loadingTracks.remove(foundLoadingTrack);
      return Result.isSuccessful(Void);
    }

    return Result.notSuccessful(NotFoundFailure(message: 'this track isn\'t dowloading'));
  }

  Future<Result<Failure, TrackObserver?>> getTrackObserver(Track track) async {
    final trackObserver = TrackObserver(track: track);
    
  }

  Future<Result<Failure, void>> removeTrackObserver(TrackObserver observer) async {
    throw UnimplementedError();
  }

  void _onLoadingStreamEnded(Result<Failure, LoadingResultStatus> result, List<TrackObserver> trackObservers) {
    _loadingTracks.removeWhere((e) => e.$3 == trackObservers);

    if (result.isSuccessful) {
      if (result.result! == LoadingResultStatus.loaded) {
        for (var trackObserver in trackObservers) {
          trackObserver.status = LoadingTrackStatus.loaded;
          trackObserver.onLoaded?.call();
        }
      } else {
        for (var trackObserver in trackObservers) {
          trackObserver.status = LoadingTrackStatus.loadingCancelled;
          trackObserver.onLoadingCancelled?.call();
        }
      }
    } else {
      for (var trackObserver in trackObservers) {
        trackObserver.status = LoadingTrackStatus.failure;
        trackObserver.onFailure?.call(result.failure!);
      }
    }

    _loadNextTrackInQueue();
  }

  Future<void> _loadNextTrackInQueue() async {
    if (_loadingTracks.length < _sameTimeloadingTrackLimit) {
      if (_loadingTracksQueue.isNotEmpty) {
        final firstQueueObj = _loadingTracksQueue.first;
        _loadingTracksQueue.remove(firstQueueObj);

        _startTrackLoading(firstQueueObj.$1, firstQueueObj.$2, firstQueueObj.$3);
      }
    }
  }

  Future<void> _startTrackLoading(LoadingTrackId loadingTrackId, Track track, List<TrackObserver> trackObservers) async {
    final saveDirectoryPath =
        p.join((await getApplicationDocumentsDirectory()).path, '/${track.parentCollection.name}');

    final loadingStream = _dowloadAudioFromYoutubeDataSource.dowloadAudioFromYoutube(DowloadAudioFromYoutubeArgs(
        youtubeUrl: track.youtubeUrl!,
        saveDirectoryPath: saveDirectoryPath,
        audioMetadata: _trackToAudioMetadataConverter.convert(track)));

    loadingStream.onEnded = (result) => _onLoadingStreamEnded(result, trackObservers);
    loadingStream.onLoadingPercentChanged = (newPercent) {
      for (var trackObserver in trackObservers) {
        trackObserver.onLoadingPercentChanged?.call(newPercent);
      }
    };

    _loadingTracks.add((loadingTrackId, loadingStream, trackObservers));
  }
}

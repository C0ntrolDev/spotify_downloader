import 'dart:io';
import 'package:http/http.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/isolate_pool/isolate_pool.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/get_tracks_args.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/tracks_dto_getting_ended_status.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/tracks_getting_stream.dart';

class NetworkTracksDataSource {
  NetworkTracksDataSource({required String clientId, required String clientSecret})
      : _clientId = clientId,
        _clientSecret = clientSecret;

  Future<void> init() async {
    _isolatePool = await IsolatePool.create();
  }

  final String _clientId;
  final String _clientSecret;

  late final IsolatePool _isolatePool;

  Future<TracksGettingStream> getTracksFromPlaylist(GetTracksArgs args) {
    return _runTracksGettingFunctionInIsolate(() {
      final tracksGettingStream = TracksGettingStream();

      Future(() async {
        final tracksPagesResult = await _handleExceptions<Pages<Track>>(() async {
          final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));
          final trackPages = spotify.playlists.getTracksByPlaylistId(args.spotifyId);
          return Result.isSuccessful(trackPages);
        });

        if (tracksPagesResult.isSuccessful) {
          _getTracksFromPages(
              getPageTracks: (limit, offset) async {
                final page = await tracksPagesResult.result!.getPage(limit, offset);
                return page.items;
              },
              tracksGettingStream: tracksGettingStream,
              args: args);
        } else {
          tracksGettingStream.onEnded?.call(Result.notSuccessful(tracksPagesResult.failure));
        }
      });

      return tracksGettingStream;
    });
  }

  Future<TracksGettingStream> getTracksFromAlbum(GetTracksArgs args) {
    return _runTracksGettingFunctionInIsolate(() {
      final tracksGettingStream = TracksGettingStream();

      Future(() async {
        final tracksPagesResult = await _handleExceptions<Pages<TrackSimple>>(() async {
          final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));
          final trackPages = spotify.albums.tracks(args.spotifyId);
          return Result.isSuccessful(trackPages);
        });

        if (!tracksPagesResult.isSuccessful) {
          tracksGettingStream.onEnded?.call(Result.notSuccessful(tracksPagesResult.failure));
        }

        final albumResult = await _handleExceptions<Album>(() async {
          final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));
          final album = await spotify.albums.get(args.spotifyId);
          return Result.isSuccessful(album);
        });

        if (!albumResult.isSuccessful) {
          tracksGettingStream.onEnded?.call(Result.notSuccessful(albumResult.failure));
        }

        _getTracksFromPages(
            getPageTracks: (limit, offset) async {
              final simplePage = await tracksPagesResult.result!.getPage(limit, offset);
              return simplePage.items?.map((ts) => _trackSimpleToTrack(ts, albumResult.result!));
            },
            tracksGettingStream: tracksGettingStream,
            args: args);
      });

      return tracksGettingStream;
    });
  }

  Track _trackSimpleToTrack(TrackSimple trackSimple, Album album) {
    final track = Track();
    track.name = trackSimple.name;
    track.album = album;
    track.artists = trackSimple.artists;
    track.id = trackSimple.id;
    return track;
  }

  TracksGettingStream getTrackBySpotifyId(GetTracksArgs args) {
    final tracksGettingStream = TracksGettingStream();

    Future(() async {
      final result = await _handleExceptions<Track>(() async {
        final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));
        final track = await spotify.tracks.get(args.spotifyId);
        return Result.isSuccessful(track);
      });

      if (result.isSuccessful) {
        args.responseList.add(result.result!);
        tracksGettingStream.onPartGot?.call([result.result!]);
        tracksGettingStream.onEnded?.call(const Result.isSuccessful(TracksDtoGettingEndedStatus.loaded));
      } else {
        tracksGettingStream.onEnded?.call(Result.notSuccessful(result.failure));
      }
    });

    return tracksGettingStream;
  }

  Future<TracksGettingStream> _runTracksGettingFunctionInIsolate(TracksGettingStream Function() function) async {
    final tracksGettingStream = TracksGettingStream();

    final cancellableStream = await _isolatePool.add((sendPort, params, token) async {
      final isolateTracksGettingStream = function.call();
      isolateTracksGettingStream.onPartGot = (part) => sendPort.send(part);
      isolateTracksGettingStream.onEnded = (result) => sendPort.send(result);
    }, null);
    cancellableStream.stream.listen((message) {
      if (message is List<Track>) {
        tracksGettingStream.onPartGot?.call(message);
        return;
      }

      if (message is Result<Failure, TracksDtoGettingEndedStatus>) {
        tracksGettingStream.onEnded?.call(message);
        return;
      }
    });

    return tracksGettingStream;
  }

  void _getTracksFromPages(
      {required Future<Iterable<Track>?> Function(int limit, int offset) getPageTracks,
      required GetTracksArgs args,
      required TracksGettingStream tracksGettingStream}) {
    final callbackTracks = List<Track>.empty(growable: true);

    var isFirstCallbackInvoked = false;

    Future(() async {
      for (var i = 0;; i++) {
        if (args.cancellationToken?.isCancelled ?? false) {
          tracksGettingStream.onEnded?.call(const Result.isSuccessful(TracksDtoGettingEndedStatus.cancelled));
          return;
        }

        final newTracksResult = await _handleExceptions<Iterable<Track>?>(() async {
          final responseTracks = await getPageTracks.call(50, i * 50 + args.offset);
          return Result.isSuccessful(responseTracks);
        });

        if (!newTracksResult.isSuccessful) {
          tracksGettingStream.onEnded?.call(Result.notSuccessful(newTracksResult.failure));
          return;
        }

        final newTracks = newTracksResult.result;

        if (newTracks == null || newTracks.isEmpty) {
          args.responseList.addAll(callbackTracks);
          tracksGettingStream.onPartGot?.call(callbackTracks);
          break;
        } 

        callbackTracks.addAll(newTracks);

        if (callbackTracks.length >= (isFirstCallbackInvoked ? args.callbackLength : args.firstCallbackLength)) {
          if (!isFirstCallbackInvoked) {
            isFirstCallbackInvoked = true;
          }

          args.responseList.addAll(callbackTracks);
          tracksGettingStream.onPartGot?.call(callbackTracks);
          callbackTracks.clear();
        }
      }

      tracksGettingStream.onEnded?.call(const Result.isSuccessful(TracksDtoGettingEndedStatus.loaded));
    });
  }

  Future<Result<Failure, T>> _handleExceptions<T>(Future<Result<Failure, T>> Function() function) async {
    try {
      final result = await function.call();
      return result;
    } on SpotifyException catch (e) {
      if (e.status == 404) {
        return Result.notSuccessful(NotFoundFailure(message: e));
      }
      return Result.notSuccessful(Failure(message: e));
    } on ClientException catch (e) {
      return Result.notSuccessful(NetworkFailure(message: e));
    } on SocketException catch (e) {
      return Result.notSuccessful(NetworkFailure(message: e));
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }
}

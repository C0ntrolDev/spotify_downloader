import 'dart:io';
import 'dart:isolate';
import 'package:http/http.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/consts/spotify_client.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/get_tracks_args.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/tracks_dto_getting_ended_status.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/tracks_getting_stream.dart';

class NetworkTracksDataSource {
  NetworkTracksDataSource({required String clientId, required String clientSecret})
      : _clientId = clientId,
        _clientSecret = clientSecret;

  final String _clientId;
  final String _clientSecret;

  Future<TracksGettingStream> getTracksFromPlaylist(GetTracksArgs args) {
    return _runTracksGettingFunctionInIsolate((params) {
      final clientId = params.$1;
      final clientSecret = params.$2;
      final args = params.$3;

      final tracksGettingStream = TracksGettingStream();

      Future(() async {
        final tracksPagesResult = await _handleExceptions<Pages<Track>>(() async {
          final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(clientId, clientSecret));
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
    }, (_clientId, clientSecret, args));
  }

  Future<TracksGettingStream> getTracksFromAlbum(GetTracksArgs args) {
    return _runTracksGettingFunctionInIsolate((params) {
      final clientId = params.$1;
      final clientSecret = params.$2;
      final args = params.$3;

      final tracksGettingStream = TracksGettingStream();

      Future(() async {
        final tracksPagesResult = await _handleExceptions<Pages<TrackSimple>>(() async {
          final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(clientId, clientSecret));
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
    }, (_clientId, clientSecret, args));
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

  Future<TracksGettingStream> _runTracksGettingFunctionInIsolate(
      TracksGettingStream Function((String, String, GetTracksArgs)) function,
      (String, String, GetTracksArgs) args) async {
    final tracksGettingStream = TracksGettingStream();

    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(tracksGettingIsolateFunction, (receivePort.sendPort, function, args));
    receivePort.listen((message) {
      if (message is List<Track>) {
        tracksGettingStream.onPartGot?.call(message);
      }

      if (message is Result<Failure, TracksDtoGettingEndedStatus>) {
        tracksGettingStream.onEnded?.call(message);
        receivePort.close();
        isolate.kill();
      }
    });

    return tracksGettingStream;
  }

  void tracksGettingIsolateFunction(
      (
        SendPort,
        TracksGettingStream Function((String, String, GetTracksArgs)),
        (String, String, GetTracksArgs)
      ) params) {
    final sendPort = params.$1;
    final function = params.$2;
    final args = params.$3;

    final isolateTracksGettingStream = function.call(args);
    isolateTracksGettingStream.onPartGot = (part) => sendPort.send(part);
    isolateTracksGettingStream.onEnded = (result) => sendPort.send(result);
  }

  static void _getTracksFromPages(
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
          if (isFirstCallbackInvoked == false) {
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

  static Future<Result<Failure, T>> _handleExceptions<T>(Future<Result<Failure, T>> Function() function) async {
    try {
      final result = await function();
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

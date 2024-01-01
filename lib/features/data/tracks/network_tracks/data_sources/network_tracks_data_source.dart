import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/isolate_pool/isolate_pool.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/util_methods.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/get_tracks_args.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/tracks_dto_getting_ended_status.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/tracks_getting_stream.dart';

class NetworkTracksDataSource {
  Future<void> init() async {
    _isolatePool = await IsolatePool.create();
  }

  late final IsolatePool _isolatePool;

  Future<TracksGettingStream> getTracksFromPlaylist(GetTracksArgs args) {
    return _runTracksGettingFunctionInIsolate(() {
      final tracksGettingStream = TracksGettingStream();

      Future(() async {
        final tracksPagesResult = await handleSpotifyClientExceptions<Pages<Track>>(() async {
          final spotify = await SpotifyApi.asyncFromCredentials(args.spotifyApiRequest.spotifyApiCredentials,
              onCredentialsRefreshed: args.spotifyApiRequest.onCredentialsRefreshed);
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
        final tracksPagesResult = await handleSpotifyClientExceptions<Pages<TrackSimple>>(() async {
          final spotify = await SpotifyApi.asyncFromCredentials(args.spotifyApiRequest.spotifyApiCredentials,
              onCredentialsRefreshed: args.spotifyApiRequest.onCredentialsRefreshed);
          final trackPages = spotify.albums.tracks(args.spotifyId);
          return Result.isSuccessful(trackPages);
        });

        if (!tracksPagesResult.isSuccessful) {
          tracksGettingStream.onEnded?.call(Result.notSuccessful(tracksPagesResult.failure));
        }

        final albumResult = await handleSpotifyClientExceptions<Album>(() async {
          final spotify = await SpotifyApi.asyncFromCredentials(args.spotifyApiRequest.spotifyApiCredentials,
              onCredentialsRefreshed: args.spotifyApiRequest.onCredentialsRefreshed);
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

  Future<TracksGettingStream> getLikedTracks(GetTracksArgs args) {
    return _runTracksGettingFunctionInIsolate(() {
      final tracksGettingStream = TracksGettingStream();

      Future(() async {
        final tracksPagesResult = await handleSpotifyClientExceptions<Pages<TrackSaved>>(() async {
          final spotify = await SpotifyApi.asyncFromCredentials(args.spotifyApiRequest.spotifyApiCredentials,
              onCredentialsRefreshed: args.spotifyApiRequest.onCredentialsRefreshed);
          final trackPages = spotify.tracks.me.saved;
          return Result.isSuccessful(trackPages);
        });

        if (tracksPagesResult.isSuccessful) {
          _getTracksFromPages(
              getPageTracks: (limit, offset) async {
                final page = await tracksPagesResult.result!.getPage(limit, offset);
                return page.items
                    ?.where((savedTrack) => savedTrack.track != null)
                    .map((savedTrack) => savedTrack.track!);
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
      final result = await handleSpotifyClientExceptions<Track>(() async {
        final spotify = await SpotifyApi.asyncFromCredentials(args.spotifyApiRequest.spotifyApiCredentials,
            onCredentialsRefreshed: args.spotifyApiRequest.onCredentialsRefreshed);
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

        final newTracksResult = await handleSpotifyClientExceptions<Iterable<Track>?>(() async {
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
}

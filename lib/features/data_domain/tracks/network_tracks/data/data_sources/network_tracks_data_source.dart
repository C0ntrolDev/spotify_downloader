import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/data/models/liked_track_dto.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/data/models/models.dart';

class NetworkTracksDataSource {
  Future<void> init() async {
    _isolatePool = await IsolatePool.create();
  }

  late final IsolatePool _isolatePool;

  Future<TracksGettingStream> getTracksFromPlaylist(GetTracksArgs args) {
    return _runTracksGettingFunctionInIsolate((isolateOnCredentialsRefreshed) {
      final tracksGettingStream = TracksGettingStream();

      Future(() async {
        final tracksPagesResult = await handleSpotifyClientExceptions<Pages<Track>>(() async {
          final spotify = await SpotifyApi.asyncFromCredentials(args.spotifyApiRequest.spotifyApiCredentials,
              onCredentialsRefreshed: isolateOnCredentialsRefreshed);
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
    }, args.spotifyApiRequest.onCredentialsRefreshed);
  }

  Future<TracksGettingStream> getTracksFromAlbum(GetTracksArgs args) {
    return _runTracksGettingFunctionInIsolate((isolateOnCredentialsRefreshed) {
      final tracksGettingStream = TracksGettingStream();

      Future(() async {
        final tracksPagesResult = await handleSpotifyClientExceptions<Pages<TrackSimple>>(() async {
          final spotify = await SpotifyApi.asyncFromCredentials(args.spotifyApiRequest.spotifyApiCredentials,
              onCredentialsRefreshed: isolateOnCredentialsRefreshed);
          final trackPages = spotify.albums.tracks(args.spotifyId);
          return Result.isSuccessful(trackPages);
        });

        if (!tracksPagesResult.isSuccessful) {
          tracksGettingStream.onEnded?.call(Result.notSuccessful(tracksPagesResult.failure));
        }

        final albumResult = await handleSpotifyClientExceptions<Album>(() async {
          final spotify = await SpotifyApi.asyncFromCredentials(args.spotifyApiRequest.spotifyApiCredentials,
              onCredentialsRefreshed: isolateOnCredentialsRefreshed);
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
    }, args.spotifyApiRequest.onCredentialsRefreshed);
  }

  Track _trackSimpleToTrack(TrackSimple trackSimple, Album album) {
    final track = Track();
    track.album = album;
    track.artists = trackSimple.artists;
    track.availableMarkets = trackSimple.availableMarkets;
    track.discNumber = trackSimple.discNumber;
    track.durationMs = trackSimple.durationMs;
    track.explicit = trackSimple.explicit;
    track.externalUrls = trackSimple.externalUrls;
    track.href = trackSimple.href;
    track.id = trackSimple.id;
    track.isPlayable = trackSimple.isPlayable;
    track.linkedFrom = trackSimple.linkedFrom;
    track.name = trackSimple.name;
    track.previewUrl = trackSimple.previewUrl;
    track.trackNumber = trackSimple.trackNumber;
    track.type = trackSimple.type;
    track.uri = trackSimple.uri;
    return track;
  }

  Future<TracksGettingStream> getLikedTracks(GetTracksArgs args) {
    return _runTracksGettingFunctionInIsolate((isolateOnCredentialsRefreshed) {
      final tracksGettingStream = TracksGettingStream();

      Future(() async {
        final tracksPagesResult = await handleSpotifyClientExceptions<Pages<TrackSaved>>(() async {
          final spotify = await SpotifyApi.asyncFromCredentials(args.spotifyApiRequest.spotifyApiCredentials,
              onCredentialsRefreshed: isolateOnCredentialsRefreshed);
          final trackPages = spotify.tracks.me.saved;
          return Result.isSuccessful(trackPages);
        });

        if (tracksPagesResult.isSuccessful) {
          _getTracksFromPages(
              getPageTracks: (limit, offset) async {
                final page = await tracksPagesResult.result!.getPage(limit, offset);
                return page.items?.where((savedTrack) => savedTrack.track != null).map((savedTrack) {
                  return trackSavedToLikedTrack(savedTrack);
                });
              },
              tracksGettingStream: tracksGettingStream,
              args: args);
        } else {
          tracksGettingStream.onEnded?.call(Result.notSuccessful(tracksPagesResult.failure));
        }
      });

      return tracksGettingStream;
    }, args.spotifyApiRequest.onCredentialsRefreshed);
  }

  LikedTrackDto trackSavedToLikedTrack(TrackSaved savedTrack) {
    final likedTrack = LikedTrackDto(addedAt: savedTrack.addedAt);

    likedTrack.album = savedTrack.track?.album;
    likedTrack.artists = savedTrack.track?.artists;
    likedTrack.availableMarkets = savedTrack.track?.availableMarkets;
    likedTrack.discNumber = savedTrack.track?.discNumber;
    likedTrack.durationMs = savedTrack.track?.durationMs;
    likedTrack.explicit = savedTrack.track?.explicit;
    likedTrack.externalIds = savedTrack.track?.externalIds;
    likedTrack.externalUrls = savedTrack.track?.externalUrls;
    likedTrack.href = savedTrack.track?.href;
    likedTrack.id = savedTrack.track?.id;
    likedTrack.isPlayable = savedTrack.track?.isPlayable;
    likedTrack.linkedFrom = savedTrack.track?.linkedFrom;
    likedTrack.name = savedTrack.track?.name;
    likedTrack.popularity = savedTrack.track?.popularity;
    likedTrack.previewUrl = savedTrack.track?.previewUrl;
    likedTrack.trackNumber = savedTrack.track?.trackNumber;
    likedTrack.type = savedTrack.track?.type;
    likedTrack.uri = savedTrack.track?.uri;

    return likedTrack;
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

  Future<TracksGettingStream> _runTracksGettingFunctionInIsolate(
      TracksGettingStream Function(void Function(SpotifyApiCredentials)? onCredentialsRefreshed) function,
      [void Function(SpotifyApiCredentials)? onCredentialsRefreshed]) async {
    final tracksGettingStream = TracksGettingStream();

    final cancellableStream = await _isolatePool.add((sendPort, params, token) async {
      final isolateTracksGettingStream = function.call((newCredentials) => sendPort.send(newCredentials));
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

      if (message is SpotifyApiCredentials) {
        onCredentialsRefreshed?.call(message);
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

import 'dart:io';

import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/get_tracks_args.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/tracks_dto_loading_ended_status.dart';

class NetworkTracksDataSource {
  NetworkTracksDataSource({required String clientId, required String clientSecret})
      : _clientId = clientId,
        _clientSecret = clientSecret;

  final String _clientId;
  final String _clientSecret;

  void getTracksFromPlaylist(GetTracksArgs args) {
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
            args: args);
      } else {
        args.onLoadingEnded?.call(Result.notSuccessful(tracksPagesResult.failure));
      }
    });
  }

  void getTracksFromAlbum(GetTracksArgs args) {
    Future(() async {
      final tracksPagesResult = await _handleExceptions<Pages<TrackSimple>>(() async {
        final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));
        final trackPages = spotify.albums.tracks(args.spotifyId);
        return Result.isSuccessful(trackPages);
      });

      if (!tracksPagesResult.isSuccessful) {
        args.onLoadingEnded?.call(Result.notSuccessful(tracksPagesResult.failure));
      }

      final albumResult = await _handleExceptions<Album>(() async {
        final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));
        final album = await spotify.albums.get(args.spotifyId);
        return Result.isSuccessful(album);
      });

      if (!albumResult.isSuccessful) {
        args.onLoadingEnded?.call(Result.notSuccessful(albumResult.failure));
      }

      _getTracksFromPages(
          getPageTracks: (limit, offset) async {
            final simplePage = await tracksPagesResult.result!.getPage(limit, offset);
            return simplePage.items?.map((ts) => _trackSimpleToTrack(ts, albumResult.result!));
          },
          args: args);
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

  void getTrackBySpotifyId(GetTracksArgs args) {
    Future(() async {
      final result = await _handleExceptions<Track>(() async {
        final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));
        final track = await spotify.tracks.get(args.spotifyId);
        return Result.isSuccessful(track);
      });

      if (result.isSuccessful) {
        args.responseList.add(result.result!);
        return Result.isSuccessful(result);
      } else {
        return Result.notSuccessful(result.failure);
      }
    });
  }

  void _getTracksFromPages(
      {required Future<Iterable<Track>?> Function(int limit, int offset) getPageTracks, required GetTracksArgs args}) {
    final callbackTracks = List<Track>.empty(growable: true);

    var isFirstCallbackInvoked = false;

    Future(() async {
      for (var i = 0;; i++) {
        if (args.cancellationToken?.isCancelled ?? false) {
          args.onLoadingEnded?.call(const Result.isSuccessful(TracksDtoLoadingEndedStatus.cancelled));
          return;
        }

        final newTracksResult = await _handleExceptions<Iterable<Track>?>(() async {
          final responseTracks = await getPageTracks.call(50, i * 50);
          return Result.isSuccessful(responseTracks);
        });

        if (!newTracksResult.isSuccessful) {
          args.onLoadingEnded?.call(Result.notSuccessful(newTracksResult.failure));
        }

        final newTracks = newTracksResult.result;

        if (newTracks == null || newTracks.isEmpty) {
          args.responseList.addAll(callbackTracks);
          args.onPartLoaded?.call(callbackTracks);
          break;
        }

        callbackTracks.addAll(newTracks);

        if (callbackTracks.length >= (isFirstCallbackInvoked ? args.callbackLength : args.firstCallbackLength)) {
          if (isFirstCallbackInvoked == false) {
            isFirstCallbackInvoked = true;
          }

          args.responseList.addAll(callbackTracks);
          args.onPartLoaded?.call(callbackTracks);
          callbackTracks.clear();
        }
      }

      args.onLoadingEnded?.call(const Result.isSuccessful(TracksDtoLoadingEndedStatus.loaded));
    });
  }

  Future<Result<Failure, T>> _handleExceptions<T>(Future<Result<Failure, T>> Function() function) async {
    try {
      final result = await function();
      return result;
    } on SpotifyException catch (e) {
      if (e.status == 404) {
        return Result.notSuccessful(NotFoundFailure(message: e));
      }
      return Result.notSuccessful(Failure(message: e));
    } on SocketException catch (e) {
      return Result.notSuccessful(NetworkFailure(message: e));
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }
}

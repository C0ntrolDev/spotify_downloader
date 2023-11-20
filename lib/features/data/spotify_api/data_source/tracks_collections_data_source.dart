import 'dart:io';
import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';

class TracksCollectionsDataSource {
  TracksCollectionsDataSource({
    required String clientId,
    required String clientSecret,
  })  : _clientId = clientId,
        _clientSecret = clientSecret;

  final String _clientId;
  final String _clientSecret;

  Future<Result<Failure, Playlist>> getPlaylistBySpotifyId(String spotifyId) async {
    return await _handleExceptions<Playlist>(() async {
      final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));
      final playlist = await spotify.playlists.get(spotifyId);
      return Result.isSuccessful(playlist);
    });
  }

  Future<Result<Failure, Playlist>> getAlbumBySpotifyId(String spotifyId) {
    return getPlaylistBySpotifyId(spotifyId);
  }

  Future<Result<Failure, Track>> getTrackBySpotifyId(String spotifyId) async {
    return await _handleExceptions<Track>(() async {
      final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));
      final track = await spotify.tracks.get(spotifyId);
      return Result.isSuccessful(track);
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

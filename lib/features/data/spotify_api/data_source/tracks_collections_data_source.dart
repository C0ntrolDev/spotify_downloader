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
    try {
      final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));

      try {
        final playlist = await spotify.playlists.get(spotifyId);
        return Result.isSuccessful(playlist);
      } on SpotifyException catch (e) {
        if (e.status == 404) {
          return Result.notSuccessful(NotFoundFailure(message: e));
        }
        return Result.notSuccessful(Failure(message: e));
      }
    } on SocketException catch (e) {
      return Result.notSuccessful(NetworkFailure(message: e));
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }
}

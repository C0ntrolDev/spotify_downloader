import 'dart:convert';

import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/shared/data/spotify_api_request.dart';
import 'package:http/http.dart' as http;

class NetworkTracksCollectionsDataSource {
  Future<Result<Failure, Playlist>> getPlaylistBySpotifyId(
      SpotifyApiRequest spotifyApiRequest, String spotifyId) async {
    return handleSpotifyClientExceptions<Playlist>(() async {
      final spotify = await SpotifyApi.asyncFromCredentials(spotifyApiRequest.spotifyApiCredentials,
          onCredentialsRefreshed: spotifyApiRequest.onCredentialsRefreshed);
      final playlist = await spotify.playlists.get(spotifyId);
      return Result.isSuccessful(playlist);
    });
  }

  Future<Result<Failure, Album>> getAlbumBySpotifyId(SpotifyApiRequest spotifyApiRequest, String spotifyId) async {
    return handleSpotifyClientExceptions<Album>(() async {
      final spotify = await SpotifyApi.asyncFromCredentials(spotifyApiRequest.spotifyApiCredentials,
          onCredentialsRefreshed: spotifyApiRequest.onCredentialsRefreshed);
      final album = await spotify.albums.get(spotifyId);
      return Result.isSuccessful(album);
    });
  }

  Future<Result<Failure, Track>> getTrackBySpotifyId(SpotifyApiRequest spotifyApiRequest, String spotifyId) async {
    return handleSpotifyClientExceptions<Track>(() async {
      final spotify = await SpotifyApi.asyncFromCredentials(spotifyApiRequest.spotifyApiCredentials,
          onCredentialsRefreshed: spotifyApiRequest.onCredentialsRefreshed);
      final track = await spotify.tracks.get(spotifyId);
      return Result.isSuccessful(track);
    });
  }

  Future<Result<Failure, int>> getLikedTracksCount(SpotifyApiRequest spotifyApiRequest) async {
    return handleSpotifyClientExceptions<int>(() async {
      var credentials = spotifyApiRequest.spotifyApiCredentials;

      await SpotifyApi.asyncFromCredentials(spotifyApiRequest.spotifyApiCredentials,
          onCredentialsRefreshed: (newCredentials) {
        credentials = newCredentials;
        spotifyApiRequest.onCredentialsRefreshed?.call(newCredentials);
      });

      final response = await http.get(Uri.parse("https://api.spotify.com/v1/me/tracks?limit=1&offset=0"),
          headers: {"Authorization": "Bearer ${credentials.accessToken}"});

      if (response.statusCode != 200) {
        throw SpotifyException()
          ..status = response.statusCode
          ..message = response.body;
      }

      var total = (jsonDecode(response.body) as Map<String, dynamic>)["total"]?.toString();
      if (total == null || total.isEmpty || int.tryParse(total) == null) {
        return Result.notSuccessful(
            Failure(message: "something went wrong, when tried to get liked tracks count| count: $total"));
      }

      return Result.isSuccessful(int.tryParse(total));
    });
  }
}

import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/util_methods.dart';
import 'package:spotify_downloader/features/data/shared/spotify_api_request.dart';

class NetworkTracksCollectionsDataSource {
  Future<Result<Failure, Playlist>> getPlaylistBySpotifyId(
      SpotifyApiRequest spotifyApiRequest, String spotifyId) async {
    return await handleSpotifyClientExceptions<Playlist>(() async {
      final spotify = await SpotifyApi.asyncFromCredentials(spotifyApiRequest.spotifyApiCredentials,
          onCredentialsRefreshed: spotifyApiRequest.onCredentialsRefreshed);
      final playlist = await spotify.playlists.get(spotifyId);
      return Result.isSuccessful(playlist);
    });
  }

  Future<Result<Failure, Album>> getAlbumBySpotifyId(SpotifyApiRequest spotifyApiRequest, String spotifyId) async {
    return await handleSpotifyClientExceptions<Album>(() async {
      final spotify = await SpotifyApi.asyncFromCredentials(spotifyApiRequest.spotifyApiCredentials,
          onCredentialsRefreshed: spotifyApiRequest.onCredentialsRefreshed);
      final album = await spotify.albums.get(spotifyId);
      return Result.isSuccessful(album);
    });
  }

  Future<Result<Failure, Track>> getTrackBySpotifyId(SpotifyApiRequest spotifyApiRequest, String spotifyId) async {
    return await handleSpotifyClientExceptions<Track>(() async {
      final spotify = await SpotifyApi.asyncFromCredentials(spotifyApiRequest.spotifyApiCredentials,
          onCredentialsRefreshed: spotifyApiRequest.onCredentialsRefreshed);
      final track = await spotify.tracks.get(spotifyId);
      return Result.isSuccessful(track);
    });
  }
}

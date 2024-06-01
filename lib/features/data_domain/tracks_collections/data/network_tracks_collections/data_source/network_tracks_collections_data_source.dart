import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/core/utils/util_methods.dart';
import 'package:spotify_downloader/features/data_domain/shared/data/spotify_api_request.dart';

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
}

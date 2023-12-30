import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/util_methods.dart';

class NetworkTracksCollectionsDataSource {
  NetworkTracksCollectionsDataSource({
    required String clientId,
    required String clientSecret,
  })  : _clientId = clientId,
        _clientSecret = clientSecret;

  final String _clientId;
  final String _clientSecret;

  Future<Result<Failure, Playlist>> getPlaylistBySpotifyId(String spotifyId) async {
    return await handleSpotifyClientExceptions<Playlist>(() async {
      final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));
      final playlist = await spotify.playlists.get(spotifyId);
      return Result.isSuccessful(playlist);
    });
  }

  Future<Result<Failure, Album>> getAlbumBySpotifyId(String spotifyId) async {
    return await handleSpotifyClientExceptions<Album>(() async {
      final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));
      final album = await spotify.albums.get(spotifyId);
      return Result.isSuccessful(album);
    });
  }

  Future<Result<Failure, Track>> getTrackBySpotifyId(String spotifyId) async {
    return await handleSpotifyClientExceptions<Track>(() async {
      final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));
      final track = await spotify.tracks.get(spotifyId);
      return Result.isSuccessful(track);
    });
  }
}

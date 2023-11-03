import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/infrastructure/exceptions/account_not_authorized_exception.dart';
import 'package:spotify_downloader/services/local_data_serivces/spotify_local_credentials_service.dart';

class SpotifyApiDataService {

  SpotifyApiDataService({
    required String clientId,
    required String clientSecret,
    required SpotifyLocalCredentialsService spotifyLocalCredentialsService,
  }) : 
  _clientId = clientId,
  _clientSecret = clientSecret,
  _spotifyCredentialsLocalDataService = spotifyLocalCredentialsService;


  final SpotifyLocalCredentialsService _spotifyCredentialsLocalDataService;
  final String _clientId;
  final String _clientSecret;

  SpotifyApiCredentials? spotifyCredentials;


  Future<Track> getTrackByUrl(String url) async {
    final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));
    final track = await spotify.tracks.get(getIdFromUrl(url));
    return track;
  }

  Future<Playlist> getPlaylistByUrl(String url) async {
    final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));
    final playlist = await spotify.playlists.get(getIdFromUrl(url));
    final tracks = await spotify.playlists.getTracksByPlaylistId(getIdFromUrl(url));
    return playlist;
  }

  Future<Playlist> getAlbumByUrl(String url) async {
    final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));
    final album = await spotify.playlists.get(getIdFromUrl(url));
    return album;
  }

  Future<List<Track>> getLikedTracks() async {
    if (spotifyCredentials?.accessToken == null) {
      throw AccountNotAuthorizedException(cause: 'spotify account not authorize');
    }

    final spotify = await SpotifyApi.asyncFromCredentials(
      spotifyCredentials!,
      onCredentialsRefreshed: (newCredentials) => _spotifyCredentialsLocalDataService.saveSpotifyApiCredentials(newCredentials));

    final List<Track> likedTracks = List<Track>.empty(growable: true);

    for (var i = 0;; i++) {
      final tracksPage = await spotify.tracks.me.saved.getPage(50, i);
      if(tracksPage.items == null || tracksPage.items!.isEmpty) {
        break;
      }

      likedTracks.addAll(
        tracksPage.items!
        .where((t) => t.track != null)
        .map((t) => t.track!));
    }

    return likedTracks;
  }

  String getIdFromUrl(String url) {
    final stringWithoutUrlAdress = url.split('/').last;
    final id = stringWithoutUrlAdress.split('?').first;
    return id;
  }


}
import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/services/local_data_serivces/spotify_local_credentials_service.dart';
import 'package:spotify_downloader/services/spotify_api_data_service/spotify_api_data_service.dart';
import 'package:spotify_downloader/services/spotify_autorization_service/spotify_autorization_service.dart';

class SpotifyApiRepository {
  SpotifyApiRepository._create(
      {required SpotifyAutorizationService spotifyAutorizationService,
      required SpotifyApiDataService spotifyApiDataService,
      required SpotifyLocalCredentialsService spotifyLocalCredentialsService})
      : _spotifyAutorizationService = spotifyAutorizationService,
        _spotifyApiDataService = spotifyApiDataService,
        _spotifyLocalCredentialsService = spotifyLocalCredentialsService;

  static Future<SpotifyApiRepository> create(
      {required SpotifyAutorizationService spotifyAutorizationService,
      required SpotifyApiDataService spotifyApiDataService,
      required SpotifyLocalCredentialsService spotifyLocalCredentialsService}) async {
    final localcredentials = await spotifyLocalCredentialsService.loadSpotifyApiCredentials();
    final spotifyApiRepository = SpotifyApiRepository._create(
        spotifyAutorizationService: spotifyAutorizationService,
        spotifyApiDataService: spotifyApiDataService,
        spotifyLocalCredentialsService: spotifyLocalCredentialsService);

    spotifyApiDataService.spotifyCredentials = localcredentials;
    return spotifyApiRepository;
  }

  final SpotifyAutorizationService _spotifyAutorizationService;
  final SpotifyApiDataService _spotifyApiDataService;
  final SpotifyLocalCredentialsService _spotifyLocalCredentialsService;

  bool get isAccountAutorized => _spotifyApiDataService.spotifyCredentials != null;

  Future<bool> tryAutorizeAccount() async {
    var spotifyCredentials = await _spotifyAutorizationService.authorizeAccount();

    if (spotifyCredentials == null) {
      return false;
    }

    _spotifyApiDataService.spotifyCredentials = spotifyCredentials;
    _spotifyLocalCredentialsService.saveSpotifyApiCredentials(spotifyCredentials);
    return true;
  }

  Future<void> deleteLocalAccountAutorize() async {
    _spotifyApiDataService.spotifyCredentials = null;
    await _spotifyLocalCredentialsService.deleteSpotifyApiCredentials();
  }

  Future<Track?> getTrackByUrl(String url) {
    return _spotifyApiDataService.getTrackByUrl(url);
  }

  Future<Playlist?> getPlaylistByUrl(String url) {
    return _spotifyApiDataService.getPlaylistByUrl(url);
  }

  Future<Playlist?> getAlbumByUrl(String url) {
    return _spotifyApiDataService.getAlbumByUrl(url);
  }

  Future<void> getTrackCollectionByPlaylist({
    required Playlist playlist,
    required List<Track> saveCollection,
    required Function updateCallback,
    int firstCallbackLength = 750,
    int callbackLength = 50,
  }) {
    return _spotifyApiDataService.getTrackCollectionByPlaylist(
        playlist: playlist,
        saveCollection: saveCollection,
        updateCallback: updateCallback,
        firstCallbackLength: firstCallbackLength,
        callbackLength: callbackLength);
  }

  Future<void> getLikedTracks({
    required List<TrackSaved> saveCollection,
    required Function updateCallback,
    int firstCallbackLength = 750,
    int callbackLength = 50,
  }) {
    return _spotifyApiDataService.getLikedTracks(
        saveCollection: saveCollection,
        updateCallback: updateCallback,
        firstCallbackLength: firstCallbackLength,
        callbackLength: callbackLength);
  }
}

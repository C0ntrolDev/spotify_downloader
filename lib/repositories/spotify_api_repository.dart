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

    spotifyApiRepository._spotifyCredentials = localcredentials;
    return spotifyApiRepository;
  }


  final SpotifyAutorizationService _spotifyAutorizationService;
  final SpotifyApiDataService _spotifyApiDataService;
  final SpotifyLocalCredentialsService _spotifyLocalCredentialsService;

  SpotifyApiCredentials? _spotifyCredentials;

  bool get isAccountAutorized => _spotifyCredentials != null;


  Future<bool> tryAutorizeAccount() async {
    if (isAccountAutorized) {
      return true;
    }

    var spotifyCredentials = await _spotifyAutorizationService.authorizeAccount();

    if (spotifyCredentials == null) {
      return false;
    }

    _spotifyCredentials = spotifyCredentials;
    _spotifyLocalCredentialsService.saveSpotifyApiCredentials(spotifyCredentials);
    return true;
  }

  Future<Track?> getTrackByUrl(String url) {
    return _spotifyApiDataService.getTrackByUrl(url);
  }
}

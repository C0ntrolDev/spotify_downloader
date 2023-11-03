import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/spotify_oauth2_client.dart';
import 'package:spotify/spotify.dart';

class SpotifyAutorizationService {

  SpotifyAutorizationService({
    required String clientId,
    required String clientSecret
  }) : 
    _clientId = clientId, 
    _clientSecret = clientSecret;

  final String _clientId;
  final String _clientSecret;

  Future<SpotifyApiCredentials> authorizeAccount () async {
    AccessTokenResponse? accessToken;
    SpotifyOAuth2Client client = SpotifyOAuth2Client(
      customUriScheme: 'cd.syd.app',
      redirectUri: "cd.syd.app://callback",
    );
    var authResp = await client.requestAuthorization(
        clientId: _clientId,
        customParams: {'show_dialog': 'true'},
        scopes: ["user-library-read"]);
    var authCode = authResp.code;

    accessToken = await client.requestAccessToken(
        code: authCode.toString(),
        clientId: _clientId,
        clientSecret: _clientSecret);

    return SpotifyApiCredentials(
      _clientId, 
      _clientSecret,
      accessToken:  accessToken.accessToken,
      refreshToken: accessToken.refreshToken,
      expiration: accessToken.expirationDate,
      scopes: accessToken.scope
    );
  }
}
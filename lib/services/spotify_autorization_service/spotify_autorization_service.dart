import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/spotify_oauth2_client.dart';

class SpotifyAutorizationService {

  String clientId;
  String clientSecret;

  SpotifyAutorizationService({
    required this.clientId,
    required this.clientSecret
  });

  Future<AccessTokenResponse> authorizeAccount () async {
    AccessTokenResponse? accessToken;
    SpotifyOAuth2Client client = SpotifyOAuth2Client(
      customUriScheme: 'cd.syd.app',
      redirectUri: "cd.syd.app://callback",
    );
    var authResp = await client.requestAuthorization(
        clientId: clientId,
        customParams: {'show_dialog': 'true'},
        scopes: ["user-library-read"]);
    var authCode = authResp.code;

    accessToken = await client.requestAccessToken(
        code: authCode.toString(),
        clientId: clientId,
        clientSecret: clientSecret);

    return accessToken;
  }
}
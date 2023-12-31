import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/util/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/domain/shared/authorized_client_credentials.dart';

class SpotifyCredentialsConverter
    implements ValueConverter<SpotifyApiCredentials, AuthorizedClientCredentials> {
  @override
  SpotifyApiCredentials convert(AuthorizedClientCredentials clientCredentials) {
    return SpotifyApiCredentials(
      clientCredentials.clientId, 
      clientCredentials.clientSecret,
      refreshToken: clientCredentials.refreshToken,
      accessToken: clientCredentials.accessToken,
      expiration: clientCredentials.expiration);
  }

  @override
  AuthorizedClientCredentials convertBack(SpotifyApiCredentials spotifyApiCredentials) {
    return AuthorizedClientCredentials(
      clientId: spotifyApiCredentials.clientId ?? '', 
      clientSecret: spotifyApiCredentials.clientSecret ?? '', 
      refreshToken: spotifyApiCredentials.refreshToken,
      accessToken: spotifyApiCredentials.accessToken,
      expiration: spotifyApiCredentials.expiration);
  }
}

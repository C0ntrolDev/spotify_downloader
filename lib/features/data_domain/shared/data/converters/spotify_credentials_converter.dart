import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/consts/spotify_client.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/auth/shared/shared.dart';

class SpotifyCredentialsConverter
    implements ValueConverter<SpotifyApiCredentials, FullCredentials> {
  @override
  SpotifyApiCredentials convert(FullCredentials fullCredentials) {
    return SpotifyApiCredentials(
      fullCredentials.clientId, 
      fullCredentials.clientSecret,
      refreshToken: fullCredentials.refreshToken,
      accessToken: fullCredentials.accessToken,
      expiration: fullCredentials.expiration,
      scopes: clientScopes);
  }

  @override
  FullCredentials convertBack(SpotifyApiCredentials spotifyApiCredentials) {
    return FullCredentials(
      clientId: spotifyApiCredentials.clientId ?? '', 
      clientSecret: spotifyApiCredentials.clientSecret ?? '', 
      refreshToken: spotifyApiCredentials.refreshToken,
      accessToken: spotifyApiCredentials.accessToken,
      expiration: spotifyApiCredentials.expiration);
  }
}

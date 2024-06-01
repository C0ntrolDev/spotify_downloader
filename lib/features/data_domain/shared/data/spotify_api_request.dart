import 'package:spotify/spotify.dart';

class SpotifyApiRequest {
  SpotifyApiRequest({
    required this.spotifyApiCredentials,
    this.onCredentialsRefreshed
  });

  final SpotifyApiCredentials spotifyApiCredentials;
  final Function(SpotifyApiCredentials)? onCredentialsRefreshed;
}
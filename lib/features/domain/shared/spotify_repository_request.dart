import 'package:spotify_downloader/features/domain/shared/authorized_client_credentials.dart';

class SpotifyRepositoryRequest {
  SpotifyRepositoryRequest({
    required this.clientCredentials,
    this.onCredentialsRefreshed
  });

  final AuthorizedClientCredentials clientCredentials;
  final Function(AuthorizedClientCredentials)? onCredentialsRefreshed;
}
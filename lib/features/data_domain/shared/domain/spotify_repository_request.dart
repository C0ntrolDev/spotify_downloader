import 'package:spotify_downloader/features/data_domain/auth/shared/full_credentials.dart';

class SpotifyRepositoryRequest {
  SpotifyRepositoryRequest({
    required this.credentials,
    this.onCredentialsRefreshed
  });

  final FullCredentials credentials;
  final Function(FullCredentials)? onCredentialsRefreshed;
}
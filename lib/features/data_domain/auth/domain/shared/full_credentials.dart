import 'package:spotify_downloader/features/data_domain/auth/domain/shared/client_credentials.dart';
import 'package:spotify_downloader/features/data_domain/auth/domain/shared/user_credentials.dart';

class FullCredentials implements UserCredentials, ClientCredentials {
  FullCredentials(
      {required this.clientId,
      required this.clientSecret,
      required this.accessToken,
      required this.refreshToken,
      required this.expiration});

  @override
  final String clientId;
  @override
  final String clientSecret;

  @override
  final String? accessToken;
  @override
  final String? refreshToken;
  @override
  final DateTime? expiration;
}

import 'package:spotify_downloader/features/domain/shared/client_credentials.dart';

class AuthorizedClientCredentials extends ClientCredentials {
  final DateTime? expiration;
  final String? refreshToken;
  final String? accessToken;

  AuthorizedClientCredentials(
      {required super.clientId,
      required super.clientSecret,
      required this.refreshToken,
      required this.accessToken,
      required this.expiration});
}

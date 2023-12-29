import 'package:spotify_downloader/features/domain/auth/shared/client_credentials.dart';

class AuthorizedClientCredentials extends ClientCredentials {
  final String? refreshToken;

  AuthorizedClientCredentials({required super.clientId, required super.clientSecret, required this.refreshToken});
}

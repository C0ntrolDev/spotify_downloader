import 'package:spotify_downloader/core/util/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/data/auth/local_auth/models/local_auth_credentials.dart';
import 'package:spotify_downloader/features/domain/shared/authorized_client_credentials.dart';

class LocalAuthCredentialsToAuthCredentialsConverter implements ValueConverter<AuthorizedClientCredentials, LocalAuthCredentials> {
  static const String _notSpecified = 'not specified';

  @override
  AuthorizedClientCredentials convert(LocalAuthCredentials localAuthCredentials) {
    return AuthorizedClientCredentials(
        clientId: localAuthCredentials.clientId,
        clientSecret: localAuthCredentials.clientSecret,
        refreshToken: localAuthCredentials.refreshToken == _notSpecified ? null : localAuthCredentials.refreshToken);
  }

  @override
  LocalAuthCredentials convertBack(AuthorizedClientCredentials authCredentials) {
    return LocalAuthCredentials(
      clientId: authCredentials.clientId, 
      clientSecret: authCredentials.clientSecret ,
      refreshToken: authCredentials.refreshToken ?? _notSpecified);
  }
}

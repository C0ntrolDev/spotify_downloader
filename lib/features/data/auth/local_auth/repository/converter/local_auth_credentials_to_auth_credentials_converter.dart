import 'package:spotify_downloader/core/util/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/data/auth/local_auth/models/local_auth_credentials.dart';
import 'package:spotify_downloader/features/domain/auth/shared/authorized_client_credentials.dart';

class LocalAuthCredentialsToAuthCredentialsConverter implements ValueConverter<AuthorizedClientCredentials, LocalAuthCredentials> {
  @override
  AuthorizedClientCredentials convert(LocalAuthCredentials localAuthCredentials) {
    return AuthorizedClientCredentials(
        clientId: replaceEmptyStringToNull(localAuthCredentials.clientId),
        clientSecret: replaceEmptyStringToNull(localAuthCredentials.clientSecret),
        refreshToken: replaceEmptyStringToNull(localAuthCredentials.refreshToken));
  }

  @override
  LocalAuthCredentials convertBack(AuthorizedClientCredentials authCredentials) {
    return LocalAuthCredentials(
      clientId: authCredentials.clientId ?? '', 
      clientSecret: authCredentials.clientSecret ?? '', 
      refreshToken: authCredentials.refreshToken ?? '');
  }

  String? replaceEmptyStringToNull(String string) {
    if (string.isEmpty) {
      return null;
    }

    return string;
  }
}

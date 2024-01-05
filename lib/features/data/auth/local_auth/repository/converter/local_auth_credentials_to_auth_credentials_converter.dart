import 'package:spotify_downloader/core/util/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/data/auth/local_auth/models/local_auth_credentials.dart';
import 'package:spotify_downloader/features/domain/auth/shared/full_credentials.dart';

class LocalAuthCredentialsToAuthCredentialsConverter
    implements ValueConverter<FullCredentials, LocalAuthCredentials> {
  static const String _notSpecified = 'not specified';

  @override
  FullCredentials convert(LocalAuthCredentials localAuthCredentials) {
    return FullCredentials(
        clientId: localAuthCredentials.clientId,
        clientSecret: localAuthCredentials.clientSecret,
        refreshToken: localAuthCredentials.refreshToken == _notSpecified ? null : localAuthCredentials.refreshToken,
        accessToken: localAuthCredentials.accessToken == _notSpecified ? null : localAuthCredentials.accessToken,
        expiration: localAuthCredentials.expirationInMillisecondsSinceEpoch == _notSpecified
            ? null
            : DateTime.fromMillisecondsSinceEpoch(int.parse(localAuthCredentials.expirationInMillisecondsSinceEpoch)));
  }

  @override
  LocalAuthCredentials convertBack(FullCredentials fullCredentials) {
    return LocalAuthCredentials(
        clientId: fullCredentials.clientId,
        clientSecret: fullCredentials.clientSecret,
        refreshToken: fullCredentials.refreshToken ?? _notSpecified,
        accessToken: fullCredentials.accessToken ?? _notSpecified,
        expirationInMillisecondsSinceEpoch:
            fullCredentials.expiration?.millisecondsSinceEpoch.toString() ?? _notSpecified);
  }
}

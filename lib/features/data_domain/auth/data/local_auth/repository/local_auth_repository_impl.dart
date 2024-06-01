import 'package:spotify_downloader/core/consts/spotify_client.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';

import 'package:spotify_downloader/features/data_domain/auth/data/local_auth/data_source/local_auth_data_source.dart';
import 'package:spotify_downloader/features/data_domain/auth/data/local_auth/repository/converter/local_auth_credentials_to_auth_credentials_converter.dart';
import 'package:spotify_downloader/features/data_domain/auth/domain/local_auth/repositories/repositories.dart';
import 'package:spotify_downloader/features/data_domain/auth/domain/shared/shared.dart';

class LocalAuthRepositoryImpl implements LocalFullAuthRepository, LocalClientAuthRepository, LocalUserAuthRepository {
  LocalAuthRepositoryImpl({required LocalAuthDataSource dataSource}) : _dataSource = dataSource;

  final LocalAuthDataSource _dataSource;
  final LocalAuthCredentialsToAuthCredentialsConverter _converter = LocalAuthCredentialsToAuthCredentialsConverter();

  FullCredentials? _fullCredentials;

  @override
  Future<Result<Failure, void>> clearUserCredentials() async {
    final getFullCredentialsResult = await getFullCredentials();
    if (!getFullCredentialsResult.isSuccessful) {
      return Result.notSuccessful(getFullCredentialsResult.failure);
    }

    return saveFullCredentials(FullCredentials(
        clientId: getFullCredentialsResult.result!.clientId,
        clientSecret: getFullCredentialsResult.result!.clientSecret,
        accessToken: null,
        expiration: null,
        refreshToken: null));
  }

  @override
  Future<Result<Failure, void>> saveUserCredentials(UserCredentials userCredentials) async {
    final getFullCredentialsResult = await getFullCredentials();
    if (!getFullCredentialsResult.isSuccessful) {
      return Result.notSuccessful(getFullCredentialsResult.failure);
    }

    return saveFullCredentials(FullCredentials(
        clientId: getFullCredentialsResult.result!.clientId,
        clientSecret: getFullCredentialsResult.result!.clientSecret,
        accessToken: userCredentials.accessToken,
        expiration: userCredentials.expiration,
        refreshToken: userCredentials.refreshToken));
  }

  @override
  Future<Result<Failure, ClientCredentials>> getClientCredentials() => getFullCredentials();

  @override
  Future<Result<Failure, void>> saveClientCredentials(ClientCredentials clientCredentials) async {
    final getFullCredentialsResult = await getFullCredentials();
    if (!getFullCredentialsResult.isSuccessful) {
      return Result.notSuccessful(getFullCredentialsResult.failure);
    }

    return saveFullCredentials(FullCredentials(
        clientId: clientCredentials.clientId,
        clientSecret: clientCredentials.clientSecret,
        accessToken: getFullCredentialsResult.result!.accessToken,
        expiration: getFullCredentialsResult.result!.expiration,
        refreshToken: getFullCredentialsResult.result!.refreshToken));
  }

  @override
  Future<Result<Failure, FullCredentials>> getFullCredentials() async {
    if (_fullCredentials != null) {
      return Result.isSuccessful(_fullCredentials);
    }

    final localCredentials = await _dataSource.getLocalAuthCredentials();
    if (localCredentials != null) {
      final authCredentials = _converter.convert(localCredentials);

      _fullCredentials = authCredentials;
      return Result.isSuccessful(authCredentials);
    } else {
      return Result.isSuccessful(FullCredentials(
          clientId: deffaultClientId,
          clientSecret: deffaultClientSecret,
          refreshToken: null,
          accessToken: null,
          expiration: null));
    }
  }

  @override
  Future<Result<Failure, void>> saveFullCredentials(FullCredentials fullCredentials) async {
    _fullCredentials = fullCredentials;
    await _dataSource.saveLocalAuthCredentials(_converter.convertBack(fullCredentials));
    return const Result.isSuccessful(null);
  }
}

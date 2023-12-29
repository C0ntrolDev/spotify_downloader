import 'package:spotify_downloader/core/consts/spotify_client.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/auth/local_auth/data_source/local_auth_data_source.dart';
import 'package:spotify_downloader/features/data/auth/local_auth/repository/converter/local_auth_credentials_to_auth_credentials_converter.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/repository/local_auth_repository.dart';
import 'package:spotify_downloader/features/domain/auth/shared/authorized_client_credentials.dart';

class LocalAuthRepositoryImpl implements LocalAuthRepository {
  LocalAuthRepositoryImpl({required LocalAuthDataSource dataSource}) : _dataSource = dataSource;

  final LocalAuthDataSource _dataSource;
  final LocalAuthCredentialsToAuthCredentialsConverter _converter = LocalAuthCredentialsToAuthCredentialsConverter();

  AuthorizedClientCredentials? _authCredentials;

  @override
  Future<Result<Failure, AuthorizedClientCredentials>> getAuthCredentials() async {
    if (_authCredentials != null) {
      return Result.isSuccessful(_authCredentials);
    }

    final localCredentials = await _dataSource.getLocalAuthCredentials();
    if (localCredentials != null) {
      final authCredentials = _converter.convert(localCredentials);

      _authCredentials = authCredentials;
      return Result.isSuccessful(authCredentials);
    } else {
      return Result.isSuccessful(AuthorizedClientCredentials(
          clientId: deffaultClientId, clientSecret: deffaultClientSecret, refreshToken: null));
    }
  }

  @override
  Future<Result<Failure, void>> saveAuthCredentials(AuthorizedClientCredentials authCredentials) async {
    _authCredentials = authCredentials;
    await _dataSource.saveLocalAuthCredentials(_converter.convertBack(authCredentials));
    return const Result.isSuccessful(null);
  }
}

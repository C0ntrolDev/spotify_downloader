import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';

import 'package:spotify_downloader/features/data_domain/auth/data/network_auth/data_source/network_auth_data_source.dart';
import 'package:spotify_downloader/features/data_domain/auth/domain/network_auth/repository/network_auth_repository.dart';
import 'package:spotify_downloader/features/data_domain/auth/domain/shared/shared.dart';

class NetworkAuthRepositoryImpl implements NetworkAuthRepository {
  NetworkAuthRepositoryImpl({required NetworkAuthDataSource dataSource}) : _dataSource = dataSource;

  final NetworkAuthDataSource _dataSource;

  @override
  Future<Result<Failure, UserCredentials>> authorizeUser(ClientCredentials clientCredentials) async {
    final response = await _dataSource.authorizeUser(clientCredentials.clientId);

    if (response.isSuccessful) {
      return Result.isSuccessful(UserCredentials(
          refreshToken: response.result!.refreshToken,
          accessToken: response.result!.accessToken,
          expiration: response.result!.expiration));
    }
    
    return Result.notSuccessful(response.failure);
  }
}

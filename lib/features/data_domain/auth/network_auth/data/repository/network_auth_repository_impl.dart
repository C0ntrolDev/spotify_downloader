import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/auth/network_auth/network_auth.dart';
import 'package:spotify_downloader/features/data_domain/auth/shared/shared.dart';

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

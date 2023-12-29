import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/auth/network_auth/data_source/network_auth_data_source.dart';
import 'package:spotify_downloader/features/domain/auth/network_auth/repository/network_auth_repository.dart';
import 'package:spotify_downloader/features/domain/auth/shared/authorized_client_credentials.dart';
import 'package:spotify_downloader/features/domain/auth/shared/client_credentials.dart';

class NetworkAuthRepositoryImpl implements NetworkAuthRepository {
  NetworkAuthRepositoryImpl({required NetworkAuthDataSource dataSource}) : _dataSource = dataSource;

  final NetworkAuthDataSource _dataSource;

  @override
  Future<Result<Failure, AuthorizedClientCredentials>> authorizeUser(ClientCredentials clientCredentials) async {
    if (clientCredentials.clientId == null) {
      return Result.notSuccessful(AuthFailure(message: 'clientId is required'));
    }

    final response = await _dataSource.authorizeUser(clientCredentials.clientId!);

    if (response.isSuccessful) {
      return Result.isSuccessful(AuthorizedClientCredentials(
          clientId: clientCredentials.clientId,
          clientSecret: clientCredentials.clientSecret,
          refreshToken: response.result!.refreshToken));
    }
    
    return Result.notSuccessful(response.failure);
  }
}

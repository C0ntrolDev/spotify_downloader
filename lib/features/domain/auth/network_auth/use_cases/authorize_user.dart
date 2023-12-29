import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/auth/network_auth/repository/network_auth_repository.dart';
import 'package:spotify_downloader/features/domain/auth/shared/authorized_client_credentials.dart';
import 'package:spotify_downloader/features/domain/auth/shared/client_credentials.dart';

class AuthorizeUser implements UseCase<Failure, AuthorizedClientCredentials, ClientCredentials> {
  AuthorizeUser({required NetworkAuthRepository networkAuthRepository}) : _networkAuthRepository = networkAuthRepository;

  final NetworkAuthRepository _networkAuthRepository;

  @override
  Future<Result<Failure, AuthorizedClientCredentials>> call(ClientCredentials clientCredentials) {
    return _networkAuthRepository.authorizeUser(clientCredentials);
  }
}

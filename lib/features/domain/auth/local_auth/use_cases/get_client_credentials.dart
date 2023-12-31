import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/repositories/local_client_auth_repository.dart';
import 'package:spotify_downloader/features/domain/auth/shared/client_credentials.dart';

class GetClientCredentials implements UseCase<Failure, ClientCredentials, void> {
  GetClientCredentials({required LocalClientAuthRepository localClientAuthRepository})
      : _localClientAuthRepository = localClientAuthRepository;

  final LocalClientAuthRepository _localClientAuthRepository;

  @override
  Future<Result<Failure, ClientCredentials>> call(void params) {
    return _localClientAuthRepository.getClientCredentials();
  }
}

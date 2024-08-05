import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/auth/local_auth/local_auth.dart';
import 'package:spotify_downloader/features/data_domain/auth/shared/shared.dart';

class GetClientCredentials implements UseCase<Failure, ClientCredentials, void> {
  GetClientCredentials({required LocalClientAuthRepository localClientAuthRepository})
      : _localClientAuthRepository = localClientAuthRepository;

  final LocalClientAuthRepository _localClientAuthRepository;

  @override
  Future<Result<Failure, ClientCredentials>> call(void params) {
    return _localClientAuthRepository.getClientCredentials();
  }
}

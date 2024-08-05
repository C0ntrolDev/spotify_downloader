import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/auth/local_auth/local_auth.dart';
import 'package:spotify_downloader/features/data_domain/auth/shared/shared.dart';

class SaveClientCredentials implements UseCase<Failure, void, ClientCredentials> {
  SaveClientCredentials({required LocalClientAuthRepository localClientAuthRepository})
      : _localClientAuthRepository = localClientAuthRepository;

  final LocalClientAuthRepository _localClientAuthRepository;

  @override
  Future<Result<Failure, void>> call(ClientCredentials clientCredentials) {
    return _localClientAuthRepository.saveClientCredentials(clientCredentials);
  }
}

import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';

import 'package:spotify_downloader/features/data_domain/auth/domain/local_auth/repositories/local_client_auth_repository.dart';
import 'package:spotify_downloader/features/data_domain/auth/domain/shared/client_credentials.dart';


class SaveClientCredentials implements UseCase<Failure, void, ClientCredentials> {
  SaveClientCredentials({required LocalClientAuthRepository localClientAuthRepository})
      : _localClientAuthRepository = localClientAuthRepository;

  final LocalClientAuthRepository _localClientAuthRepository;

  @override
  Future<Result<Failure, void>> call(ClientCredentials clientCredentials) {
    return _localClientAuthRepository.saveClientCredentials(clientCredentials);
  }
}

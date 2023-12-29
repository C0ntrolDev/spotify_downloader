import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/repository/local_auth_repository.dart';
import 'package:spotify_downloader/features/domain/auth/shared/authorized_client_credentials.dart';

class GetLocalAuthCredentials implements UseCase<Failure, AuthorizedClientCredentials, void> {
  GetLocalAuthCredentials({required LocalAuthRepository localAuthRepository}) : _localAuthRepository = localAuthRepository;

  final LocalAuthRepository _localAuthRepository;

  @override
  Future<Result<Failure, AuthorizedClientCredentials>> call(void params) {
    return _localAuthRepository.getAuthCredentials();
  }
}

import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/repository/local_auth_repository.dart';
import 'package:spotify_downloader/features/domain/shared/client_credentials.dart';

class GetClientCredentials implements UseCase<Failure, ClientCredentials, void> {
  GetClientCredentials({required LocalAuthRepository localAuthRepository}) : _localAuthRepository = localAuthRepository;

  final LocalAuthRepository _localAuthRepository;

  @override
  Future<Result<Failure, ClientCredentials>> call(void params) {
    return _localAuthRepository.getAuthCredentials();
  }
}

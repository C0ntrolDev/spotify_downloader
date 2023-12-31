import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/repositories/local_user_auth_repository.dart';

class ClearUserCredentials implements UseCase<Failure, void, void> {
  ClearUserCredentials({required LocalUserAuthRepository localUserAuthRepository})
      : _localUserAuthRepository = localUserAuthRepository;

  final LocalUserAuthRepository _localUserAuthRepository;

  @override
  Future<Result<Failure, void>> call(void params) {
    return _localUserAuthRepository.clearUserCredentials();
  }
}

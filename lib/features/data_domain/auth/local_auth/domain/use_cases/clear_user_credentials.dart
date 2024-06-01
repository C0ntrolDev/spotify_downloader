import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/auth/local_auth/local_auth.dart';

class ClearUserCredentials implements UseCase<Failure, void, void> {
  ClearUserCredentials({required LocalUserAuthRepository localUserAuthRepository})
      : _localUserAuthRepository = localUserAuthRepository;

  final LocalUserAuthRepository _localUserAuthRepository;

  @override
  Future<Result<Failure, void>> call(void params) {
    return _localUserAuthRepository.clearUserCredentials();
  }
}

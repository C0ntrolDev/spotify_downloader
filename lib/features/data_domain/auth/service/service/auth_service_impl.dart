import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/features/data_domain/auth/auth.dart';

class AuthServiceImpl implements AuthService {
  AuthServiceImpl(
      {required LocalUserAuthRepository localUserAuthRepository,
      required LocalClientAuthRepository localClientAuthRepository,
      required NetworkAuthRepository networkAuthRepository})
      : _localUserAuthRepository = localUserAuthRepository,
        _localClientAuthRepository = localClientAuthRepository,
        _networkAuthRepository = networkAuthRepository;

  final LocalUserAuthRepository _localUserAuthRepository;
  final LocalClientAuthRepository _localClientAuthRepository;
  final NetworkAuthRepository _networkAuthRepository;

  @override
  Future<Result<Failure, void>> authorizeUser() async {
    final getClientCredentialsResult = await _localClientAuthRepository.getClientCredentials();
    if (!getClientCredentialsResult.isSuccessful) {
      return Result.notSuccessful(getClientCredentialsResult.failure);
    }

    final authorizeUserResult = await _networkAuthRepository.authorizeUser(getClientCredentialsResult.result!);
    if (!authorizeUserResult.isSuccessful) {
      return Result.notSuccessful(authorizeUserResult.failure);
    }

    return _localUserAuthRepository.saveUserCredentials(authorizeUserResult.result!);
  }
}

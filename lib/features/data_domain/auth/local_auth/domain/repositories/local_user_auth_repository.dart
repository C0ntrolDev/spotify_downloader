import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/features/data_domain/auth/shared/user_credentials.dart';

abstract class LocalUserAuthRepository {
  Future<Result<Failure, void>> clearUserCredentials();

  Future<Result<Failure, void>> saveUserCredentials(UserCredentials userCredentials);
}

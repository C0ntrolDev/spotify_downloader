import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';

import 'package:spotify_downloader/features/data_domain/auth/domain/shared/user_credentials.dart';

abstract class LocalUserAuthRepository {
  Future<Result<Failure, void>> clearUserCredentials();

  Future<Result<Failure, void>> saveUserCredentials(UserCredentials userCredentials);
}

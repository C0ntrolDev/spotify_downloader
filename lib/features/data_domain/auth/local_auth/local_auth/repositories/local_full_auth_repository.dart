import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';

import 'package:spotify_downloader/features/data_domain/auth/shared/full_credentials.dart';


abstract class LocalFullAuthRepository {
  Future<Result<Failure, FullCredentials>> getFullCredentials();

  Future<Result<Failure, void>> saveFullCredentials(FullCredentials fullCredentials);
}

import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';

import 'package:spotify_downloader/features/data_domain/auth/shared/shared.dart';

abstract class NetworkAuthRepository {
  Future<Result<Failure, UserCredentials>> authorizeUser(ClientCredentials clientCredentials);
}
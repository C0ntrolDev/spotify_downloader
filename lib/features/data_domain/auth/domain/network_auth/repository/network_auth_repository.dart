import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';

import 'package:spotify_downloader/features/data_domain/auth/domain/shared/shared.dart';

abstract class NetworkAuthRepository {
  Future<Result<Failure, UserCredentials>> authorizeUser(ClientCredentials clientCredentials);
}
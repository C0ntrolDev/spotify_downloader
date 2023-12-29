import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/auth/shared/authorized_client_credentials.dart';
import 'package:spotify_downloader/features/domain/auth/shared/client_credentials.dart';

abstract class NetworkAuthRepository {
  Future<Result<Failure, AuthorizedClientCredentials>> authorizeUser(ClientCredentials clientCredentials);
}
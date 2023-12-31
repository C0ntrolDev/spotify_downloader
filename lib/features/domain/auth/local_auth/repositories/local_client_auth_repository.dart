import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/auth/shared/client_credentials.dart';


abstract class LocalClientAuthRepository {
  Future<Result<Failure, ClientCredentials>> getClientCredentials();
  Future<Result<Failure, void>> saveClientCredentials(ClientCredentials clientCredentials);
}

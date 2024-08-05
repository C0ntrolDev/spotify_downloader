import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/features/data_domain/auth/shared/client_credentials.dart';

abstract class LocalClientAuthRepository {
  Future<Result<Failure, ClientCredentials>> getClientCredentials();
  Future<Result<Failure, void>> saveClientCredentials(ClientCredentials clientCredentials);
}

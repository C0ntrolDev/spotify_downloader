import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/shared/authorized_client_credentials.dart';
import 'package:spotify_downloader/features/domain/shared/client_credentials.dart';

abstract class LocalAuthRepository {
  Future<Result<Failure, AuthorizedClientCredentials>> getAuthCredentials();
  Future<Result<Failure, void>> saveAuthorizedCredentials(AuthorizedClientCredentials authCredentials);
  Future<Result<Failure, void>> saveClientCredentials(ClientCredentials clientCredentials);
  Future<Result<Failure, void>> deleteUserCredentials();
  Future<Result<Failure, void>> saveUserCredentials(AuthorizedClientCredentials authCredentials);

}

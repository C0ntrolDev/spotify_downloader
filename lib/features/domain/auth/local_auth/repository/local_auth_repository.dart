import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/auth/shared/authorized_client_credentials.dart';

abstract class LocalAuthRepository {
  Future<Result<Failure, AuthorizedClientCredentials>> getAuthCredentials();
  Future<Result<Failure, void>> saveAuthCredentials(AuthorizedClientCredentials authCredentials);
}
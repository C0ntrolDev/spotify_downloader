import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/auth/shared/full_credentials.dart';


abstract class LocalFullAuthRepository {
  Future<Result<Failure, FullCredentials>> getFullCredentials();

  Future<Result<Failure, void>> saveFullCredentials(FullCredentials fullCredentials);
}

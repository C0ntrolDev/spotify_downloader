import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';

abstract class AuthService {
    Future<Result<Failure, void>> authorizeUser();
}
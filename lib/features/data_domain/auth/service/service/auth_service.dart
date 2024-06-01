import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';

abstract class AuthService {
    Future<Result<Failure, void>> authorizeUser();
}
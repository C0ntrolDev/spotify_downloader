import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/auth/service/service/auth_service.dart';

class AuthorizeUser implements UseCase<Failure, void, void> {
  AuthorizeUser({required AuthService authService}) : _authService = authService;

  final AuthService _authService;

  @override
  Future<Result<Failure, void>> call(void params) {
    return _authService.authorizeUser();
  }
}
import 'package:spotify_downloader/core/utils/failures/failure.dart';

final class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'not found failure'});
}

final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'network failure'});
}

final class ConverterFailure extends Failure {
  const ConverterFailure({super.message = 'converter failure'});
}

final class AuthFailure extends Failure {
  AuthFailure({super.message = 'auth failure'});
}

final class InvalidClientCredentialsFailure extends Failure {
  InvalidClientCredentialsFailure({super.message = 'invalid auth credentials failure'});
}

final class InvalidAccountCredentialsFailure extends Failure {
  InvalidAccountCredentialsFailure({super.message = 'invalid refresh token failure'});
}

final class NotAuthorizedFailure extends Failure {
  NotAuthorizedFailure({super.message = 'User not authorized'});
}

final class ForbiddenFailure extends Failure {
  ForbiddenFailure({super.message = 'Access Forbidden'});
}
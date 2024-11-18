import 'package:spotify_downloader/core/utils/failures/failure.dart';

abstract class NoDetailedFailure extends Failure {
  const NoDetailedFailure({required super.message, super.stackTrace});

  @override
  String toString() {
    final type = runtimeType;
    return '$type: $message';
  }
}

final class NotFoundFailure extends NoDetailedFailure {
  const NotFoundFailure({super.message = 'not found failure', super.stackTrace});
}

final class NetworkFailure extends NoDetailedFailure {
  const NetworkFailure({super.message = 'network failure', super.stackTrace});
}

final class ConverterFailure extends NoDetailedFailure {
  const ConverterFailure({super.message = 'converter failure', super.stackTrace});
}

final class AuthFailure extends NoDetailedFailure {
  AuthFailure({super.message = 'auth failure', super.stackTrace});
}

final class AuthExitFailure extends NoDetailedFailure {
  AuthExitFailure({super.message = 'auth exit failure', super.stackTrace});
}


final class InvalidClientCredentialsFailure extends NoDetailedFailure {
  InvalidClientCredentialsFailure({super.message = 'invalid auth credentials failure', super.stackTrace});
}

final class InvalidAccountCredentialsFailure extends NoDetailedFailure {
  InvalidAccountCredentialsFailure({super.message = 'invalid refresh token failure', super.stackTrace});
}

final class NotAuthorizedFailure extends NoDetailedFailure {
  NotAuthorizedFailure({super.message = 'User not authorized', super.stackTrace});
}

final class ForbiddenFailure extends NoDetailedFailure {
  ForbiddenFailure({super.message = 'Access Forbidden', super.stackTrace});
}

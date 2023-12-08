import 'package:spotify_downloader/core/util/failures/failure.dart';

final class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'not found failure'});
}

final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'network failure'});
}

final class ConverterFailure extends Failure {
  const ConverterFailure({super.message = 'converter failure'});
}
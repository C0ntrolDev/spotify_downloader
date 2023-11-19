import 'package:spotify_downloader/core/util/failures/failure.dart';

class NotFoundFailure extends Failure {
  NotFoundFailure({super.message = 'not found failure'});
}

class NetworkFailure extends Failure {
  NetworkFailure({super.message = 'network failure'});
}
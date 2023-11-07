import 'package:spotify_downloader/core/util/call_response/call_response.dart';

abstract class UseCase<Failure, Type, Params> {
  Future<CallResponse<Failure, Type>> call(Params params);
}
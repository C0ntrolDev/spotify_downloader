import 'package:spotify_downloader/core/utils/result/result.dart';

abstract class UseCase<Failure, Type, Params> {
  Future<Result<Failure, Type>> call(Params params);
}
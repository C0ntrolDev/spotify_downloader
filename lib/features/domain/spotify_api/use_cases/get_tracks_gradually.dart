import 'dart:ffi';

import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/spotify_api/enitites/use_cases_args/get_tracks_gradually_args.dart';

class GetTracksGradually implements UseCase<Failure, Void, GetTracksGraduallyArgs> {
  @override
  Future<Result<Failure, Void>> call(GetTracksGraduallyArgs args) {
    throw UnimplementedError();
  }

}
import 'dart:ffi';

import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/spotify_api/enitites/use_cases_args/get_tracks_gradually_args.dart';

abstract class TracksRepository {
  Future<Result<Failure,Void>> getTracksGradually(GetTracksGraduallyArgs args);
}
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';

abstract class TracksRepository {
  Result<Failure, void> getTracksByTracksCollection();
  Result<Failure, void> saveTrack();
}
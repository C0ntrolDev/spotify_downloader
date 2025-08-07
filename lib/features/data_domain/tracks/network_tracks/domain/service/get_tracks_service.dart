import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/ids/ids.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/network_tracks.dart';

abstract class GetTracksService {
  Future<Result<Failure, TracksGettingObserver>> getTracksFromTracksCollection(
      {required TracksCollectionId id, required int offset});
}
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/ids/ids.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/network_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/domain/service/get_tracks_service.dart';

class GetTracksFromTracksCollection
    implements UseCase<Failure, TracksGettingObserver, TracksCollectionId> {
  GetTracksFromTracksCollection({required GetTracksService getTracksService})
      : _getTracksService = getTracksService;

  final GetTracksService _getTracksService;

  @override
  Future<Result<Failure, TracksGettingObserver>> call(TracksCollectionId id) async {
        return _getTracksService.getTracksFromTracksCollection(
        id: id, offset: 0);
  }
}

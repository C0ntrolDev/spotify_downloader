import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/ids/tracks_collection_id.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/network_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/domain/service/get_tracks_service.dart';

class GetTracksFromTracksCollectionWithOffset
    implements
        UseCase<Failure, TracksGettingObserver,
            (TracksCollectionId, int)> {
  GetTracksFromTracksCollectionWithOffset({required GetTracksService getTracksService})
      : _getTracksService = getTracksService;

  final GetTracksService _getTracksService;

  @override
  Future<Result<Failure, TracksGettingObserver>> call(
      (TracksCollectionId, int) params) async {
    return  _getTracksService.getTracksFromTracksCollection(
        id: params.$1, offset: params.$2);
  }
}

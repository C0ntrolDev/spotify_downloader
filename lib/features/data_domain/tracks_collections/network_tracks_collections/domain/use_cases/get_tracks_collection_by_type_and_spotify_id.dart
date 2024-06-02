import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/network_tracks_collections/domain/service/service.dart';

class GetTracksCollectionByTypeAndSpotifyId
    implements UseCase<Failure, TracksCollection, (TracksCollectionType, String)> {
  GetTracksCollectionByTypeAndSpotifyId({required NetworkTracksCollectionsService service})
      : _service = service;

  final NetworkTracksCollectionsService _service;

  @override
  Future<Result<Failure, TracksCollection>> call((TracksCollectionType, String) args) {
    return _service.getTracksCollectionByTypeAndSpotifyId(args.$1, args.$2);
  }
}

import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/ids/ids.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/network_tracks_collections/domain/enitites/tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/network_tracks_collections/domain/service/service.dart';

class GetTracksCollectionById
    implements UseCase<Failure, TracksCollection, TracksCollectionId> {
  GetTracksCollectionById({required NetworkTracksCollectionsService service})
      : _service = service;

  final NetworkTracksCollectionsService _service;

  @override
  Future<Result<Failure, TracksCollection>> call(TracksCollectionId id) {
    return _service.getTracksCollectionById(id);
  }
}

import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/network_tracks_collections/domain/service/service.dart';

class GetTracksCollectionByUrl implements UseCase<Failure, TracksCollection, String> {
  GetTracksCollectionByUrl({required NetworkTracksCollectionsService service}) : _service = service;

  final NetworkTracksCollectionsService _service;

  @override
  Future<Result<Failure, TracksCollection>> call(String url) async {
    return _service.getTracksCollectionByUrl(url);
  }
}

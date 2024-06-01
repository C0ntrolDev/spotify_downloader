import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/network_tracks_collections/service/network_tracks_collections_service.dart';
class GetTracksCollectionByUrl implements UseCase<Failure, TracksCollection, String> {
  GetTracksCollectionByUrl({required NetworkTracksCollectionsService service}) : _service = service;

  final NetworkTracksCollectionsService _service;

  @override
  Future<Result<Failure, TracksCollection>> call(String url) async {
    return _service.getTracksCollectionByUrl(url);
  }
}

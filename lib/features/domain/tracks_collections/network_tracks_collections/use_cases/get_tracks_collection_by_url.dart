import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/network_tracks_collections/repositories/network_tracks_collections_repository.dart';

class GetTracksCollectionByUrl implements UseCase<Failure, TracksCollection, String> {
  GetTracksCollectionByUrl({required NetworkTracksCollectionsRepository repository}) : _repository = repository;

  final NetworkTracksCollectionsRepository _repository;

  @override
  Future<Result<Failure, TracksCollection>> call(String url) async {
    return _repository.getTracksCollectionByUrl(url);
  }
}

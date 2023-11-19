import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/spotify_api/enitites/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/spotify_api/repositories/tracks_collections_repository.dart';

class GetTracksCollectionByUrl implements UseCase<Failure, TracksCollection, String> {

  final TracksCollectionsRepository _repository;

  GetTracksCollectionByUrl({required TracksCollectionsRepository repository}) : _repository = repository;

  @override
  Future<Result<Failure, TracksCollection>> call(String url) async {
    return _repository.getTracksCollectionByUrl(url);
  }

}
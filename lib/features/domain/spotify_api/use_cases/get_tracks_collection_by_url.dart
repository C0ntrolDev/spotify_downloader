import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/spotify_api/enitites/tracks_collection.dart';

class GetTracksCollectionByUrl implements UseCase<Failure, TracksCollection, String> {

  @override
  Future<Result<Failure, TracksCollection>> call(String url) {
    throw UnimplementedError();
  }

}
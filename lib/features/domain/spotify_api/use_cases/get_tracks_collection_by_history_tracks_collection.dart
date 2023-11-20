import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection_type.dart';
import 'package:spotify_downloader/features/domain/spotify_api/enitites/tracks_collection.dart';

class GetTracksCollectionByTypeAndSpotifyId implements UseCase<Failure, TracksCollection, (TracksCollectionType, String)> {
  
  @override
  Future<Result<Failure, TracksCollection>> call((TracksCollectionType, String) args) {
    throw UnimplementedError();
  }

}
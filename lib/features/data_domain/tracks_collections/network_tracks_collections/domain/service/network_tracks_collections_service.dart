import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/ids/ids.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/network_tracks_collections/domain/enitites/tracks_collection.dart';

abstract class NetworkTracksCollectionsService {
  Future<Result<Failure, TracksCollection>> getTracksCollectionById(
      TracksCollectionId id);
  Future<Result<Failure, TracksCollection>> getTracksCollectionByUrl(String url);
}

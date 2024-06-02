import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';

abstract class NetworkTracksCollectionsService {
  Future<Result<Failure, TracksCollection>> getTracksCollectionByTypeAndSpotifyId(
      TracksCollectionType type, String spotifyId);
  Future<Result<Failure, TracksCollection>> getTracksCollectionByUrl(String url);
}

import 'package:spotify_downloader/features/data_domain/shared/domain/ids/ids.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/spotify_repository_request.dart';

class GetTracksFromTracksCollectionArgs {
  GetTracksFromTracksCollectionArgs(
      {required this.spotifyRepositoryRequest, required this.tracksCollectionId, this.offset = 0});

  final SpotifyRepositoryRequest spotifyRepositoryRequest;
  final TracksCollectionId tracksCollectionId;
  final int offset;
}

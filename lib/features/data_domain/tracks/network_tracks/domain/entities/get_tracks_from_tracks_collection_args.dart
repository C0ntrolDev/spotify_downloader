import 'package:spotify_downloader/features/data_domain/shared/domain/spotify_repository_request.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/tracks_collection.dart';

class GetTracksFromTracksCollectionArgs {
  GetTracksFromTracksCollectionArgs(
      {required this.spotifyRepositoryRequest, required this.tracksCollection, this.offset = 0});

  final SpotifyRepositoryRequest spotifyRepositoryRequest;
  final TracksCollection tracksCollection;
  final int offset;
}

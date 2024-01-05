import 'package:spotify_downloader/features/domain/shared/spotify_repository_request.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection.dart';

class GetTracksFromTracksCollectionArgs {
  GetTracksFromTracksCollectionArgs(
      {required this.spotifyRepositoryRequest, required this.tracksCollection, this.offset = 0});

  final SpotifyRepositoryRequest spotifyRepositoryRequest;
  final TracksCollection tracksCollection;
  final int offset;
}

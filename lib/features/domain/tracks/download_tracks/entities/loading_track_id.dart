import 'package:quiver/core.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection_type.dart';

class LoadingTrackId {
  LoadingTrackId({required this.parentSpotifyId, required this.parentType, required this.spotifyId});

  final String parentSpotifyId;
  final TracksCollectionType parentType;
  final String spotifyId;

  @override
  bool operator ==(Object other) {
    return other is LoadingTrackId &&
        parentSpotifyId == other.parentSpotifyId &&
        parentType == other.parentType &&
        spotifyId == other.spotifyId;
  }

  @override
  int get hashCode => hash3(parentSpotifyId, parentType, spotifyId);
}

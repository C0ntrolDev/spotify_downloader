import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_tracks_collection_type.dart';

class LocalTracksCollection {
  LocalTracksCollection({required this.spotifyId, required this.type});

  final String spotifyId;
  final LocalTracksCollectionType type;
}

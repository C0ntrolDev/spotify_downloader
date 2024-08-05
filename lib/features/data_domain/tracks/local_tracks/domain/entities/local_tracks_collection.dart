import 'package:spotify_downloader/features/data_domain/tracks/local_tracks/domain/entities/entities.dart';

class LocalTracksCollection {
  LocalTracksCollection({required this.group, required this.spotifyId, required this.type});

  final String spotifyId;
  final LocalTracksCollectionType type;
  final LocalTracksCollectionsGroup group;

  static LocalTracksCollection getAllTracksCollection(String directoryPath) {
    return LocalTracksCollection(
      group: LocalTracksCollectionsGroup(directoryPath: directoryPath), 
      spotifyId: 'allTracksCollection', 
      type: LocalTracksCollectionType.allTracks);
  }
}

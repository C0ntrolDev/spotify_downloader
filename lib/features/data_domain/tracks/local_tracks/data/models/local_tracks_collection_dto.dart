import 'package:spotify_downloader/features/data_domain/tracks/local_tracks/data/models/models.dart';

class LocalTracksCollectionDto {
  LocalTracksCollectionDto({required this.group, required this.spotifyId, required this.type});

  final String spotifyId;
  final LocalTracksCollectionDtoType type;
  final LocalTracksCollectionsGroupDto group;
}

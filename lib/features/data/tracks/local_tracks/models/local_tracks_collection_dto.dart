import 'package:spotify_downloader/features/data/tracks/local_tracks/models/local_tracks_collection_dto_type.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/models/local_tracks_collections_group_dto.dart';

class LocalTracksCollectionDto {
  LocalTracksCollectionDto({required this.group, required this.spotifyId, required this.type});

  final String spotifyId;
  final LocalTracksCollectionDtoType type;
  final LocalTracksCollectionsGroupDto group;
}

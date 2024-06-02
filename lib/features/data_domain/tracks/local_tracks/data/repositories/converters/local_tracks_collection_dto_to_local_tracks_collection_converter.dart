import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/local_tracks/local_tracks.dart';

class LocalTracksCollectionDtoToLocalTracksCollectionConverter
    implements ValueConverter<LocalTracksCollection, LocalTracksCollectionDto> {
  final LocalTracksCollectionDtoTypeToLocalTracksCollectionTypeConverter _collectionTypeConverter =
      LocalTracksCollectionDtoTypeToLocalTracksCollectionTypeConverter();
  final LocalTracksCollectionsGroupDtoToLocalTracksCollectionsGroupConverter _groupsConverter =
      LocalTracksCollectionsGroupDtoToLocalTracksCollectionsGroupConverter();

  @override
  LocalTracksCollection convert(LocalTracksCollectionDto dto) {
    return LocalTracksCollection(
        spotifyId: dto.spotifyId,
        type: _collectionTypeConverter.convert(dto.type),
        group: _groupsConverter.convert(dto.group));
  }

  @override
  LocalTracksCollectionDto convertBack(LocalTracksCollection entity) {
    return LocalTracksCollectionDto(
        spotifyId: entity.spotifyId,
        type: _collectionTypeConverter.convertBack(entity.type),
        group: _groupsConverter.convertBack(entity.group));
  }
}

import 'package:spotify_downloader/core/util/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/models/local_tracks_collection_dto.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/repositories/converters/local_tracks_collection_dto_type_to_local_tracks_collection_type_converter.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_tracks_collection.dart';

class LocalTracksCollectionDtoToLocalTracksCollectionConverter
    implements ValueConverter<LocalTracksCollection, LocalTracksCollectionDto> {
  final LocalTracksCollectionDtoTypeToLocalTracksCollectionTypeConverter _collectionTypeConverter =
      LocalTracksCollectionDtoTypeToLocalTracksCollectionTypeConverter();

  @override
  LocalTracksCollection convert(LocalTracksCollectionDto dto) {
    return LocalTracksCollection(spotifyId: dto.spotifyId, type: _collectionTypeConverter.convert(dto.type));
  }

  @override
  LocalTracksCollectionDto convertBack(LocalTracksCollection entity) {
    return LocalTracksCollectionDto(
        spotifyId: entity.spotifyId, type: _collectionTypeConverter.convertBack(entity.type));
  }
}

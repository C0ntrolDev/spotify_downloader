import 'package:spotify_downloader/core/util/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/models/local_tracks_collection_dto_type.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_tracks_collection_type.dart';

class LocalTracksCollectionDtoTypeToLocalTracksCollectionTypeConverter
    implements ValueConverter<LocalTracksCollectionType, LocalTracksCollectionDtoType> {
  @override
  LocalTracksCollectionType convert(LocalTracksCollectionDtoType dto) {
    switch (dto) {
      case LocalTracksCollectionDtoType.likedTracks:
        return LocalTracksCollectionType.likedTracks;
      case LocalTracksCollectionDtoType.playlist:
        return LocalTracksCollectionType.playlist;
      case LocalTracksCollectionDtoType.album:
        return LocalTracksCollectionType.album;
      case LocalTracksCollectionDtoType.track:
        return LocalTracksCollectionType.track;
    }
  }

  @override
  LocalTracksCollectionDtoType convertBack(LocalTracksCollectionType entity) {
    switch (entity) {
      case LocalTracksCollectionType.likedTracks:
        return LocalTracksCollectionDtoType.likedTracks;
      case LocalTracksCollectionType.playlist:
        return LocalTracksCollectionDtoType.playlist;
      case LocalTracksCollectionType.album:
        return LocalTracksCollectionDtoType.album;
      case LocalTracksCollectionType.track:
        return LocalTracksCollectionDtoType.track;
    }
  }
}

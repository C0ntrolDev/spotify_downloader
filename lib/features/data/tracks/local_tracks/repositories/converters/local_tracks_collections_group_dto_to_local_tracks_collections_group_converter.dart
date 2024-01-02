import 'package:spotify_downloader/core/util/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/models/local_tracks_collections_group_dto.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_tracks_collection_group.dart';

class LocalTracksCollectionsGroupDtoToLocalTracksCollectionsGroupConverter implements ValueConverter<LocalTracksCollectionsGroup, LocalTracksCollectionsGroupDto> {
  @override
  LocalTracksCollectionsGroup convert(LocalTracksCollectionsGroupDto value) {
    return LocalTracksCollectionsGroup(directoryPath: value.directoryPath);
  }

  @override
  LocalTracksCollectionsGroupDto convertBack(LocalTracksCollectionsGroup value) {
    return LocalTracksCollectionsGroupDto(directoryPath: value.directoryPath);
  }
}

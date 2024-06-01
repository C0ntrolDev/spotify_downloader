import 'package:spotify_downloader/core/utils/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/local_tracks/models/local_tracks_collections_group_dto.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/local_tracks/entities/local_tracks_collection_group.dart';

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

import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/local_tracks/local_tracks.dart';

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

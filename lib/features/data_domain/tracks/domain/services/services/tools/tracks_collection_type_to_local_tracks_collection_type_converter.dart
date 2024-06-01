import 'package:spotify_downloader/core/utils/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/local_tracks/entities/local_tracks_collection_type.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/tracks_collection_type.dart';

class TracksCollectionTypeToLocalTracksCollectionTypeConverter
    implements ValueConverter<LocalTracksCollectionType, TracksCollectionType> {
  @override
  LocalTracksCollectionType convert(TracksCollectionType tracksCollectionType) {
    switch (tracksCollectionType) {
      case TracksCollectionType.likedTracks:
        return LocalTracksCollectionType.likedTracks;
      case TracksCollectionType.playlist:
        return LocalTracksCollectionType.playlist;
      case TracksCollectionType.album:
        return LocalTracksCollectionType.album;
      case TracksCollectionType.track:
        return LocalTracksCollectionType.track;
    }
  }

  @override
  TracksCollectionType convertBack(LocalTracksCollectionType value) {
    throw UnimplementedError();
  }
}

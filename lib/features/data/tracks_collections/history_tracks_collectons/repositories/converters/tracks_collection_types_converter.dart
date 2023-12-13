import 'package:spotify_downloader/core/util/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/data/tracks_collections/history_tracks_collectons/models/history_tracks_collection_dto.dart';
import '../../../../../domain/tracks/shared/entities/tracks_collection_type.dart';

class TracksCollectionTypesConverter implements ValueConverter<HistoryTracksCollectionType, TracksCollectionType> {
  @override
  HistoryTracksCollectionType convert(TracksCollectionType value) {
    switch (value) {
      case TracksCollectionType.album:
        return HistoryTracksCollectionType.album;
      case TracksCollectionType.likedTracks:
        return HistoryTracksCollectionType.likedTracks;
      case TracksCollectionType.playlist:
        return HistoryTracksCollectionType.playlist;
      case TracksCollectionType.track:
        return HistoryTracksCollectionType.album;
    }
  }

  @override
  TracksCollectionType convertBack(HistoryTracksCollectionType value) {
    switch (value) {
      case HistoryTracksCollectionType.album:
        return TracksCollectionType.album;
      case HistoryTracksCollectionType.likedTracks:
        return TracksCollectionType.likedTracks;
      case HistoryTracksCollectionType.playlist:
        return TracksCollectionType.playlist;
      case HistoryTracksCollectionType.track:
        return TracksCollectionType.track;
    }
  }
}

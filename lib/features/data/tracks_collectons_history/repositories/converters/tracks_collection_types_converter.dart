import 'package:spotify_downloader/core/util/converter/value_converter.dart';
import 'package:spotify_downloader/features/data/tracks_collectons_history/models/history_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/entities/tracks_collection.dart';

class TracksCollectionTypesConverter implements ValueConverter<TracksCollectionType, HistoryTracksCollectionType> {
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

import 'package:spotify_downloader/core/utils/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/ids/ids.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/history_tracks_collections/history_tracks_collections.dart';

class HistoryTracksCollectionsConverter
    implements ValueConverter<HistoryTracksCollectionDTO, HistoryTracksCollection> {
  final TracksCollectionTypesConverter tracksCollectionTypesConverter = TracksCollectionTypesConverter();

  @override
  HistoryTracksCollectionDTO convert(HistoryTracksCollection tracksCollection) {
    return HistoryTracksCollectionDTO(
        spotifyId: tracksCollection.id.spotifyId,
        type: tracksCollectionTypesConverter.convert(tracksCollection.id.type),
        name: tracksCollection.name,
        openDate: tracksCollection.openDate ?? DateTime.now(),
        imageUrl: tracksCollection.imageUrl);
  }

  @override
  HistoryTracksCollection convertBack(HistoryTracksCollectionDTO historyTracksCollection) {
    return HistoryTracksCollection(
        id: TracksCollectionId(
            spotifyId: historyTracksCollection.spotifyId,
            type: tracksCollectionTypesConverter.convertBack(historyTracksCollection.type)),
        name: historyTracksCollection.name,
        openDate: historyTracksCollection.openDate,
        imageUrl: historyTracksCollection.imageUrl);
  }
}

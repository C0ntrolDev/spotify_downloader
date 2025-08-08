import 'package:spotify_downloader/core/utils/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/history_tracks_collections/history_tracks_collections.dart';

class HistoryTracksCollectionsConverter implements ValueConverter<HistoryTracksCollectionDTO, HistoryTracksCollection> {

  final TracksCollectionTypesConverter tracksCollectionTypesConverter = TracksCollectionTypesConverter();

  @override
  HistoryTracksCollectionDTO convert(HistoryTracksCollection tracksCollection) {

    return HistoryTracksCollectionDTO(
        spotifyId: tracksCollection.spotifyId,
        type: tracksCollectionTypesConverter.convert(tracksCollection.type),
        name: tracksCollection.name,
        openDate: tracksCollection.openDate ?? DateTime.now(),
        imageUrl: tracksCollection.imageUrl);
  }


  @override
  HistoryTracksCollection convertBack(HistoryTracksCollectionDTO historyTracksCollection) {
   return HistoryTracksCollection(
        spotifyId: historyTracksCollection.spotifyId,
        type: tracksCollectionTypesConverter.convertBack(historyTracksCollection.type),
        name: historyTracksCollection.name,
        openDate: historyTracksCollection.openDate,
        imageUrl: historyTracksCollection.imageUrl);
  }

}
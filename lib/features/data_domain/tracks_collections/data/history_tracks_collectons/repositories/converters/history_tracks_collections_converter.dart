import 'package:spotify_downloader/core/util/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/data/history_tracks_collectons/models/history_tracks_collection_dto.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/data/history_tracks_collectons/repositories/converters/tracks_collection_types_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/history_tracks_collectons/entities/history_tracks_collection.dart';

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
import 'dart:typed_data';
import 'package:spotify_downloader/core/util/converter/async_value_converter.dart';
import 'package:spotify_downloader/features/data/tracks_collectons_history/models/history_tracks_collection.dart';
import 'package:spotify_downloader/features/data/tracks_collectons_history/repositories/converters/tracks_collection_types_converter.dart';
import 'package:spotify_downloader/features/domain/entities/tracks_collection.dart';
import 'package:http/http.dart' as http;

class TracksCollectionsConverter implements AsyncValueConverter<TracksCollection, HistoryTracksCollection> {

  final TracksCollectionTypesConverter tracksCollectionTypesConverter = TracksCollectionTypesConverter();

  @override
  Future<HistoryTracksCollection> convert(TracksCollection tracksCollection) async {
   Uint8List? image;

    if (tracksCollection.image != null) {
      image = tracksCollection.image;
    }

    if (tracksCollection.imageUrl != null) {
      final response = await http.get(Uri.parse(tracksCollection.imageUrl!));

      if (response.statusCode == 200) {
        image = response.bodyBytes;
      }
    }

    return HistoryTracksCollection(
        spotifyId: tracksCollection.spotifyId,
        type: tracksCollectionTypesConverter.convert(tracksCollection.type),
        name: tracksCollection.name,
        openDate: tracksCollection.openDate ?? DateTime.now(),
        image: image);
  }


  @override
  Future<TracksCollection> convertBack(HistoryTracksCollection historyTracksCollection) async {
   return TracksCollection.withLocalImage(
        spotifyId: historyTracksCollection.spotifyId,
        type: tracksCollectionTypesConverter.convertBack(historyTracksCollection.type),
        name: historyTracksCollection.name,
        openDate: historyTracksCollection.openDate,
        image: historyTracksCollection.image);
  }

}
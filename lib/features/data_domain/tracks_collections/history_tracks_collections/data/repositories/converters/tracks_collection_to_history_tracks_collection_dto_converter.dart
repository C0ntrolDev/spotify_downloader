import 'package:spotify_downloader/core/utils/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/history_tracks_collections/history_tracks_collections.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/tracks_collection.dart';

class TracksCollectionToHistoryTracksCollectionDtoConverter
    implements ValueConverter<HistoryTracksCollectionDTO, TracksCollection> {
  final TracksCollectionTypesConverter _tracksCollectionTypesConverter = TracksCollectionTypesConverter();

  @override
  HistoryTracksCollectionDTO convert(TracksCollection tracksCollection) {
    return HistoryTracksCollectionDTO(
        spotifyId: tracksCollection.spotifyId,
        name: tracksCollection.name,
        type: _tracksCollectionTypesConverter.convert(tracksCollection.type),
        imageUrl: tracksCollection.bigImageUrl,
        openDate: DateTime.now());
  }

  @override
  TracksCollection convertBack(HistoryTracksCollectionDTO value) {
    throw UnimplementedError();
  }
}

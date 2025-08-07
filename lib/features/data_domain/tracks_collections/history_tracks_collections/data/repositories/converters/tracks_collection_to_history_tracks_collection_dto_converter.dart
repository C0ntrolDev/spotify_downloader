import 'package:spotify_downloader/core/utils/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/history_tracks_collections/history_tracks_collections.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/shared/domain/entities/base_tracks_collection.dart';

class BaseTracksCollectionToHistoryTracksCollectionDtoConverter
    implements ValueConverter<HistoryTracksCollectionDTO, BaseTracksCollection> {
  final TracksCollectionTypesConverter _tracksCollectionTypesConverter = TracksCollectionTypesConverter();

  @override
  HistoryTracksCollectionDTO convert(BaseTracksCollection tracksCollection) {
    return HistoryTracksCollectionDTO(
        spotifyId: tracksCollection.id.spotifyId,
        name: tracksCollection.name,
        type: _tracksCollectionTypesConverter.convert(tracksCollection.id.type),
        imageUrl: tracksCollection.imageUrl,
        openDate: DateTime.now());
  }

  @override
  BaseTracksCollection convertBack(HistoryTracksCollectionDTO value) {
    throw UnimplementedError();
  }
}

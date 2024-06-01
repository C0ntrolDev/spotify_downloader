import 'package:spotify_downloader/core/utils/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/local_tracks/models/local_track_dto.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/local_tracks/repositories/converters/local_tracks_collection_dto_to_local_tracks_collection_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/local_tracks/entities/local_track.dart';

class LocalTrackDtoToLocalTrackConverter implements ValueConverter<LocalTrack, LocalTrackDto> {
  final LocalTracksCollectionDtoToLocalTracksCollectionConverter _collectionsConverter =
      LocalTracksCollectionDtoToLocalTracksCollectionConverter();

  @override
  LocalTrack convert(LocalTrackDto dto) {
    return LocalTrack(
        spotifyId: dto.spotifyId,
        savePath: dto.savePath,
        tracksCollection: _collectionsConverter.convert(dto.tracksCollection),
        youtubeUrl: dto.youtubeUrl);
  }

  @override
  LocalTrackDto convertBack(LocalTrack entity) {
    return LocalTrackDto(
        spotifyId: entity.spotifyId,
        savePath: entity.savePath,
        tracksCollection: _collectionsConverter.convertBack(entity.tracksCollection),
        youtubeUrl: entity.youtubeUrl);
  }
}

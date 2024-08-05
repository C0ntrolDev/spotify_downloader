import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/local_tracks/local_tracks.dart';


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

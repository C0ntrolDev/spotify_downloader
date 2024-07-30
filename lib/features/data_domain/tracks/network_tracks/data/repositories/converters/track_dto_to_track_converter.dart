import 'package:spotify/spotify.dart' as dto;
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/entities.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/track.dart' as entity;

class TrackDtoToTrackConverter implements ConverterWithParameter<entity.Track?, dto.Track, TracksCollection> {
  @override
  entity.Track? convert((dto.Track, TracksCollection) parameters) {
    final dtoTrack = parameters.$1;
    final parentCollection = parameters.$2;
    
    if (dtoTrack.id == null) {
      return null;
    }

    String? albumImageUrl;

    try {
      albumImageUrl = dtoTrack.album?.images?[1].url;
    } on RangeError {
      //rangeError
    }

    albumImageUrl ??= dtoTrack.album?.images?.firstOrNull?.url ?? '';

    return entity.Track(
        spotifyId: dtoTrack.id!, 
        duration: dtoTrack.duration,
        name: dtoTrack.name ?? 'no_name', 
        parentCollection: parentCollection,
        artists: dtoTrack.artists?.map((a) => a.name!).toList(),
        album: Album(name: dtoTrack.album?.name, imageUrl: albumImageUrl));
  }

  @override
  dto.Track convertBack((entity.Track?, TracksCollection) value) {
    throw UnimplementedError();
  }
}

import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/ids/ids.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/network_tracks_collections/domain/enitites/tracks_collection.dart';

class AlbumDtoToTracksCollectionConverter implements ResultValueConverter<TracksCollection, Album> {
  @override
  Result<ConverterFailure, TracksCollection> convert(Album album) {
    try {
      return Result.isSuccessful(TracksCollection(
          id: TracksCollectionId(spotifyId: album.id!, type: TracksCollectionType.album),
          tracksCount: album.tracks!.length,
          name: album.name!,
          artists: album.artists?.map((a) => a.name ?? '').where((a) => a.isNotEmpty).toList(),
          smallImageUrl: album.images?.last.url,
          imageUrl: album.images?.first.url));
    } catch (e, s) {
      return Result.notSuccessful(ConverterFailure(stackTrace: s));
    }
  }

  @override
  Result<ConverterFailure, Album> convertBack(TracksCollection value) {
    throw UnimplementedError();
  }
}

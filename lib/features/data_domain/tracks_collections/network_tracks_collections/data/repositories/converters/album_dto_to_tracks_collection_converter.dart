import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/tracks_collection_type.dart';


class AlbumDtoToTracksCollectionConverter implements ResultValueConverter<TracksCollection, Album> {
  @override
  Result<ConverterFailure, TracksCollection> convert(Album album) {
    try {
      return Result.isSuccessful(TracksCollection(
        spotifyId: album.id!,
        type: TracksCollectionType.album,
        tracksCount: album.tracks!.length,
        name: album.name!,
        artists: album.artists?.map((a) => a.name ?? '').where((a) => a.isNotEmpty).toList(),
        smallImageUrl: album.images?.last.url,
        bigImageUrl: album.images?.first.url));
    } catch (e) {
      return const Result.notSuccessful(ConverterFailure());
    }
  }

  @override
  Result<ConverterFailure, Album> convertBack(TracksCollection value) {
    throw UnimplementedError();
  }
}
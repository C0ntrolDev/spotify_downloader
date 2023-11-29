import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/util/converters/result_converters/result_value_converter.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection_type.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection.dart';

class PlaylistDtoToTracksCollectionConverter implements ResultValueConverter<TracksCollection, Playlist> {
  @override
  Result<ConverterFailure, TracksCollection> convert(Playlist playlist) {
    try {
      return Result.isSuccessful(TracksCollection(
        spotifyId: playlist.id!,
        type: TracksCollectionType.playlist,
        artists: List<String>.filled(1, playlist.owner?.displayName ?? ''),
        name: playlist.name!,
        smallImageUrl: playlist.images?.last.url,
        bigImageUrl: playlist.images?.first.url));
    } catch (e) {
      return Result.notSuccessful(ConverterFailure());
    }
  }

  @override
  Result<ConverterFailure, Playlist> convertBack(TracksCollection value) {
    throw UnimplementedError();
  }
}

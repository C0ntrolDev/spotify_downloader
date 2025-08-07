import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/ids/ids.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/network_tracks_collections/domain/enitites/tracks_collection.dart';

class PlaylistDtoToTracksCollectionConverter implements ResultValueConverter<TracksCollection, Playlist> {
  @override
  Result<ConverterFailure, TracksCollection> convert(Playlist playlist) {
    try {
      return Result.isSuccessful(TracksCollection(
          id: TracksCollectionId(spotifyId: playlist.id!, type: TracksCollectionType.playlist),
          tracksCount: playlist.tracks!.total,
          artists: List<String>.filled(1, playlist.owner?.displayName ?? ''),
          name: playlist.name!,
          smallImageUrl: playlist.images?.last.url,
          imageUrl: playlist.images?.first.url));
    } catch (e, s) {
      return Result.notSuccessful(ConverterFailure(stackTrace: s));
    }
  }

  @override
  Result<ConverterFailure, Playlist> convertBack(TracksCollection value) {
    throw UnimplementedError();
  }
}

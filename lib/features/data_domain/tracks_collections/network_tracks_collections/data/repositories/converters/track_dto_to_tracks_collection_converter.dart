import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/tracks_collection_type.dart';


class TrackDtoToTracksCollectionConverter implements ResultValueConverter<TracksCollection, Track> {
  @override
  Result<ConverterFailure, TracksCollection> convert(Track track) {
    try {
      return Result.isSuccessful(TracksCollection(
        spotifyId: track.id!,
        type: TracksCollectionType.track,
        name: track.name!,
        tracksCount: 1,
        artists: track.artists?.map((a) => a.name ?? '').where((an) => an.isNotEmpty).toList(),
        smallImageUrl: track.album?.images?.last.url,
        bigImageUrl: track.album?.images?.first.url));
    } catch (e, s) {
      return Result.notSuccessful(ConverterFailure(stackTrace: s));
    }
  }

  @override
  Result<ConverterFailure, Track> convertBack(TracksCollection value) {
    throw UnimplementedError();
  }

}
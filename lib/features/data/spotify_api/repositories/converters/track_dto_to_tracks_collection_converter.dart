import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/util/converters/result_converters/result_value_converter.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection_type.dart';
import 'package:spotify_downloader/features/domain/spotify_api/enitites/tracks_collection.dart';

class TrackDtoToTracksCollectionConverter implements ResultValueConverter<TracksCollection, Track> {
  @override
  Result<ConverterFailure, TracksCollection> convert(Track track) {
    try {
      return Result.isSuccessful(TracksCollection(
        spotifyId: track.id!,
        type: TracksCollectionType.track,
        name: track.name!,
        smallImageUrl: track.album?.images?.first.url,
        bigImageUrl: track.album?.images?.last.url));
    } catch (e) {
      return Result.notSuccessful(ConverterFailure());
    }
  }

  @override
  Result<ConverterFailure, Track> convertBack(TracksCollection value) {
    throw UnimplementedError();
  }

}
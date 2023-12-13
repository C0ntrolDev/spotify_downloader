import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

class GetTracksFromTracksCollectionArgs {
  GetTracksFromTracksCollectionArgs(
      {required this.tracksCollection,
      required this.responseList,
      this.offset = 0});

  final TracksCollection tracksCollection;
  final List<Track?> responseList;
  final int offset;
}

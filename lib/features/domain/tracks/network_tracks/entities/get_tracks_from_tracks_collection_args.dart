import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection.dart';

class GetTracksFromTracksCollectionArgs {
  GetTracksFromTracksCollectionArgs(
      {required this.tracksCollection,
      this.offset = 0});

  final TracksCollection tracksCollection;
  final int offset;
}

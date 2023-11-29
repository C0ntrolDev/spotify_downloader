import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

class GetTracksFromTracksCollectionArgs {
  GetTracksFromTracksCollectionArgs(
      {required this.tracksCollection,
      required this.responseList});

  final TracksCollection tracksCollection;
  final List<Track?> responseList;
}

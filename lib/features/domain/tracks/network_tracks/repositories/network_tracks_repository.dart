import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/get_tracks_from_tracks_collection_args.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/tracks_getting_controller.dart';

abstract class NetworkTracksRepository {
  TracksGettingController getTracksFromTracksCollection(GetTracksFromTracksCollectionArgs args);
}
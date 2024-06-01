import 'package:spotify_downloader/features/data_domain/tracks/domain/network_tracks/entities/get_tracks_from_tracks_collection_args.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/network_tracks/entities/tracks_getting_observer.dart';

abstract class NetworkTracksRepository {
  Future<TracksGettingObserver> getTracksFromTracksCollection(GetTracksFromTracksCollectionArgs args);
}
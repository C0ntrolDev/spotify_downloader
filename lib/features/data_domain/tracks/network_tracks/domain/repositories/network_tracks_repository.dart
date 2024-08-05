import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/domain/domain.dart';

abstract class NetworkTracksRepository {
  Future<TracksGettingObserver> getTracksFromTracksCollection(GetTracksFromTracksCollectionArgs args);
}
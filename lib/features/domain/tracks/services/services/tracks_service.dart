import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_controller.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

abstract class TracksService {
  Future<TracksWithLoadingObserverGettingController> getTracksWithLoadingObserversFromTracksColleciton({required TracksCollection tracksCollection, required List<TrackWithLoadingObserver> responseList, required int offset});
  TracksWithLoadingObserverGettingController getLikedTracksWithLoadingObservers(List<TrackWithLoadingObserver> responseList);
  Future<Result<Failure, LoadingTrackObserver>> downloadTrack(Track track); 
}
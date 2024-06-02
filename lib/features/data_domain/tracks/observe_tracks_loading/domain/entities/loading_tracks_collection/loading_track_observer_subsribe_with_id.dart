import 'dart:async';

import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_observer.dart';

class LoadingTrackObserverSubscriptionWithId {
  LoadingTrackObserverSubscriptionWithId(
      {required this.loadingTrackObserver, required this.spotifyId, required this.loadingTrackObserverSubscribtions});

  final LoadingTrackObserver loadingTrackObserver;
  final String spotifyId;
  final List<StreamSubscription> loadingTrackObserverSubscribtions;
}

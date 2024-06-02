import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/features/data_domain/tracks/observe_tracks_loading/domain/entities/loading_tracks_collection/loading_tracks_collection_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/observe_tracks_loading/domain/entities/loading_tracks_collection/loading_tracks_collection_status.dart';
import 'package:spotify_downloader/features/data_domain/tracks/observe_tracks_loading/domain/entities/repository/loading_tracks_collections_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/observe_tracks_loading/domain/use_cases/get_loading_tracks_collections_observer.dart';
import 'package:spotify_downloader/features/presentation/tracks_collections_loading_notifications/bloc_entities/tracks_collections_loading_info.dart';

part 'tracks_collections_loading_notifications_event.dart';
part 'tracks_collections_loading_notifications_state.dart';

class TracksCollectionsLoadingNotificationsBloc
    extends Bloc<TracksCollectionsLoadingNotificationsEvent, TracksCollectionsLoadingNotificationsState> {
  final GetLoadingTracksCollectionsObserver _getLoadingTracksCollectionsObserver;

  LoadingTracksCollectionsObserver? _loadingTracksCollectionsObserver;
  StreamSubscription<void>? _observerChangedSubscription;
  final List<StreamSubscription<void>> _collectionsObserversSubscriptions = List.empty(growable: true);

  TracksCollectionsLoadingNotificationsBloc(this._getLoadingTracksCollectionsObserver)
      : super(TracksCollectionsLoadingNotificationInitial()) {
    on<TracksCollectionsLoadingNotificationsLoad>(_onLoad);
    on<TracksCollectionsLoadingNotificationsUpdate>(_onUpdate);
  }

  @override
  Future<void> close() async {
    await _observerChangedSubscription?.cancel();
    await _unsubscribeFromCollectionsObservers();
    return super.close();
  }

  FutureOr<void> _onLoad(event, emit) async {
    if (_loadingTracksCollectionsObserver != null) return;

    final result = await _getLoadingTracksCollectionsObserver.call(null);
    if (!result.isSuccessful) {
      emit(TracksCollectionsLoadingNotificationFailure(failure: result.failure));
      return;
    }

    _loadingTracksCollectionsObserver = result.result;
    if (_loadingTracksCollectionsObserver != null) {
      _loadingTracksCollectionsObserver!.loadingTracksCollectionsChangedStream.listen((event) async {
        await _unsubscribeFromCollectionsObservers();
        _subscribeToCollectionsObservers(_loadingTracksCollectionsObserver!.loadingTracksCollections);
        add(TracksCollectionsLoadingNotificationsUpdate());
      });
    }
  }

  Future<void> _unsubscribeFromCollectionsObservers() async {
    for (var sub in _collectionsObserversSubscriptions) {
      await sub.cancel();
    }
    _collectionsObserversSubscriptions.clear();
  }

  void _subscribeToCollectionsObservers(List<LoadingTracksCollectionObserver> collectionsObservers) {
    for (var observer in collectionsObservers) {
      _collectionsObserversSubscriptions.add(observer.changedStream.listen((event) {
        add(TracksCollectionsLoadingNotificationsUpdate());
      }));
    }
  }

  FutureOr<void> _onUpdate(event, emit) {
    List<String> loadingTracksCollectionsNames = List.empty(growable: true);
    int totalTracks = 0;
    int loadingTracks = 0;
    int failuredTracks = 0;
    int loadedTracks = 0;

    for (var loadingTracksCollection in _loadingTracksCollectionsObserver!.loadingTracksCollections) {
      if (loadingTracksCollection.loadingStatus == LoadingTracksCollectionStatus.loading) {
        loadingTracksCollectionsNames.add(loadingTracksCollection.loadingInfo.tracksCollection?.name ?? '');
      }

      totalTracks += loadingTracksCollection.loadingInfo.totalTracks;
      loadingTracks += loadingTracksCollection.loadingInfo.loadingTracks;
      failuredTracks += loadingTracksCollection.loadingInfo.failuredTracks;
      loadedTracks += loadingTracksCollection.loadingInfo.loadedTracks;
    }

    emit(TracksCollectionsLoadingNotificationsChanged(
        info: TracksCollectionsLoadingInfo(
            loadingTracksCollectionsNames: loadingTracksCollectionsNames,
            totalTracks: totalTracks,
            loadedTracks: loadedTracks,
            loadingTracks: loadingTracks,
            failuredTracks: failuredTracks)));
  }
}

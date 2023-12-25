import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/entities/loading_tracks_collection/loading_tracks_collection_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/entities/loading_tracks_collection/loading_tracks_collection_status.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/use_cases/get_loading_tracks_collections_observer.dart';

part 'loading_tracks_collections_list_event.dart';
part 'loading_tracks_collections_list_state.dart';

class LoadingTracksCollectionsListBloc
    extends Bloc<LoadingTracksCollectionsListEvent, LoadingTracksCollectionsListState> {
  final GetLoadingTracksCollectionsObserver _getLoadingTracksCollectionsObserver;
  final List<LoadingTracksCollectionObserver> _loadingCollectionsObservers = List.empty(growable: true);
  StreamSubscription<void>? _loadingCollectionsChangedStreamSubscription;

  final List<StreamSubscription> _statusStreamSubscriptions = List.empty(growable: true);

  LoadingTracksCollectionsListBloc(this._getLoadingTracksCollectionsObserver)
      : super(LoadingTracksCollectionsListInitial()) {
    on<LoadingTracksCollectionsListLoad>(_onLoad);
    on<LoadingTracksCollectionsListUpdate>(_onUpdate);
  }

  @override
  Future<void> close() async {
    await _loadingCollectionsChangedStreamSubscription?.cancel();
    await unsubscribeFromLoadingTracksCollections();
    await super.close();
  }

  Future<void> _onLoad(LoadingTracksCollectionsListLoad event, Emitter<LoadingTracksCollectionsListState> emit) async {
    final result = await _getLoadingTracksCollectionsObserver.call(null);
    if (!result.isSuccessful) {
      emit(LoadingTracksCollectionsListFailure(failure: result.failure));
      return;
    }

    await _loadingCollectionsChangedStreamSubscription?.cancel();
    _loadingCollectionsChangedStreamSubscription =
        result.result!.loadingTracksCollectionsChangedStream.listen((event) async {
      changeLoadingTracksCollections(result.result!.loadingTracksCollections);
      add(LoadingTracksCollectionsListUpdate(loadingCollectionsObservers: result.result!.loadingTracksCollections));
    });

    await changeLoadingTracksCollections(result.result!.loadingTracksCollections);
    await _onUpdate(
        LoadingTracksCollectionsListUpdate(loadingCollectionsObservers: result.result!.loadingTracksCollections),
        emit);
  }

  Future<void> changeLoadingTracksCollections(List<LoadingTracksCollectionObserver> loadingTracksCollections) async {
    _loadingCollectionsObservers.clear();
    _loadingCollectionsObservers.addAll(loadingTracksCollections);

    await unsubscribeFromLoadingTracksCollections();
    subscribeToLoadingTracksCollections(loadingTracksCollections);
  }

  Future<void> _onUpdate(
      LoadingTracksCollectionsListUpdate event, Emitter<LoadingTracksCollectionsListState> emit) async {
    emit(LoadingTracksCollectionsListLoaded(
        loadingCollectionsObservers: _loadingCollectionsObservers
            .where((o) =>
                o.loadingStatus != LoadingTracksCollectionStatus.loaded ||
                o.loadingInfo.failuredTracks / o.loadingInfo.totalTracks > 0.3)
            .toList()));
  }

  Future<void> unsubscribeFromLoadingTracksCollections() async {
    for (var sub in _statusStreamSubscriptions) {
      await sub.cancel();
    }
    _statusStreamSubscriptions.clear();
  }

  void subscribeToLoadingTracksCollections(List<LoadingTracksCollectionObserver> loadingTracksCollections) async {
    for (var loadingTracksCollection in loadingTracksCollections) {
      _statusStreamSubscriptions.add(loadingTracksCollection.loadingStatusChangedStream.listen((event) {
        add(LoadingTracksCollectionsListUpdate(loadingCollectionsObservers: _loadingCollectionsObservers));
      }));
    }
  }
}

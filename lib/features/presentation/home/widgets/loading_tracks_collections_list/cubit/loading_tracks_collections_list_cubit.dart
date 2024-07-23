import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/observe_tracks_loading/domain/domain.dart';

part 'loading_tracks_collections_list_state.dart';

class LoadingTracksCollectionsListCubit extends Cubit<LoadingTracksCollectionsListState> {
  final GetLoadingTracksCollectionsObserver _getLoadingTracksCollectionsListObserver;

  final List<LoadingTracksCollectionObserver> _loadingCollectionsObservers = List.empty(growable: true);

  StreamSubscription<void>? _loadingTracksCollectionsListStreamSubscription;
  final List<StreamSubscription> _loadingTracksCollectionsStatusesStreamSubscriptions = List.empty(growable: true);

  LoadingTracksCollectionsListCubit(this._getLoadingTracksCollectionsListObserver)
      : super(LoadingTracksCollectionsListInitial());

  static const double _minSuccessfulPercent = 0.3;

  @override
  Future<void> close() async {
    await _unsubscribeFromListObserver();
    await _unsubscribeFromLoadingTracksCollections();
    await super.close();
  }

  Future<void> load() async {
    final getLoadingTracksCollectionsObserverResult = await _getLoadingTracksCollectionsListObserver.call(null);
    if (!getLoadingTracksCollectionsObserverResult.isSuccessful) {
      emit(LoadingTracksCollectionsListFailure(failure: getLoadingTracksCollectionsObserverResult.failure));
      return;
    }

    await _changeListObserver(getLoadingTracksCollectionsObserverResult.result!);
    await _changeLoadingTracksCollections(getLoadingTracksCollectionsObserverResult.result!.loadingTracksCollections);

    await _update();
  }

  Future<void> _changeListObserver(LoadingTracksCollectionsObserver listObserver) async {
    _unsubscribeFromListObserver();

    _loadingTracksCollectionsListStreamSubscription =
        listObserver.loadingTracksCollectionsChangedStream.listen((event) async {
      _changeLoadingTracksCollections(listObserver.loadingTracksCollections);
      _update();
    });
  }

  Future<void> _unsubscribeFromListObserver() async {
    await _loadingTracksCollectionsListStreamSubscription?.cancel();
  }

  Future<void> _changeLoadingTracksCollections(List<LoadingTracksCollectionObserver> loadingTracksCollections) async {
    _loadingCollectionsObservers.clear();
    _loadingCollectionsObservers.addAll(loadingTracksCollections);

    await _unsubscribeFromLoadingTracksCollections();
    for (var loadingTracksCollection in loadingTracksCollections) {
      _loadingTracksCollectionsStatusesStreamSubscriptions
          .add(loadingTracksCollection.loadingStatusChangedStream.listen((event) => _update()));
    }
  }

  Future<void> _unsubscribeFromLoadingTracksCollections() async {
    for (var sub in _loadingTracksCollectionsStatusesStreamSubscriptions) {
      await sub.cancel();
    }
    _loadingTracksCollectionsStatusesStreamSubscriptions.clear();
  }

  Future<void> _update() async {
    emit(LoadingTracksCollectionsListLoaded(
        loadingCollectionsObservers: _loadingCollectionsObservers
            .where((o) =>
                o.loadingStatus != LoadingTracksCollectionStatus.loaded ||
                o.loadingInfo.failuredTracks / o.loadingInfo.totalTracks > _minSuccessfulPercent)
            .toList()));
  }
}

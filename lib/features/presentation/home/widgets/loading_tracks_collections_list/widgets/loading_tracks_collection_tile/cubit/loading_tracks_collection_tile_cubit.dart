import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/entities/loading_tracks_collection/loading_tracks_collection_info.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/entities/loading_tracks_collection/loading_tracks_collection_observer.dart';

part 'loading_tracks_collection_tile_state.dart';

class LoadingTracksCollectionTileCubit extends Cubit<LoadingTracksCollectionTileState> {
  final LoadingTracksCollectionObserver _loadingObserver;

  final List<StreamSubscription> _loadingObserverSubscriptions = List.empty(growable: true);

  LoadingTracksCollectionTileCubit(this._loadingObserver)
      : super(LoadingTracksCollectionTileChanged(loadingTrackInfo: _loadingObserver.loadingInfo)) {
    _subscribeToLoadingObserver();
  }

  @override
  Future<void> close() async {
    await _unsubcribeToLoadingObserver();
    return super.close();
  }

  void _subscribeToLoadingObserver() {
    _loadingObserverSubscriptions.addAll([
      _loadingObserver.changedStream.listen((event) => _onLoadingCollectionInfoChanged())
    ]);
  }

  Future<void> _unsubcribeToLoadingObserver() async {
    for (var sub in _loadingObserverSubscriptions) {
      await sub.cancel();
    }
  }

  void _onLoadingCollectionInfoChanged() {
    emit(LoadingTracksCollectionTileChanged(loadingTrackInfo: _loadingObserver.loadingInfo));
  }
}

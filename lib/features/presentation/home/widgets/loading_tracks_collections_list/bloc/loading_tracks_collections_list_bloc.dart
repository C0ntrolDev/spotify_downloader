import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/entities/loading_tracks_collection/loading_tracks_collection_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/use_cases/get_loading_tracks_collections_observer.dart';

part 'loading_tracks_collections_list_event.dart';
part 'loading_tracks_collections_list_state.dart';

class LoadingTracksCollectionsListBloc
    extends Bloc<LoadingTracksCollectionsListEvent, LoadingTracksCollectionsListState> {
  final GetLoadingTracksCollectionsObserver _getLoadingTracksCollectionsObserver;
  final List<LoadingTracksCollectionObserver> _loadingCollectionsObservers = List.empty(growable: true);
  StreamController<void>? _loadingCollectionsChangedStreamController;

  LoadingTracksCollectionsListBloc(this._getLoadingTracksCollectionsObserver)
      : super(LoadingTracksCollectionsListInitial()) {
    on<LoadingTracksCollectionsListLoad>(_onLoad);
  }

  @override
  Future<void> close() async {
    await _loadingCollectionsChangedStreamController?.close();
    await super.close();
  }

  Future<void> _onLoad(LoadingTracksCollectionsListLoad event, Emitter<LoadingTracksCollectionsListState> emit) async {
    final result = await _getLoadingTracksCollectionsObserver.call(null);
    if (!result.isSuccessful) {
      emit(LoadingTracksCollectionsListFailure(failure: result.failure));
      return;
    }

    _loadingCollectionsChangedStreamController = StreamController<void>();
    result.result!.loadingTracksCollectionsChangedStream.listen((event) {
      _loadingCollectionsChangedStreamController!.add(null);
    });

    emit(_onLoadingTracksCollectionsChanged(result.result!.loadingTracksCollections));

    await emit.forEach(_loadingCollectionsChangedStreamController!.stream, onData: (event) {
      return _onLoadingTracksCollectionsChanged(result.result!.loadingTracksCollections);
    });
  }

  LoadingTracksCollectionsListState _onLoadingTracksCollectionsChanged(
      List<LoadingTracksCollectionObserver> loadingCollectionsObservers) {
    _loadingCollectionsObservers.clear();
    _loadingCollectionsObservers.addAll(loadingCollectionsObservers);
    return LoadingTracksCollectionsListLoaded(loadingCollectionsObservers: _loadingCollectionsObservers);
  }
}

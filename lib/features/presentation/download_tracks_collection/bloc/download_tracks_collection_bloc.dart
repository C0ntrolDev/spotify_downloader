import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/history_tracks_collectons/use_cases/add_tracks_collection_to_history.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/tracks_getting_ended_status.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_controller.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/get_tracks_with_loading_observer_from_tracks_colleciton.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/get_tracks_with_loading_observer_from_tracks_colleciton_with_offset.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/network_tracks_collections/use_cases/get_tracks_collection_by_history_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/network_tracks_collections/use_cases/get_tracks_collection_by_url.dart';

part 'download_tracks_collection_event.dart';
part 'download_tracks_collection_state.dart';

class DownloadTracksCollectionBloc extends Bloc<DownloadTracksCollectionBlocEvent, DownloadTracksCollectionBlocState> {
  final GetTracksCollectionByUrl _getTracksCollectionByUrl;
  final GetTracksCollectionByTypeAndSpotifyId _getTracksCollectionByTypeAndSpotifyId;
  final GetTracksWithLoadingObserverFromTracksColleciton _getFromTracksColleciton;
  final AddTracksCollectionToHistory _addTracksCollectionToHistory;
  final GetTracksWithLoadingObserverFromTracksCollecitonWithOffset _getFromTracksCollectionWithOffset;

  late final StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final List<TrackWithLoadingObserver> _tracksGettingResponseList = List.empty(growable: true);
  TracksWithLoadingObserverGettingObserver? _tracksGettingObserver;
  TracksCollection? _tracksCollection;

  bool _initialLoadingEnded = false;
  bool _gettingEndedWithNetworkFailure = false;

  String? filterQuery;
  List<TrackWithLoadingObserver> get _filteredTracks => _tracksGettingResponseList.where((trackWithLoadingObserver) {
        if (filterQuery == null || filterQuery!.isEmpty) {
          return true;
        }

        return trackWithLoadingObserver.track.name.toLowerCase().contains(filterQuery!.toLowerCase()) ||
            (trackWithLoadingObserver.track.artists
                    ?.where((artist) => artist.toLowerCase().contains(filterQuery!.toLowerCase()))
                    .isNotEmpty ??
                false);
      }).toList();

  DownloadTracksCollectionBloc(
      {required GetTracksCollectionByTypeAndSpotifyId getTracksCollectionByTypeAndSpotifyId,
      required GetTracksCollectionByUrl getTracksCollectionByUrl,
      required GetTracksWithLoadingObserverFromTracksColleciton getTracksFromTracksColleciton,
      required GetTracksWithLoadingObserverFromTracksCollecitonWithOffset getFromTracksCollectionWithOffset,
      required AddTracksCollectionToHistory addTracksCollectionToHistory})
      : _getTracksCollectionByTypeAndSpotifyId = getTracksCollectionByTypeAndSpotifyId,
        _getTracksCollectionByUrl = getTracksCollectionByUrl,
        _getFromTracksColleciton = getTracksFromTracksColleciton,
        _getFromTracksCollectionWithOffset = getFromTracksCollectionWithOffset,
        _addTracksCollectionToHistory = addTracksCollectionToHistory,
        super(DownloadTracksCollectionInitialLoading()) {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((event) {
      _onInternetChanged(event);
    });

    on<DownloadTracksCollectionLoadWithTracksCollecitonUrl>((event, emit) async {
      await _onLoadWithTracksCollecitonUrl(event, emit);
    });

    on<DownloadTracksCollectionLoadWithHistoryTracksColleciton>((event, emit) async {
      await _onLoadWithHistoryTracksCollection(event, emit);
    });

    on<DownloadTracksCollectionContinueTracksGetting>((event, emit) {
      _onContinueTracksLoading(event, emit);
    });

    on<DownloadTracksCollectionTracksPartGot>((event, emit) {
      emit(DownloadTracksCollectionOnTracksPartGot(
          tracksCollection: _tracksCollection!,
          tracks: _filteredTracks,
          displayingTracksCount: getDisplayingTracksCount()));
    });

    on<DownloadTracksCollectionTracksGettingEnded>((event, emit) async {
      _onTracksGettingEnded(event, emit);
    });

    on<DownloadTracksCollectionCancelTracksGetting>((event, emit) {
      _tracksGettingObserver?.cancelGetting();
    });

    on<DownloadTracksCollectionInternetConnectionGoneAfterInitial>((event, emit) {
      emit(DownloadTracksCollectionAfterInititalNoInternetConnection(
          tracksCollection: _tracksCollection!,
          tracks: _filteredTracks,
          displayingTracksCount: getDisplayingTracksCount()));
    });

    on<DownloadTracksCollectionInternetConnectionGoneBeforeInitial>((event, emit) {
      emit(DownloadTracksCollectionBeforeInitialNoInternetConnection());
    });

    on<DownloadTracksCollectionFilterQueryChanged>((event, emit) {
      _onFilterQueryChanged(event, emit);
    });
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription.cancel();
    return super.close();
  }

  Future<void> _onLoadWithTracksCollecitonUrl(DownloadTracksCollectionLoadWithTracksCollecitonUrl event,
      Emitter<DownloadTracksCollectionBlocState> emit) async {
    emit(DownloadTracksCollectionInitialLoading());

    final tracksCollectionResult = await _getTracksCollectionByUrl.call(event.url);
    if (!tracksCollectionResult.isSuccessful) {
      emitFailureStateBasedOnFailureType(emit, tracksCollectionResult.failure!);
      return;
    }

    _tracksCollection = tracksCollectionResult.result;

    final addTracksCollectionToHistoryResult = await _addTracksCollectionToHistory.call(_tracksCollection!);
    if (!addTracksCollectionToHistoryResult.isSuccessful) {
      emitFailureStateBasedOnFailureType(emit, addTracksCollectionToHistoryResult.failure!);
      return;
    }

    await startGettingTracksFromTracksColleciton(emit);
  }

  Future<void> _onLoadWithHistoryTracksCollection(DownloadTracksCollectionLoadWithHistoryTracksColleciton event,
      Emitter<DownloadTracksCollectionBlocState> emit) async {
    emit(DownloadTracksCollectionInitialLoading());

    final tracksCollectionResult = await _getTracksCollectionByTypeAndSpotifyId
        .call((event.historyTracksCollection.type, event.historyTracksCollection.spotifyId));
    if (!tracksCollectionResult.isSuccessful) {
      emitFailureStateBasedOnFailureType(emit, tracksCollectionResult.failure!);
      return;
    }

    _tracksCollection = tracksCollectionResult.result;

    final addTracksCollectionToHistoryResult = await _addTracksCollectionToHistory.call(_tracksCollection!);
    if (!addTracksCollectionToHistoryResult.isSuccessful) {
      emitFailureStateBasedOnFailureType(emit, addTracksCollectionToHistoryResult.failure!);
      return;
    }

    await startGettingTracksFromTracksColleciton(emit);
  }

    Future<void> startGettingTracksFromTracksColleciton(Emitter<DownloadTracksCollectionBlocState> emit) async {
    final tracksGettingObserverResult =
        await _getFromTracksColleciton.call((_tracksCollection!, _tracksGettingResponseList));
    if (!tracksGettingObserverResult.isSuccessful) {
      emitFailureStateBasedOnFailureType(emit, tracksGettingObserverResult.failure!);
      return;
    }

    _initialLoadingEnded = true;
    _tracksGettingObserver = tracksGettingObserverResult.result!;
    _tracksGettingObserver!.onPartGot = () => add(DownloadTracksCollectionTracksPartGot());
    _tracksGettingObserver!.onEnded = (result) => add(DownloadTracksCollectionTracksGettingEnded(result: result));
  }

  Future<void> _onContinueTracksLoading(
      DownloadTracksCollectionContinueTracksGetting event, Emitter<DownloadTracksCollectionBlocState> emit) async {
    _gettingEndedWithNetworkFailure = false;

    final tracksGettingObserverResult = await _getFromTracksCollectionWithOffset
        .call((_tracksCollection!, _tracksGettingResponseList, _tracksGettingResponseList.length));
    if (!tracksGettingObserverResult.isSuccessful) {
      emitFailureStateBasedOnFailureType(emit, tracksGettingObserverResult.failure!);
      return;
    }

    _tracksGettingObserver = tracksGettingObserverResult.result!;
    _tracksGettingObserver!.onPartGot = () => add(DownloadTracksCollectionTracksPartGot());
    _tracksGettingObserver!.onEnded = (result) => add(DownloadTracksCollectionTracksGettingEnded(result: result));
  }

  void _onInternetChanged(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none || connectivityResult == ConnectivityResult.other) {
      if (_initialLoadingEnded) {
        add(DownloadTracksCollectionInternetConnectionGoneAfterInitial());
      } else {
        add(DownloadTracksCollectionInternetConnectionGoneBeforeInitial());
      }
    } else {
      if (_initialLoadingEnded) {
        if (_gettingEndedWithNetworkFailure) {
          add(DownloadTracksCollectionContinueTracksGetting());
        } else {
          add(const DownloadTracksCollectionTracksGettingEnded(
              result: Result.isSuccessful(TracksGettingEndedStatus.loaded)));
        }
      }
    }
  }

  void _onTracksGettingEnded(
      DownloadTracksCollectionTracksGettingEnded event, Emitter<DownloadTracksCollectionBlocState> emit) {
    if (event.result.isSuccessful) {
      if (event.result.result == TracksGettingEndedStatus.loaded) {
        emit(DownloadTracksCollectionOnAllTracksGot(
            tracksCollection: _tracksCollection!,
            tracks: _filteredTracks,
            displayingTracksCount: _filteredTracks.length));
      }
    } else {
      if (event.result.failure is NetworkFailure) {
        _gettingEndedWithNetworkFailure = true;
      } else {
        emit(DownloadTracksCollectionFailure(failure: event.result.failure!));
      }
    }
  }

  void _onFilterQueryChanged(
      DownloadTracksCollectionFilterQueryChanged event, Emitter<DownloadTracksCollectionBlocState> emit) {
    filterQuery = event.filterQuery;

    if (state is DownloadTracksCollectionAfterInititalNoInternetConnection) {
      emit(DownloadTracksCollectionAfterInititalNoInternetConnection(
          tracksCollection: _tracksCollection!,
          tracks: _filteredTracks,
          displayingTracksCount: getDisplayingTracksCount()));
    }

    if (state is DownloadTracksCollectionOnAllTracksGot) {
      emit(DownloadTracksCollectionOnAllTracksGot(
          tracksCollection: _tracksCollection!,
          tracks: _filteredTracks,
          displayingTracksCount: _filteredTracks.length));
    }

    if (state is DownloadTracksCollectionOnTracksPartGot) {
      emit(DownloadTracksCollectionOnTracksPartGot(
          tracksCollection: _tracksCollection!,
          tracks: _filteredTracks,
          displayingTracksCount: getDisplayingTracksCount()));
    }
  }

  int getDisplayingTracksCount() {
    if (filterQuery == null || filterQuery!.isEmpty) {
      return _tracksCollection!.tracksCount;
    } else {
      return _filteredTracks.length;
    }
  }

  void emitFailureStateBasedOnFailureType(Emitter<DownloadTracksCollectionBlocState> emit, Failure failure) {
    if (failure is NetworkFailure) {
      emit(DownloadTracksCollectionBeforeInitialNoInternetConnection());
    } else {
      emit(DownloadTracksCollectionFailure(failure: failure));
    }
  }
}

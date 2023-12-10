import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/tracks_getting_ended_status.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_controller.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/get_tracks_with_loading_observer_from_tracks_colleciton.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/get_tracks_with_loading_observer_from_tracks_colleciton_with_offset.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/use_cases/get_tracks_collection_by_url.dart';

part 'download_tracks_collection_event.dart';
part 'download_tracks_collection_state.dart';

class DownloadTracksCollectionBloc extends Bloc<DownloadTracksCollectionBlocEvent, DownloadTracksCollectionBlocState> {
  final GetTracksCollectionByUrl _getTracksCollectionByUrl;
  final GetTracksWithLoadingObserverFromTracksColleciton _getFromTracksColleciton;
  final GetTracksWithLoadingObserverFromTracksCollecitonWithOffset _getFromTracksCollectionWithOffset;

  late final StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final List<TrackWithLoadingObserver> _tracksGettingResponseList = List.empty(growable: true);
  TracksWithLoadingObserverGettingObserver? _tracksGettingObserver;
  TracksCollection? _tracksCollection;

  bool _initialLoadingEnded = false;
  bool _gettingEndedWithNetworkFailure = false;

  DownloadTracksCollectionBloc(
      {required GetTracksCollectionByUrl getTracksCollectionByUrl,
      required GetTracksWithLoadingObserverFromTracksColleciton getTracksFromTracksColleciton,
      required GetTracksWithLoadingObserverFromTracksCollecitonWithOffset getFromTracksCollectionWithOffset})
      : _getTracksCollectionByUrl = getTracksCollectionByUrl,
        _getFromTracksColleciton = getTracksFromTracksColleciton,
        _getFromTracksCollectionWithOffset = getFromTracksCollectionWithOffset,
        super(DownloadTracksCollectionInitialLoading()) {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((event) {
      _onInternetChanged(event);
    });

    on<DownloadTracksCollectionLoadWithTracksCollecitonUrl>((event, emit) async {
      await _onLoadWithTracksCollecitonUrl(event, emit);
    });

    on<DownloadTracksCollectionContinueTracksGetting>((event, emit) {
      _onContinueTracksLoading(event, emit);
    });

    on<DownloadTracksCollectionTracksPartGot>((event, emit) {
      emit(DownloadTracksCollectionOnTracksPartGot(
          tracksCollection: _tracksCollection!, tracks: _tracksGettingResponseList));
    });

    on<DownloadTracksCollectionTracksGettingEnded>((event, emit) async {
      _onTracksGettingEnded(event, emit);
    });

    on<DownloadTracksCollectionCancelTracksGetting>((event, emit) {
      _tracksGettingObserver?.cancelGetting();
    });

    on<DownloadTracksCollectionInternetConnectionGoneAfterInitial>((event, emit) {
      emit(DownloadTracksCollectionAfterInititalNoInternetConnection(
          tracksCollection: _tracksCollection!, tracks: _tracksGettingResponseList));
    });

    on<DownloadTracksCollectionInternetConnectionGoneBeforeInitial>((event, emit) {
      emit(DownloadTracksCollectionBeforeInitialNoInternetConnection());
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
    Future(() async => _onInternetChanged(await Connectivity().checkConnectivity()));

    final tracksCollectionResult = await _getTracksCollectionByUrl.call(event.url);
    if (!tracksCollectionResult.isSuccessful) {
      if (tracksCollectionResult.failure is! NetworkFailure) {
        emit(DownloadTracksCollectionFailure(failure: tracksCollectionResult.failure!));
      }
      return;
    }

    _tracksCollection = tracksCollectionResult.result;

    final tracksGettingObserverResult =
        await _getFromTracksColleciton.call((_tracksCollection!, _tracksGettingResponseList));
    if (!tracksGettingObserverResult.isSuccessful) {
      if (tracksGettingObserverResult.failure is! NetworkFailure) {
        emit(DownloadTracksCollectionFailure(failure: tracksGettingObserverResult.failure!));
      }
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
      if (tracksGettingObserverResult.failure is! NetworkFailure) {
        emit(DownloadTracksCollectionFailure(failure: tracksGettingObserverResult.failure!));
      }
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
            tracksCollection: _tracksCollection!, tracks: _tracksGettingResponseList));
      }
    } else {
      if (event.result.failure is NetworkFailure) {
        _gettingEndedWithNetworkFailure = true;
      } else {
        emit(DownloadTracksCollectionFailure(failure: event.result.failure!));
      }
    }
  }
}

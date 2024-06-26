import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/domain/entities/entities.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/tracks_collection.dart';

part 'get_tracks_event.dart';
part 'get_tracks_state.dart';

class GetTracksBloc extends Bloc<GetTracksEvent, GetTracksState> {
  final GetTracksWithLoadingObserverFromTracksCollection _getTracksFromTracksCollection;
  final GetTracksWithLoadingObserverFromTracksCollectionWithOffset _getTracksWithOffset;

  TracksCollection? _sourceTracksCollection;

  TracksWithLoadingObserverGettingObserver? _gettingObserver;
  StreamSubscription? _gettingObserverPartGotSubscription;
  StreamSubscription? _gettingObserverEndSubscription;

  final List<TrackWithLoadingObserver> _tracksList = List.empty(growable: true);
  bool isAllTracksGot = false;

  StreamSubscription? connectivitySubscription;

  GetTracksBloc(
      {required GetTracksWithLoadingObserverFromTracksCollection getTracksFromTracksCollection,
      required GetTracksWithLoadingObserverFromTracksCollectionWithOffset getTracksWithOffset})
      : _getTracksFromTracksCollection = getTracksFromTracksCollection,
        _getTracksWithOffset = getTracksWithOffset,
        super(GetTracksInitial()) {
    on<GetTracksGetTracks>(_onGetTracks);
    on<_GetTracksContinueTracksGetting>(_onCountinueTracksGetting);

    on<_GetTracksGettingObserverPartGot>(_onTracksPartGot);
    on<_GetTracksGettingObserverEnd>(_onGettingEnd);

    on<_GetTracksSubscribeToConnectivity>(_onSubscribeToConnectivity);
    on<_GetTracksConnectionChanged>(_onConnectionChanged);

    add(_GetTracksSubscribeToConnectivity());
  }

  @override
  Future<void> close() {
    _unsubscribeFromGettingObserver();
    return super.close();
  }

  Future<void> _onGetTracks(GetTracksGetTracks event, Emitter<GetTracksState> emit) async {
    _sourceTracksCollection = event.tracksCollection;
    isAllTracksGot = false;
    _tracksList.clear();
    _unsubscribeFromGettingObserver();

    var startGettingTracksResult = await _getTracksFromTracksCollection.call(event.tracksCollection);
    if (!startGettingTracksResult.isSuccessful) {
      emit(_getStateBasedOnFailure(startGettingTracksResult.failure));
      return;
    }

    _subscribeToGettingObserver(startGettingTracksResult.result!);
    emit(GetTracksTracksGettingStarted(observer: _gettingObserver!));
  }

  Future<void> _onCountinueTracksGetting(_GetTracksContinueTracksGetting event, Emitter<GetTracksState> emit) async {
    if (_sourceTracksCollection == null || isAllTracksGot) return;

    var continueGettingTracksResult = await _getTracksWithOffset.call((_sourceTracksCollection!, _tracksList.length));
    if (!continueGettingTracksResult.isSuccessful) {
      emit(_getStateBasedOnFailure(continueGettingTracksResult.failure));
      return;
    }

    _subscribeToGettingObserver(continueGettingTracksResult.result!);
    emit(GetTracksTracksGettingCountinued(
        observer: continueGettingTracksResult.result!, tracksWithLoadingObservers: _tracksList));
  }

  Future<void> _onTracksPartGot(_GetTracksGettingObserverPartGot event, Emitter<GetTracksState> emit) async {
    _tracksList.addAll(event.part);
    emit(GetTracksPartGot(tracksWithLoadingObservers: _tracksList));
  }

  Future<void> _onGettingEnd(_GetTracksGettingObserverEnd event, Emitter<GetTracksState> emit) async {
    _unsubscribeFromGettingObserver();

    if (!event.gettingResult.isSuccessful) {
      emit(_getStateBasedOnFailure(event.gettingResult.failure));
      return;
    }

    switch (event.gettingResult.result!) {
      case TracksGettingEndedStatus.cancelled:
        break;
      case TracksGettingEndedStatus.loaded:
        isAllTracksGot = true;
        emit(GetTracksAllGot(tracksWithLoadingObservers: _tracksList));
        break;
    }
  }

  Future<void> _onSubscribeToConnectivity(
      _GetTracksSubscribeToConnectivity event, Emitter<GetTracksState> emit) async {
    connectivitySubscription?.cancel();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((connection) => add(_GetTracksConnectionChanged(connection: connection)));
  }

  Future<void> _onConnectionChanged(_GetTracksConnectionChanged event, Emitter<GetTracksState> emit) async {
    if (event.connection == ConnectivityResult.none || event.connection == ConnectivityResult.other) {
      _unsubscribeFromGettingObserver();
      emit(_getNetworkFailureState());
    } else {
      if (state is GetTracksAfterPartGotNetworkFailure) {
        if (isAllTracksGot) {
          emit(GetTracksAllGot(tracksWithLoadingObservers: _tracksList));
          return;
        } else {
          add(_GetTracksContinueTracksGetting());
        }
      }
    }
  }

  void _subscribeToGettingObserver(TracksWithLoadingObserverGettingObserver gettingObserver) {
    _gettingObserver = gettingObserver;

    _gettingObserverPartGotSubscription =
        gettingObserver.onPartGot.listen((part) => add(_GetTracksGettingObserverPartGot(part: part)));
    _gettingObserverEndSubscription = gettingObserver.onEnded
        .listen((gettingResult) => add(_GetTracksGettingObserverEnd(gettingResult: gettingResult)));
  }

  void _unsubscribeFromGettingObserver() {
    _gettingObserverPartGotSubscription?.cancel();
    _gettingObserverEndSubscription?.cancel();

    _gettingObserver = null;
    _gettingObserverPartGotSubscription = null;
    _gettingObserverEndSubscription = null;
  }

  GetTracksState _getStateBasedOnFailure(Failure? failure) {
    if (failure is NetworkFailure) {
      return _getNetworkFailureState();
    }
    return GetTracksFailure(failure: failure);
  }

  GetTracksState _getNetworkFailureState() {
    if (_tracksList.isNotEmpty) {
      return GetTracksAfterPartGotNetworkFailure(tracksWithLoadingObservers: _tracksList);
    } else {
      return GetTracksBeforePartGotNetworkFailure();
    }
  }
}

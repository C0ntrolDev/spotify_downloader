import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/tracks_getting_ended_status.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/tracks_with_loading_observer_getting_controller.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/get_tracks_with_loading_observer_from_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/get_tracks_with_loading_observer_from_tracks_collection_with_offset.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection.dart';

part 'get_and_download_tracks_event.dart';
part 'get_and_download_tracks_state.dart';

class GetAndDownloadTracksBloc extends Bloc<GetAndDownloadTracksEvent, GetAndDownloadTracksState> {
  final GetTracksWithLoadingObserverFromTracksCollection _getTrackFromTracksCollection;
  final GetTracksWithLoadingObserverFromTracksCollectionWithOffset _getTracksWithOffset;

  TracksCollection? _sourceTracksCollection;

  final List<TrackWithLoadingObserver> _tracksList = List.empty(growable: true);
  final List<StreamController> _gettingObserverStreamControllers = List.empty(growable: true);

  bool isAllTracksGot = false;
  final Completer<void> subscribeToConnectivityCompleter = Completer();

  GetAndDownloadTracksBloc(
      {required GetTracksWithLoadingObserverFromTracksCollection getTracks,
      required GetTracksWithLoadingObserverFromTracksCollectionWithOffset getTracksWithOffset})
      : _getTrackFromTracksCollection = getTracks,
        _getTracksWithOffset = getTracksWithOffset,
        super(GetAndDownloadTracksInitital()) {
    on<GetAndDownloadTracksSubscribeToConnectivity>((event, emit) async => await _subscribeToConnectivity(emit));

    on<GetAndDownloadTracksGetTracks>(_getTracks);

    on<GetAndDownloadTracksContinueTracksGetting>(_continueTracksGetting);

    add(GetAndDownloadTracksSubscribeToConnectivity());
  }

  @override
  Future<void> close() async {
    await _unsubscribeFromTracksGettingObserver();
    return super.close();
  }

  Future<void> _subscribeToConnectivity(Emitter<GetAndDownloadTracksState> emit) async {
    if (subscribeToConnectivityCompleter.isCompleted) return;
    subscribeToConnectivityCompleter.complete();

    await emit.forEach(Connectivity().onConnectivityChanged, onData: _onInternetChanged);
  }

  GetAndDownloadTracksState _onInternetChanged(ConnectivityResult status) {
    if (status == ConnectivityResult.none || status == ConnectivityResult.other) {
      _unsubscribeFromTracksGettingObserver();
      return _getNetworkFailureState();
    } else {
      if (state is GetAndDownloadTracksAfterPartGotNetworkFailure) {
        if (isAllTracksGot) {
          return GetAndDownloadTracksAllGot(tracksWithLoadingObservers: _tracksList);
        } else {
          add(GetAndDownloadTracksContinueTracksGetting());
        }
      }
    }

    return state;
  }

  Future<void> _getTracks(GetAndDownloadTracksGetTracks event, Emitter<GetAndDownloadTracksState> emit) async {
    emit(GetAndDownloadTracksTracksGetting());

    if (!subscribeToConnectivityCompleter.isCompleted) {
      await subscribeToConnectivityCompleter.future;
    }

    isAllTracksGot = false;
    _tracksList.clear();
    _sourceTracksCollection = event.tracksCollection;
    await _unsubscribeFromTracksGettingObserver();

    final getTracksResult = await _getTrackFromTracksCollection.call(_sourceTracksCollection!);
    if (!getTracksResult.isSuccessful) {
      emit(_getStateBasedOnFailure(getTracksResult.failure));
      return;
    }

    await _subscribeToTracksGettingObserver(emit, getTracksResult.result!);
  }

  Future<void> _continueTracksGetting(
      GetAndDownloadTracksContinueTracksGetting event, Emitter<GetAndDownloadTracksState> emit) async {
    if (_sourceTracksCollection == null) return;
    if (isAllTracksGot) return;

    _unsubscribeFromTracksGettingObserver();

    final continueTracksGettingResult =
        await _getTracksWithOffset.call((_sourceTracksCollection!, _tracksList.length));
    if (!continueTracksGettingResult.isSuccessful) {
      emit(_getStateBasedOnFailure(continueTracksGettingResult.failure));
      return;
    }

    await _subscribeToTracksGettingObserver(emit, continueTracksGettingResult.result!);
  }

  Future<void> _subscribeToTracksGettingObserver(
      Emitter<GetAndDownloadTracksState> emit, TracksWithLoadingObserverGettingObserver observer) async {
    final partGotFuture = emit.forEach(_subscribeToStream(observer.onPartGot), onData: (part) {
      _tracksList.addAll(part);

      return GetAndDownloadTracksPartGot(tracksWithLoadingObservers: _tracksList);
    });
    final onEndedFuture = emit.forEach(_subscribeToStream(observer.onEnded), onData: _onTracksGettingEnded);

    await Future.wait([partGotFuture, onEndedFuture]);
  }

  Stream<T> _subscribeToStream<T>(Stream<T> stream) {
    final subscribedStreamController = StreamController<T>();
    final streamSub = stream.listen((event) {
      subscribedStreamController.add(event);
    });
    subscribedStreamController.onCancel = () => streamSub.cancel();
    _gettingObserverStreamControllers.add(subscribedStreamController);
    return subscribedStreamController.stream;
  }

  GetAndDownloadTracksState _onTracksGettingEnded(Result<Failure, TracksGettingEndedStatus> result) {
    _unsubscribeFromTracksGettingObserver();

    if (result.isSuccessful) {
      isAllTracksGot = true;
      return GetAndDownloadTracksAllGot(tracksWithLoadingObservers: _tracksList);
    }

    return _getStateBasedOnFailure(result.failure);
  }

  GetAndDownloadTracksState _getStateBasedOnFailure(Failure? failure) {
    if (failure is NetworkFailure) {
      return _getNetworkFailureState();
    }
    return GetAndDownloadTracksFailure(failure: failure);
  }

  GetAndDownloadTracksState _getNetworkFailureState() {
    if (_tracksList.isNotEmpty) {
      return GetAndDownloadTracksAfterPartGotNetworkFailure(tracksWithLoadingObservers: _tracksList);
    } else {
      return GetAndDownloadTracksBeforePartGotNetworkFailure();
    }
  }

  Future<void> _unsubscribeFromTracksGettingObserver() async {
    for (var controller in _gettingObserverStreamControllers) {
      await controller.close();
    }
  }
}

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/failures/failures.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/domain/entities/tracks_getting_ended_status.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/tracks_with_loading_observer_getting_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/use_cases/download_tracks_from_getting_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/use_cases/download_tracks_range.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/use_cases/get_tracks_with_loading_observer_from_tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/use_cases/get_tracks_with_loading_observer_from_tracks_collection_with_offset.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/tracks_collection.dart';

part 'get_and_download_tracks_event.dart';
part 'get_and_download_tracks_state.dart';

class GetAndDownloadTracksBloc extends Bloc<GetAndDownloadTracksEvent, GetAndDownloadTracksState> {
  final GetTracksWithLoadingObserverFromTracksCollection _getTracksFromTracksCollection;
  final GetTracksWithLoadingObserverFromTracksCollectionWithOffset _getTracksWithOffset;

  final DownloadTracksRange _downloadTracksRange;
  final DownloadTracksFromGettingObserver _downloadTracksFromGettingObserver;

  TracksCollection? _sourceTracksCollection;

  final List<TrackWithLoadingObserver> _tracksList = List.empty(growable: true);
  final List<StreamController> _gettingObserverStreamControllers = List.empty(growable: true);
  final List<StreamSubscription> _tracksToLoadingObserversStreamSubscriptions = List.empty(growable: true);
  TracksWithLoadingObserverGettingObserver? _gettingObserver;

  bool isAllTracksGot = false;
  final Completer<void> subscribeToConnectivityCompleter = Completer();

  GetAndDownloadTracksBloc(
      {required GetTracksWithLoadingObserverFromTracksCollection getTracksFromTracksCollection,
      required GetTracksWithLoadingObserverFromTracksCollectionWithOffset getTracksWithOffset,
      required DownloadTracksRange downloadTracksRange,
      required DownloadTracksFromGettingObserver downloadTracksFromGettingObserver})
      : _getTracksFromTracksCollection = getTracksFromTracksCollection,
        _getTracksWithOffset = getTracksWithOffset,
        _downloadTracksRange = downloadTracksRange,
        _downloadTracksFromGettingObserver = downloadTracksFromGettingObserver,
        super(GetAndDownloadTracksInitital()) {
    on<GetAndDownloadTracksSubscribeToConnectivity>((event, emit) async => await _subscribeToConnectivity(emit));

    on<GetAndDownloadTracksGetTracks>(_onGetTracks);

    on<GetAndDownloadTracksDownloadAllTracks>(_onDownloadAllTracks);

    on<GetAndDownloadTracksContinueTracksGetting>(_onContinueTracksGetting);

    on<GetAndDownloadTracksDownloadTracksRange>(_onDownloadTracksRange);

    add(GetAndDownloadTracksSubscribeToConnectivity());
  }

  @override
  Future<void> close() async {
    await _unsubscribeFromTracksGettingObserver();
    await _unsubscribeTracksFromLoadingObservers();
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

  Future<void> _onDownloadAllTracks(
      GetAndDownloadTracksDownloadAllTracks event, Emitter<GetAndDownloadTracksState> emit) async {
    Future<Result<Failure, void>>? downloadTracksFromGettingObserverFuture;
    if (_gettingObserver != null) {
      downloadTracksFromGettingObserverFuture = _downloadTracksFromGettingObserver.call(_gettingObserver!);
    }

    await _onDownloadTracksRange(GetAndDownloadTracksDownloadTracksRange(tracksRange: _tracksList), emit);

    final downloadTracksFromGettingObserverResult = await downloadTracksFromGettingObserverFuture;
    if (!(downloadTracksFromGettingObserverResult?.isSuccessful ?? true)) {
      emit(GetAndDownloadTracksFailure(failure: downloadTracksFromGettingObserverResult?.failure));
    }
  }

  Future<void> _onDownloadTracksRange(
      GetAndDownloadTracksDownloadTracksRange event, Emitter<GetAndDownloadTracksState> emit) async {
    final downloadTracksRangeResult = await _downloadTracksRange.call(event.tracksRange);
    if (!downloadTracksRangeResult.isSuccessful) {
      emit(GetAndDownloadTracksFailure(failure: downloadTracksRangeResult.failure));
    }
  }

  Future<void> _onGetTracks(GetAndDownloadTracksGetTracks event, Emitter<GetAndDownloadTracksState> emit) async {
    emit(GetAndDownloadTracksTracksGetting());

    if (!subscribeToConnectivityCompleter.isCompleted) {
      await subscribeToConnectivityCompleter.future;
    }

    isAllTracksGot = false;
    _tracksList.clear();
    _sourceTracksCollection = event.tracksCollection;
    _gettingObserver = null;
    await _unsubscribeFromTracksGettingObserver();
    await _unsubscribeTracksFromLoadingObservers();

    final getTracksResult = await _getTracksFromTracksCollection.call(_sourceTracksCollection!);
    if (!getTracksResult.isSuccessful) {
      emit(_getStateBasedOnFailure(getTracksResult.failure));
      return;
    }

    _gettingObserver = getTracksResult.result!;
    await _subscribeToTracksGettingObserver(emit, getTracksResult.result!);
  }

  Future<void> _onContinueTracksGetting(
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
      _subscribeTracksToLoadingObservers(part);

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

  void _subscribeTracksToLoadingObservers(List<TrackWithLoadingObserver> tracksWithLoadingObservers) {
    for (var trackWithLoadingObserver in tracksWithLoadingObservers) {
      final track = trackWithLoadingObserver.track;
      final loadingObserver = trackWithLoadingObserver.loadingObserver;

      if (loadingObserver != null) {
        if (loadingObserver.youtubeUrl != null) {
          track.youtubeUrl = loadingObserver.youtubeUrl;
        } else {
          if (loadingObserver.status == LoadingTrackStatus.waitInLoadingQueue) {
            _tracksToLoadingObserversStreamSubscriptions.add(loadingObserver.startLoadingStream.listen((youtubeUrl) {
              track.youtubeUrl = youtubeUrl;
            }));
          }
        }
      }
    }
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

  Future<void> _unsubscribeTracksFromLoadingObservers() async {
    for (var sub in _tracksToLoadingObserversStreamSubscriptions) {
      await sub.cancel();
    }
  }

}

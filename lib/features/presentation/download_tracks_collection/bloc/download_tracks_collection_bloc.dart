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
import 'package:spotify_downloader/features/domain/tracks_collections/use_cases/get_tracks_collection_by_url.dart';

part 'download_tracks_collection_event.dart';
part 'download_tracks_collection_state.dart';

class DownloadTracksCollectionBloc extends Bloc<DownloadTracksCollectionBlocEvent, DownloadTracksCollectionBlocState> {
  final GetTracksCollectionByUrl _getTracksCollectionByUrl;
  final GetTracksWithLoadingObserverFromTracksColleciton _getFromTracksColleciton;

  final List<TrackWithLoadingObserver> _tracksGettingResponseList = List.empty(growable: true);
  TracksWithLoadingObserverGettingController? _tracksGettingController;
  TracksCollection? _tracksCollection;

  DownloadTracksCollectionBloc(
      {required GetTracksCollectionByUrl getTracksCollectionByUrl,
      required GetTracksWithLoadingObserverFromTracksColleciton getTracksFromTracksColleciton})
      : _getTracksCollectionByUrl = getTracksCollectionByUrl,
        _getFromTracksColleciton = getTracksFromTracksColleciton,
        super(DownloadTracksCollectionLoading()) {
    on<DownloadTracksCollectionLoadWithTracksCollecitonUrl>((event, emit) async {
      final tracksCollectionResult = await _getTracksCollectionByUrl.call(event.url);
      if (tracksCollectionResult.isSuccessful) {
        _tracksCollection = tracksCollectionResult.result;

        final tracksGettingControllerResult =
            await _getFromTracksColleciton.call((_tracksCollection!, _tracksGettingResponseList));
        if (tracksGettingControllerResult.isSuccessful) {
          _tracksGettingController = tracksGettingControllerResult.result!;
          _tracksGettingController!.onPartGetted = () => add(DownloadTracksCollectionTracksPartGetted());
          _tracksGettingController!.onEnded =
              (result) => add(DownloadTracksCollectionOnTracksGettingEnded(result: result));
        } else {
          if (tracksCollectionResult.failure is NetworkFailure) {
            emit(DownloadTracksCollectionInitialNetworkFailure());
          } else {
            emit(DownloadTracksCollectionFailure(failure: tracksGettingControllerResult.failure!));
          }
        }
      } else {
        if (tracksCollectionResult.failure is NetworkFailure) {
          emit(DownloadTracksCollectionInitialNetworkFailure());
        } else {
          emit(DownloadTracksCollectionFailure(failure: tracksCollectionResult.failure!));
        }
      }
    });

    on<DownloadTracksCollectionOnTracksGettingEnded>((event, emit) async {
      if (event.result.isSuccessful) {
        if (event.result.result == TracksGettingEndedStatus.loaded) {
          emit(DownloadTracksCollectionAllTracksGetted(
              tracksCollection: _tracksCollection!, tracks: _tracksGettingResponseList));
        } else {
          emit(DownloadTracksCollectionTracksGettingCancelled());
        }
      } else {
        if (event.result.failure is NetworkFailure) {
          emit(DownloadTracksCollectionTracksGettingNetworkFailure(
              tracksCollection: _tracksCollection!, tracks: _tracksGettingResponseList));
        } else {
          emit(DownloadTracksCollectionFailure(failure: event.result.failure!));
        }
      }
    });

    on<DownloadTracksCollectionTracksPartGetted>((event, emit) {
      emit(DownloadTracksCollectionOnTracksPartGetted(
          tracksCollection: _tracksCollection!, tracks: _tracksGettingResponseList));
    });

    on<DownloadTracksCollectionCancelTracksGetting>((event, emit) {
      _tracksGettingController?.cancelGetting();
    });
  }
}

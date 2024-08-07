import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/history_tracks_collections/domain/use_cases/add_tracks_collection_to_history.dart';

part 'get_tracks_collection_event.dart';
part 'get_tracks_collection_state.dart';

abstract class GetTracksCollectionBloc extends Bloc<GetTracksCollectionEvent, GetTracksCollectionState> {
  final AddTracksCollectionToHistory _addTracksCollectionToHistory;

  TracksCollection? _loadedTracksCollection;
  bool _isTracksCollectionLoading = false;

  GetTracksCollectionBloc({required AddTracksCollectionToHistory addTracksCollectionToHistory})
      : _addTracksCollectionToHistory = addTracksCollectionToHistory,
        super(GetTracksCollectionLoading()) {
    on<GetTracksCollectionLoad>(_onLoad);
  }

  Future<void> _onLoad(GetTracksCollectionLoad event, Emitter<GetTracksCollectionState> emit) async {
    if (_isTracksCollectionLoading) {
      return;
    }

    emit(GetTracksCollectionLoading());

    _isTracksCollectionLoading = true;
    final loadTracksCollectionResult = await loadTracksCollection();

    if (loadTracksCollectionResult.isSuccessful) {
      _loadedTracksCollection = loadTracksCollectionResult.result!;
      _addTracksCollectionToHistory.call(_loadedTracksCollection!);

      emit(GetTracksCollectionLoaded(tracksCollection: _loadedTracksCollection!));
    } else {
      if (loadTracksCollectionResult.failure is NetworkFailure) {
        emit(GetTracksCollectionNetworkFailure());
      } else {
        emit(GetTracksCollectionFatalFailure(failure: loadTracksCollectionResult.failure));
      }
    }
    _isTracksCollectionLoading = false;
  }

  Future<Result<Failure, TracksCollection>> loadTracksCollection();
}

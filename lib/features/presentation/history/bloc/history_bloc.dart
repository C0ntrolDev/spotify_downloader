import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/history_tracks_collectons/use_cases/get_ordered_history.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetOrderedHistory _getOrderedHistory;

  HistoryBloc({required GetOrderedHistory getOrderedHistory})
      : _getOrderedHistory = getOrderedHistory,
        super(HistoryBlocLoading()) {
    on<HistoryBlocLoadHistory>((event, emit) async {
      emit(HistoryBlocLoading());
      final getOrderedHistoryResult = await _getOrderedHistory.call(null);
      if (getOrderedHistoryResult.isSuccessful) {
        emit(HistoryBlocLoaded(historyTracksCollections: getOrderedHistoryResult.result ?? List.empty()));
      }
    });
  }
}

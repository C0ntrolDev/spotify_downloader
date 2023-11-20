import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/use_cases/add_tracks_collection_to_history.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/use_cases/get_ordered_history.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetOrderedHistory _getOrderedHistory;
  

  HomeBloc({required GetOrderedHistory getOrderedHistory, required AddHistoryTracksCollectionToHistory addTracksCollectionToHistory})
      : _getOrderedHistory = getOrderedHistory,
        super(HomeInitial()) {

    on<HomeLoad>((event, emit) async {
      var result = await _getOrderedHistory.call(null);
      if (result.isSuccessful) {
        emit(HomeLoaded(tracksCollectionsHistory: result.result));
      }
    });
  }
}

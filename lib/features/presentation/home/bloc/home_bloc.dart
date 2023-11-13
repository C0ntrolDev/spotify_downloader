import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/features/domain/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/use_cases/add_tracks_collection_to_history.dart';
import 'package:spotify_downloader/features/domain/use_cases/get_ordered_history.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetOrderedHistory _getOrderedHistory;
  final AddTracksCollectionToHistory _addTracksCollectionToHistory;

  HomeBloc({required GetOrderedHistory getOrderedHistory, required AddTracksCollectionToHistory addTracksCollectionToHistory})
      : _getOrderedHistory = getOrderedHistory,
        _addTracksCollectionToHistory = addTracksCollectionToHistory,
        super(HomeInitial()) {

    on<HomeLoad>((event, emit) async {
      var result = await _getOrderedHistory.call(null);
      if (result.isSuccessful) {
        emit(HomeLoaded(tracksCollectionsHistory: result.result));
      }
    });

    on<HomeAddTracksCollectionToHistory>((event, emit) async {
      await _addTracksCollectionToHistory.call(event.tracksCollection);
      add(HomeLoad());
    });
  }
}

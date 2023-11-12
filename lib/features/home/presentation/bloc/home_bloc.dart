import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/features/home/domain/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/home/domain/use_cases/add_tracks_collection_to_history.dart';
import 'package:spotify_downloader/features/home/domain/use_cases/get_ordered_history.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetOrderedHistory _getOrderedHistory;
  final AddTracksCollectionToHistory _addPlaylistToHistory;

  HomeBloc({required GetOrderedHistory getOrderedHistory, required AddTracksCollectionToHistory addPlaylistToHistory})
      : _getOrderedHistory = getOrderedHistory,
        _addPlaylistToHistory = addPlaylistToHistory,
        super(HomeInitial()) {

    on<HomeLoad>((event, emit) async {
      var result = await _getOrderedHistory.call(null);
      if (result.isSuccessful) {
        emit(HomeLoaded(playlistsHistory: result.result));
      }
    });

    on<HomeAddPlaylistToHistory>((event, emit) async {
      await _addPlaylistToHistory.call(event.playlist);
      add(HomeLoad());
    });
  }
}

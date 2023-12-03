import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/use_cases/add_tracks_collection_to_history.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required AddHistoryTracksCollectionToHistory addTracksCollectionToHistory}) : super(HomeInitial()) {
    on<HomeLoad>((event, emit) async {});
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/entities/track_with_loading_observer.dart';

part 'filter_tracks_event.dart';
part 'filter_tracks_state.dart';

class FilterTracksBloc extends Bloc<FilterTracksEvent, FilterTracksState> {
  String? _filterQuery;
  List<TrackWithLoadingObserver>? _tracksSource;

  FilterTracksBloc() : super(FilterTracksChanged(filteredTracks: List.empty(), isFilterQueryEmpty: true)) {
    on<FilterTracksChangeSource>((event, emit) {
      _tracksSource = event.newSource;
      emit(FilterTracksChanged(filteredTracks: getFilteredTracks(), isFilterQueryEmpty: _filterQuery?.isEmpty ?? true));
    });

    on<FilterTracksChangeFilterQuery>((event, emit) {
      _filterQuery = event.newQuery;
      emit(FilterTracksChanged(filteredTracks: getFilteredTracks(), isFilterQueryEmpty: _filterQuery?.isEmpty ?? true));
    });
  }

  List<TrackWithLoadingObserver> getFilteredTracks() {
    if (_tracksSource == null) {
      return List.empty();
    }

    return _tracksSource!.where((trackWithLoadingObserver) {
      if (_filterQuery == null || _filterQuery!.isEmpty) {
        return true;
      }

      return trackNameContainsValue(trackWithLoadingObserver, _filterQuery!) ||
          trackArtistsContainsValue(trackWithLoadingObserver, _filterQuery!);
    }).toList();
  }

  bool trackNameContainsValue(TrackWithLoadingObserver trackWithLoadingObserver, String value) =>
      trackWithLoadingObserver.track.name.toLowerCase().contains(value.toLowerCase());
  bool trackArtistsContainsValue(TrackWithLoadingObserver trackWithLoadingObserver, String value) =>
      trackWithLoadingObserver.track.artists
          ?.where((artist) => artist.toLowerCase().contains(value.toLowerCase()))
          .isNotEmpty ??
      false;
}

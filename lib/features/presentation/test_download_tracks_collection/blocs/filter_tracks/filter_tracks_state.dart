part of 'filter_tracks_bloc.dart';

sealed class FilterTracksState extends Equatable {
  const FilterTracksState();

  @override
  List<Object?> get props => [];
}

final class FilterTracksChanged extends FilterTracksState {
    const FilterTracksChanged({
    required this.filteredTracks,
    required this.isFilterQueryEmpty
  });

  
  final List<TrackWithLoadingObserver> filteredTracks;
  final bool isFilterQueryEmpty;

  @override
  List<Object?> get props => [filteredTracks, isFilterQueryEmpty];
}

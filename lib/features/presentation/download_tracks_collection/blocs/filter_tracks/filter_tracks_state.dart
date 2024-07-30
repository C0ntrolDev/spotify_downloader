part of 'filter_tracks_bloc.dart';

final class FilterTracksDeffault extends Equatable {
  const FilterTracksDeffault({required this.filteredTracks, required this.isFilterQueryEmpty});

  final List<TrackWithLoadingObserver> filteredTracks;
  final bool isFilterQueryEmpty;

  @override
  List<Object?> get props => [filteredTracks, isFilterQueryEmpty];
}

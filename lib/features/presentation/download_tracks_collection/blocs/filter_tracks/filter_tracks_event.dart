part of 'filter_tracks_bloc.dart';

sealed class FilterTracksEvent extends Equatable {
  const FilterTracksEvent();

  @override
  List<Object?> get props => [];
}

final class FilterTracksChangeSource extends FilterTracksEvent {
  const FilterTracksChangeSource({required this.newSource});

  final List<TrackWithLoadingObserver>? newSource;

  @override
  List<Object?> get props => [newSource];
}

final class FilterTracksChangeFilterQuery extends FilterTracksEvent {
  const FilterTracksChangeFilterQuery({required this.newQuery});

  final String? newQuery;

  @override
  List<Object?> get props => [newQuery];
}

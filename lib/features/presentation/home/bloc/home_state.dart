part of 'home_bloc.dart';

sealed class HomeState extends Equatable {}

final class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

final class HomeLoaded extends HomeState {
  HomeLoaded({required this.tracksCollectionsHistory});

  final List<TracksCollection>? tracksCollectionsHistory;

  @override
  List<Object?> get props => [tracksCollectionsHistory];
}

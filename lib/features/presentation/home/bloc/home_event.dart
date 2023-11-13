part of 'home_bloc.dart';


sealed class HomeEvent extends Equatable {}

class HomeLoad extends HomeEvent {

  @override
  List<Object?> get props => [];
}

class HomeUpdateHistory extends HomeEvent {

  @override
  List<Object?> get props => [];
}

class HomeAddTracksCollectionToHistory extends HomeEvent {
  HomeAddTracksCollectionToHistory({required this.tracksCollection});

  final TracksCollection tracksCollection;

  @override
  List<Object?> get props => [tracksCollection];
}
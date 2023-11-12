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

class HomeAddPlaylistToHistory extends HomeEvent {
  HomeAddPlaylistToHistory({required this.playlist});

  final TracksCollection playlist;

  @override
  List<Object?> get props => [playlist];
}
part of 'get_tracks_collection_bloc.dart';

sealed class GetTracksCollectionEvent extends Equatable {
  const GetTracksCollectionEvent();

  @override
  List<Object> get props => [];
}

final class GetTracksCollectionLoad extends GetTracksCollectionEvent {}

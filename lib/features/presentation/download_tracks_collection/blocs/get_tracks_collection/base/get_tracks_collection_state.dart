part of 'get_tracks_collection_bloc.dart';

sealed class GetTracksCollectionState extends Equatable {
  const GetTracksCollectionState();

  @override
  List<Object?> get props => [];
}

final class GetTracksCollectionLoading extends GetTracksCollectionState {}

final class GetTracksCollectionLoaded extends GetTracksCollectionState {
  const GetTracksCollectionLoaded({required this.tracksCollection});

  final TracksCollection tracksCollection;

  @override
  List<Object?> get props => [tracksCollection];
}

final class GetTracksCollectionFatalFailure extends GetTracksCollectionState {
  const GetTracksCollectionFatalFailure({required this.failure});

  final Failure? failure;

  @override
  List<Object?> get props => [failure];
}

final class GetTracksCollectionNetworkFailure extends GetTracksCollectionState {}

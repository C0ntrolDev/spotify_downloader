part of 'download_tracks_cubit.dart';

sealed class DownloadTracksState extends Equatable {
  const DownloadTracksState();

  @override
  List<Object?> get props => [];
}

final class DownloadTracksInitial extends DownloadTracksState {}

final class DownloadTracksFailure extends DownloadTracksState {
  const DownloadTracksFailure({required this.failure});

  final Failure? failure;

  @override
  List<Object?> get props => [failure];
}
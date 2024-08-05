part of 'change_source_video_bloc.dart';

sealed class ChangeSourceVideoState extends Equatable {
  const ChangeSourceVideoState();

  @override
  List<Object?> get props => [];
}

final class ChangeSourceVideoLoading extends ChangeSourceVideoState {}

final class ChangeSourceVideoLoaded extends ChangeSourceVideoState {
  const ChangeSourceVideoLoaded({required this.videos, required this.selectedVideo, required this.isVideoSelectedByUser});

  final List<Video> videos;
  final bool isVideoSelectedByUser;
  final Video? selectedVideo;

  @override
  List<Object?> get props => [videos, selectedVideo];
}

final class ChangeSourceVideoFailure extends ChangeSourceVideoState {
  const ChangeSourceVideoFailure({required this.failure});

  final Failure? failure;
}

final class ChangeSourceVideoNetworkFailure extends ChangeSourceVideoState {}

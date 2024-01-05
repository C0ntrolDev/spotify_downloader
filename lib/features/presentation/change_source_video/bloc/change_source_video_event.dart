part of 'change_source_video_bloc.dart';

sealed class ChangeSourceVideoEvent extends Equatable {
  const ChangeSourceVideoEvent();

  @override
  List<Object?> get props => [];
}

final class ChangeSourceVideoLoad extends ChangeSourceVideoEvent {
  const ChangeSourceVideoLoad({this.selectedVideoUrl});

  final String? selectedVideoUrl;
}

final class ChangeSourceVideoChangeSelectedVideo extends ChangeSourceVideoEvent {
  final Video? selectedVideo;

  const ChangeSourceVideoChangeSelectedVideo({this.selectedVideo});
}

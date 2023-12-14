part of 'download_track_info_bloc.dart';

sealed class DownloadTrackInfoEvent extends Equatable {
  const DownloadTrackInfoEvent();

  @override
  List<Object?> get props => [];
}

final class DownloadTrackInfoChangeYoutubeUrl extends DownloadTrackInfoEvent {
  const DownloadTrackInfoChangeYoutubeUrl({required this.youtubeUrl});

  final String youtubeUrl;

  @override
  List<Object?> get props => [youtubeUrl];
}
  
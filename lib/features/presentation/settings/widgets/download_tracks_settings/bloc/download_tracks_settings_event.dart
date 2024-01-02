part of 'download_tracks_settings_bloc.dart';

sealed class DownloadTracksSettingsEvent extends Equatable {
  const DownloadTracksSettingsEvent();

  @override
  List<Object?> get props => [];
}

final class DownloadTracksSettingsLoad extends DownloadTracksSettingsEvent {}

final class DownloadTracksSettingsChangeSavePath extends DownloadTracksSettingsEvent {
  const DownloadTracksSettingsChangeSavePath({required this.savePath});

  final String savePath;

  @override
  List<Object?> get props => [savePath];
}

final class DownloadTracksSettingsChangeSaveMode extends DownloadTracksSettingsEvent {
  const DownloadTracksSettingsChangeSaveMode({required this.saveMode});

  final SaveMode saveMode;

  @override
  List<Object?> get props => [saveMode];
}

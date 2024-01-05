part of 'download_tracks_settings_bloc.dart';

sealed class DownloadTracksSettingsState extends Equatable {
  const DownloadTracksSettingsState();

  @override
  List<Object?> get props => [];
}

final class DownloadTracksSettingsInitial extends DownloadTracksSettingsState {}

final class DownloadTracksSettingsChanged extends DownloadTracksSettingsState {
  const DownloadTracksSettingsChanged({required this.downloadTracksSettings});

  final DownloadTracksSettings downloadTracksSettings;

  @override
  List<Object?> get props => [downloadTracksSettings];
}

final class DownloadTracksSettingsFailure extends DownloadTracksSettingsState {
  const DownloadTracksSettingsFailure({required this.failure});

  final Failure? failure;
}

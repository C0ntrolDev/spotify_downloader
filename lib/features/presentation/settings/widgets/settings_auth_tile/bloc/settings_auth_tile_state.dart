part of 'settings_auth_tile_bloc.dart';

sealed class SettingsAuthTileState extends Equatable {
  const SettingsAuthTileState();

  @override
  List<Object?> get props => [];
}

final class SettingsAuthTileInitial extends SettingsAuthTileState {}

final class SettingsAuthTileAuthorized extends SettingsAuthTileState {
  const SettingsAuthTileAuthorized({required this.clientCredentials});

  final AuthorizedClientCredentials clientCredentials;

  @override
  List<Object?> get props => [clientCredentials];
}

final class SettingsAuthTileNotAuthorized extends SettingsAuthTileState {
  const SettingsAuthTileNotAuthorized({required this.clientCredentials});

  final ClientCredentials clientCredentials;

  @override
  List<Object?> get props => [clientCredentials];
}

final class SettingsAuthTileFailure extends SettingsAuthTileState {
  const SettingsAuthTileFailure({required this.failure});

  final Failure? failure;

  @override
  List<Object?> get props => [failure];
}

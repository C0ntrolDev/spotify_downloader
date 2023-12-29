part of 'settings_auth_tile_bloc.dart';

sealed class SettingsAuthTileEvent extends Equatable {
  const SettingsAuthTileEvent();

  @override
  List<Object> get props => [];
}

final class SettingsAuthTileLoad extends SettingsAuthTileEvent {}

final class SettingsAuthTileAuthorize extends SettingsAuthTileEvent {}

final class SettingsAuthTileLogOut extends SettingsAuthTileEvent {}

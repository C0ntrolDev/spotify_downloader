part of 'auth_settings_bloc.dart';

sealed class AuthSettingsEvent extends Equatable {
  const AuthSettingsEvent();

  @override
  List<Object> get props => [];
}

final class AuthSettingsLoad extends AuthSettingsEvent {}

final class AuthSettingsAuthorize extends AuthSettingsEvent {}

final class AuthSettingsLogOut extends AuthSettingsEvent {}

final class AuthSettingsChangeClientId extends AuthSettingsEvent {
  final String newClientId;

  const AuthSettingsChangeClientId({required this.newClientId});
}

final class AuthSettingsChangeClientSecret extends AuthSettingsEvent {
  final String newClientSecret;

  const AuthSettingsChangeClientSecret({required this.newClientSecret});
}
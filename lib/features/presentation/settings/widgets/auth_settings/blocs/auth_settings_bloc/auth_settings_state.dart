part of 'auth_settings_bloc.dart';

sealed class AuthSettingsState extends Equatable {
  const AuthSettingsState();

  @override
  List<Object?> get props => [];
}

final class AuthSettingsInitial extends AuthSettingsState {}

final class AuthSettingsLoaded extends AuthSettingsState {
  const AuthSettingsLoaded({required this.clientCredentials});

  final AuthorizedClientCredentials clientCredentials;

  @override
  List<Object?> get props => [clientCredentials];
}

final class AuthSettingsFailure extends AuthSettingsState {
  const AuthSettingsFailure({required this.failure});

  final Failure? failure;

  @override
  List<Object?> get props => [failure];
}

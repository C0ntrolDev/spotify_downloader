part of 'account_auth_bloc.dart';

sealed class AccountAuthState extends Equatable {
  const AccountAuthState();

  @override
  List<Object?> get props => [];
}

final class AccountAuthLoading extends AccountAuthState {}

final class AccountAuthAuthorized extends AccountAuthState {
  final SpotifyProfile profile;

  const AccountAuthAuthorized({required this.profile});

  @override
  List<Object?> get props => [profile];
}

final class AccountAuthNotAuthorized extends AccountAuthState {}

final class AccountAuthNetworkFailure extends AccountAuthState {}

final class AccountAuthFailure extends AccountAuthState {
  final Failure? failure;

  const AccountAuthFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class AccountAuthInvalidCredentialsFailure extends AccountAuthFailure {
  const AccountAuthInvalidCredentialsFailure({required super.failure});
}

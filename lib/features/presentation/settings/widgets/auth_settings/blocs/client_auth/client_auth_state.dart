part of 'client_auth_bloc.dart';

sealed class ClientAuthState extends Equatable {
  const ClientAuthState();

  @override
  List<Object?> get props => [];
}

final class ClientAuthInitial extends ClientAuthState {}

final class ClientAuthFailure extends ClientAuthState {
  const ClientAuthFailure({required this.failure});

  final Failure? failure;

  @override
  List<Object?> get props => [failure];
}

final class ClientAuthChanged extends ClientAuthState {
  const ClientAuthChanged({required this.clientCredentials});

  final ClientCredentials clientCredentials;

  @override
  List<Object?> get props => [clientCredentials];
}

part of 'client_auth_bloc.dart';

sealed class ClientAuthEvent extends Equatable {
  const ClientAuthEvent();

  @override
  List<Object?> get props => [];
}

final class ClientAuthLoad extends ClientAuthEvent {}

final class ClientAuthChangeClientId extends ClientAuthEvent {
  const ClientAuthChangeClientId({required this.clientId});

  final String clientId;

  @override
  List<Object?> get props => [clientId];
}

final class ClientAuthChangeClientSecret extends ClientAuthEvent {
  const ClientAuthChangeClientSecret({required this.clientSecret});

  final String clientSecret;

  @override
  List<Object?> get props => [clientSecret];
}

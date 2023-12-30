part of 'account_auth_status_bloc.dart';

sealed class AccountAuthStatusEvent extends Equatable {
  const AccountAuthStatusEvent();

  @override
  List<Object?> get props => [];
}

final class AccountAuthStatusChangeCredentials extends AccountAuthStatusEvent {
  const AccountAuthStatusChangeCredentials({required this.authorizedClientCredentials});

  final AuthorizedClientCredentials authorizedClientCredentials;

  @override
  List<Object?> get props => [authorizedClientCredentials];
}

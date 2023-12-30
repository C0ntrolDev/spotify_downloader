part of 'account_auth_status_bloc.dart';

sealed class AccountAuthStatusState extends Equatable {
  const AccountAuthStatusState();

  @override
  List<Object?> get props => [];
}

final class AccountAuthStatusLoading extends AccountAuthStatusState {}

final class AccountAuthStatusAuthorized extends AccountAuthStatusState {}

final class AccountAuthStatusNotAuthorized extends AccountAuthStatusState {}

final class AccountAuthStatusFailure extends AccountAuthStatusState {
  const AccountAuthStatusFailure({required this.failure});

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

final class AccountAuthStatusNetworkFailure extends AccountAuthStatusState {}

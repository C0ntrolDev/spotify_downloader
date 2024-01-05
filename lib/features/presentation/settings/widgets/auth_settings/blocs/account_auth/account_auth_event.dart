part of 'account_auth_bloc.dart';

sealed class AccountAuthEvent extends Equatable {
  const AccountAuthEvent();

  @override
  List<Object> get props => [];
}

class AccountAuthUpdate extends AccountAuthEvent {}

class AccountAuthAuthorize extends AccountAuthEvent {}

class AccountAuthLogOut extends AccountAuthEvent {}

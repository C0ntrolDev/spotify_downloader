import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/use_cases/get_local_auth_credentials.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/use_cases/save_local_auth_credentials.dart';
import 'package:spotify_downloader/features/domain/auth/network_auth/use_cases/authorize_user.dart';

import 'package:spotify_downloader/features/domain/shared/authorized_client_credentials.dart';

part 'auth_settings_event.dart';
part 'auth_settings_state.dart';

class AuthSettingsBloc extends Bloc<AuthSettingsEvent, AuthSettingsState> {
  final AuthorizeUser _authorizeUser;
  final GetLocalAuthCredentials _getLocalAuthCredentials;
  final SaveLocalAuthCredentials _saveLocalAuthCredentials;

  AuthorizedClientCredentials? _clientCredentials;

  AuthSettingsBloc(
      {required AuthorizeUser authorizeUser,
      required GetLocalAuthCredentials getLocalAuthCredentials,
      required SaveLocalAuthCredentials saveLocalAuthCredentials})
      : _authorizeUser = authorizeUser,
        _getLocalAuthCredentials = getLocalAuthCredentials,
        _saveLocalAuthCredentials = saveLocalAuthCredentials,
        super(AuthSettingsInitial()) {
    on<AuthSettingsLoad>(_onLoad);

    on<AuthSettingsAuthorize>(_onAuthorize);

    on<AuthSettingsLogOut>(_onLogOut);

    on<AuthSettingsChangeClientId>(_onChangeClientId);

    on<AuthSettingsChangeClientSecret>(_onChangeClientSecret);
  }

  FutureOr<void> _onLoad(event, emit) async {
    final getLocalAuthCredentialsResult = await _getLocalAuthCredentials.call(null);
    if (!getLocalAuthCredentialsResult.isSuccessful) {
      emit(AuthSettingsFailure(failure: getLocalAuthCredentialsResult.failure));
      return;
    }

    _clientCredentials = getLocalAuthCredentialsResult.result;
    emit(AuthSettingsLoaded(clientCredentials: _clientCredentials!));
  }

  FutureOr<void> _onAuthorize(event, emit) async {
    if (_clientCredentials == null) {
      emit(const AuthSettingsFailure(failure: Failure(message: 'for some reason client credentials == null')));
      return;
    }

    final authorizeResult = await _authorizeUser.call(_clientCredentials!);
    if (!authorizeResult.isSuccessful) {
      emit(AuthSettingsFailure(failure: authorizeResult.failure));
      return;
    }

    await _changeAndSaveClientCredentials(authorizeResult.result!, emit);
  }

  FutureOr<void> _onLogOut(event, emit) async {
    if (_clientCredentials == null || _clientCredentials!.refreshToken == null) {
      return;
    }

    await _changeAndSaveClientCredentials(
        AuthorizedClientCredentials(
            clientId: _clientCredentials!.clientId,
            clientSecret: _clientCredentials!.clientSecret,
            refreshToken: null),
        emit);
  }

  FutureOr<void> _onChangeClientId(event, emit) async {
    await _changeAndSaveClientCredentials(
        AuthorizedClientCredentials(
            clientId: event.newClientId,
            clientSecret: _clientCredentials!.clientSecret,
            refreshToken: _clientCredentials!.refreshToken),
        emit);
  }

  FutureOr<void> _onChangeClientSecret(event, emit) async {
    await _changeAndSaveClientCredentials(
        AuthorizedClientCredentials(
            clientId: _clientCredentials!.clientId,
            clientSecret: event.newClientSecret,
            refreshToken: _clientCredentials?.refreshToken),
        emit);
  }

  Future<void> _changeAndSaveClientCredentials(
      AuthorizedClientCredentials newClientCredentials, Emitter<AuthSettingsState> emit) async {
    _clientCredentials = newClientCredentials;
    emit(AuthSettingsLoaded(clientCredentials: _clientCredentials!));

    final saveCredentialsResult = await _saveLocalAuthCredentials.call(_clientCredentials!);
    if (!saveCredentialsResult.isSuccessful) {
      emit(AuthSettingsFailure(failure: saveCredentialsResult.failure));
    }
  }
}

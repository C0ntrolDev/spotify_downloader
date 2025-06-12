import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/features/data_domain/auth/local_auth/domain/use_cases/use_cases.dart';
import 'package:spotify_downloader/features/data_domain/auth/shared/client_credentials.dart';

part 'client_auth_event.dart';
part 'client_auth_state.dart';

class ClientAuthBloc extends Bloc<ClientAuthEvent, ClientAuthState> {
  final GetClientCredentials _getClientCredentials;
  final SaveClientCredentials _saveClientCredentials;

  ClientCredentials? currentCredentials;

  ClientAuthBloc(
      {required GetClientCredentials getClientCredentials, required SaveClientCredentials saveClientCredentials})
      : _getClientCredentials = getClientCredentials,
        _saveClientCredentials = saveClientCredentials,
        super(ClientAuthInitial()) {
    on<ClientAuthLoad>(_onLoad);

    on<ClientAuthChangeClientId>(_onChangeClientId);

    on<ClientAuthChangeClientSecret>(_onChangeClientSecret);
  }

    FutureOr<void> _onLoad(event, emit) async {
    if (currentCredentials != null) {
      emit(ClientAuthChanged(clientCredentials: currentCredentials!));
      return;
    }

    final getClientCredentialsResult = await _getClientCredentials.call(null);
    if (!getClientCredentialsResult.isSuccessful) {
      emit(ClientAuthFailure(failure: getClientCredentialsResult.failure));
      return;
    }

    currentCredentials = getClientCredentialsResult.result;
    emit(ClientAuthChanged(clientCredentials: currentCredentials!));
  }

  FutureOr<void> _onChangeClientSecret(ClientAuthChangeClientSecret event, Emitter<ClientAuthState> emit) async {
    await _onChangeClientCredentials(
        ClientCredentials(clientId: currentCredentials!.clientId, clientSecret: event.clientSecret), emit);
  }

  FutureOr<void> _onChangeClientId(ClientAuthChangeClientId event, Emitter<ClientAuthState> emit) async {
    await _onChangeClientCredentials(
        ClientCredentials(clientId: event.clientId, clientSecret: currentCredentials!.clientSecret), emit);
  }

  Future<void> _onChangeClientCredentials(
      ClientCredentials newClientCredentials, Emitter<ClientAuthState> emit) async {
    currentCredentials = newClientCredentials;
    emit(ClientAuthChanged(clientCredentials: currentCredentials!));

    final saveClientCredentialsResult = await _saveClientCredentials.call(currentCredentials!);
    if (!saveClientCredentialsResult.isSuccessful) {
      emit(ClientAuthFailure(failure: saveClientCredentialsResult.failure));
    }
  }
}

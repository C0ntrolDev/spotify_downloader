import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/use_cases/get_local_auth_credentials.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/use_cases/save_local_auth_credentials.dart';
import 'package:spotify_downloader/features/domain/auth/network_auth/use_cases/authorize_user.dart';
import 'package:spotify_downloader/features/domain/auth/shared/authorized_client_credentials.dart';
import 'package:spotify_downloader/features/domain/auth/shared/client_credentials.dart';

part 'settings_auth_tile_event.dart';
part 'settings_auth_tile_state.dart';

class SettingsAuthTileBloc extends Bloc<SettingsAuthTileEvent, SettingsAuthTileState> {
  final AuthorizeUser _authorizeUser;
  final GetLocalAuthCredentials _getLocalAuthCredentials;
  final SaveLocalAuthCredentials _saveLocalAuthCredentials;

  AuthorizedClientCredentials? _clientCredentials;

  SettingsAuthTileBloc(
      {required AuthorizeUser authorizeUser,
      required GetLocalAuthCredentials getLocalAuthCredentials,
      required SaveLocalAuthCredentials saveLocalAuthCredentials})
      : _authorizeUser = authorizeUser,
        _getLocalAuthCredentials = getLocalAuthCredentials,
        _saveLocalAuthCredentials = saveLocalAuthCredentials,
        super(SettingsAuthTileInitial()) {
    on<SettingsAuthTileLoad>((event, emit) async {
      final localAuthCredentialsResult = await _getLocalAuthCredentials.call(null);
      if (!localAuthCredentialsResult.isSuccessful) {
        emit(SettingsAuthTileFailure(failure: localAuthCredentialsResult.failure));
        return;
      }

      _clientCredentials = localAuthCredentialsResult.result;
      emit(_selectStateBasedOnClientCredentials(_clientCredentials!));
    });

    on<SettingsAuthTileAuthorize>((event, emit) async {
      if (_clientCredentials == null) {
        emit(const SettingsAuthTileFailure(failure: Failure(message: 'for some reason client credentials == null')));
        return;
      }

      final authorizeResult = await _authorizeUser.call(_clientCredentials!);
      if (!authorizeResult.isSuccessful) {
        emit(SettingsAuthTileFailure(failure: authorizeResult.failure));
        return;
      }

      _clientCredentials = authorizeResult.result;
      emit(_selectStateBasedOnClientCredentials(_clientCredentials!));

      final saveCredentialsResult = await _saveLocalAuthCredentials.call(_clientCredentials!);
      if (!saveCredentialsResult.isSuccessful) {
        emit(SettingsAuthTileFailure(failure: saveCredentialsResult.failure));
      }
    });
  }

  SettingsAuthTileState _selectStateBasedOnClientCredentials(AuthorizedClientCredentials clientCredentials) {
    if (_clientCredentials!.refreshToken != null) {
      return (SettingsAuthTileAuthorized(clientCredentials: clientCredentials));
    } else {
      return (SettingsAuthTileNotAuthorized(clientCredentials: clientCredentials));
    }
  }
}

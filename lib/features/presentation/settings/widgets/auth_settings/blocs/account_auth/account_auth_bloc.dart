import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/use_cases/delete_user_credentials.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/use_cases/get_client_credentials.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/use_cases/save_user_credentials.dart';
import 'package:spotify_downloader/features/domain/auth/network_auth/use_cases/authorize_user.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/entities/spotify_profile.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/use_cases/get_spotify_profile.dart';

part 'account_auth_event.dart';
part 'account_auth_state.dart';

class AccountAuthBloc extends Bloc<AccountAuthEvent, AccountAuthState> {
  final GetSpotifyProfile _getSpotifyProfile;
  final AuthorizeUser _authorizeUser;
  final DeleteUserCredentials _deleteUserCredentials;
  final SaveUserCredentials _saveUserCredentials;
  final GetClientCredentials _getClientCredentials;

  AccountAuthBloc(
      {required GetSpotifyProfile getSpotifyProfile,
      required AuthorizeUser authorizeUser,
      required DeleteUserCredentials deleteUserCredentials,
      required SaveUserCredentials saveUserCredentials,
      required GetClientCredentials getClientCredentials})
      : _getSpotifyProfile = getSpotifyProfile,
        _authorizeUser = authorizeUser,
        _deleteUserCredentials = deleteUserCredentials,
        _saveUserCredentials = saveUserCredentials,
        _getClientCredentials = getClientCredentials,
        super(AccountAuthLoading()) {
    on<AccountAuthAuthorize>(_onAuthorize);
    on<AccountAuthLogOut>(_onLogOut);
    on<AccountAuthUpdate>((_, emit)  async => await _onUpdate(emit));
  }

  FutureOr<void> _onAuthorize(event, Emitter<AccountAuthState> emit) async {
    final getClientCredentialsResult = await _getClientCredentials.call(null);
    if (!getClientCredentialsResult.isSuccessful) {
      emit(_getFailureState(getClientCredentialsResult.failure));
      return;
    }

    final authorizeUserResult = await _authorizeUser.call(getClientCredentialsResult.result!);
    if (!authorizeUserResult.isSuccessful) {
      emit(_getFailureState(getClientCredentialsResult.failure));
      return;
    }

    final saveUserCredentialsResult = await _saveUserCredentials.call(authorizeUserResult.result!);
    if (!saveUserCredentialsResult.isSuccessful) {
      emit(_getFailureState(getClientCredentialsResult.failure));
      return;
    }

    await _onUpdate(emit);
  }

  FutureOr<void> _onLogOut(event, Emitter<AccountAuthState> emit) async {
    final deleteUserCredentialsResult = await _deleteUserCredentials.call(null);
    if (!deleteUserCredentialsResult.isSuccessful) {
      emit(_getFailureState(deleteUserCredentialsResult.failure));
    }

    await _onUpdate(emit);
  }

  FutureOr<void> _onUpdate(Emitter<AccountAuthState> emit) async {
    emit(AccountAuthLoading());

    final getSpotifyProfileResult = await _getSpotifyProfile.call(null);
    if (getSpotifyProfileResult.isSuccessful) {
      emit(AccountAuthAuthorized(profile: getSpotifyProfileResult.result!));
    } else {
      emit(_getFailureState(getSpotifyProfileResult.failure));
    }
  }

  AccountAuthState _getFailureState(Failure? failure) {
    if (failure is NotAuthorizedFailure) {
      return AccountAuthNotAuthorized();
    }
    if (failure is InvalidClientCredentialsFailure || failure is InvalidAccountCredentialsFailure) {
      return AccountAuthInvalidCredentialsFailure(failure: failure);
    }
    if (failure is NetworkFailure) {
      return AccountAuthNetworkFailure();
    }
    return AccountAuthFailure(failure: failure);
  }
}

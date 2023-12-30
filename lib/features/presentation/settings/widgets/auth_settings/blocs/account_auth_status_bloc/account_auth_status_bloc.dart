import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/features/domain/shared/authorized_client_credentials.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/entities/spotify_profile.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/use_cases/get_spotify_profile.dart';

part 'account_auth_status_event.dart';
part 'account_auth_status_state.dart';

class AccountAuthStatusBloc extends Bloc<AccountAuthStatusEvent, AccountAuthStatusState> {
  final GetSpotifyProfile _getSpotifyProfile;

  AccountAuthStatusBloc({required GetSpotifyProfile getSpotifyProfile})
      : _getSpotifyProfile = getSpotifyProfile,
        super(AccountAuthStatusLoading()) {
    on<AccountAuthStatusChangeCredentials>((event, emit) async {
      if (event.clientCredentials.refreshToken == null) {
        emit(AccountAuthStatusNotAuthorized());
        return;
      }

      emit(AccountAuthStatusLoading());
      final getSpotifyProfileResult = await _getSpotifyProfile.call(event.clientCredentials);
      if (getSpotifyProfileResult.isSuccessful) {
        emit(AccountAuthStatusAuthorized(profile: getSpotifyProfileResult.result!));
      } else {
        if(getSpotifyProfileResult.failure is NetworkFailure) {
          emit(AccountAuthStatusNetworkFailure());
        } else if(getSpotifyProfileResult.failure is InvalidAuthCredentialsFailure || getSpotifyProfileResult.failure is InvalidRefreshTokenFailure){
          emit(AccountAuthStatuInvalidAuthCredentialsFailure());
        } else{
          emit(AccountAuthStatusFailure(failure: getSpotifyProfileResult.failure));
        }
      }
    });
  }
}



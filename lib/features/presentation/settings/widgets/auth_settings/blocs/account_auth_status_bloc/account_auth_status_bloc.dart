import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/features/domain/shared/authorized_client_credentials.dart';


part 'account_auth_status_event.dart';
part 'account_auth_status_state.dart';

class AccountAuthStatusBloc extends Bloc<AccountAuthStatusEvent, AccountAuthStatusState> {


  AccountAuthStatusBloc() : super(AccountAuthStatusLoading()) {
    on<AccountAuthStatusChangeCredentials>((event, emit) {
      if(event.authorizedClientCredentials.refreshToken == null) {
        emit(AccountAuthStatusNotAuthorized());
      }
    });
  }
}

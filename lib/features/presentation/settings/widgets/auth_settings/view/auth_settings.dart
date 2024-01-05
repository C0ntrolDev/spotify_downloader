import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/auth_settings/blocs/account_auth/account_auth_bloc.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/auth_settings/blocs/client_auth/client_auth_bloc.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/setting_with_text_field.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/settings_group.dart';
import 'package:spotify_downloader/generated/l10n.dart';

class AuthSettings extends StatefulWidget {
  const AuthSettings({super.key});

  @override
  State<AuthSettings> createState() => _AuthSettingsState();
}

class _AuthSettingsState extends State<AuthSettings> {
  final ClientAuthBloc _clientAuthBloc = injector.get<ClientAuthBloc>();
  final AccountAuthBloc _accountAuthBloc = injector.get<AccountAuthBloc>();

  @override
  void initState() {
    _clientAuthBloc.add((ClientAuthLoad()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      child: BlocListener<ClientAuthBloc, ClientAuthState>(
          listener: (context, state) {
            if (state is ClientAuthFailure) {
              showSmallTextSnackBar(state.failure.toString(), context);
            }

            if (state is ClientAuthChanged) {
              _accountAuthBloc.add(AccountAuthUpdate());
            }
          },
          bloc: _clientAuthBloc,
          child: SettingsGroup(header: S.of(context).spotifySDKAndAccount, settings: [
            BlocBuilder<ClientAuthBloc, ClientAuthState>(
              bloc: _clientAuthBloc,
              buildWhen: (previous, current) => current is! ClientAuthFailure,
              builder: (context, state) {
                if (state is! ClientAuthChanged) return Container();

                return SettingWithTextField(
                  title: 'Client Id',
                  value: state.clientCredentials.clientId,
                  onChangedValueSubmitted: (newClientId) {
                    _clientAuthBloc.add(ClientAuthChangeClientId(clientId: newClientId));
                  },
                );
              },
            ),
            BlocBuilder<ClientAuthBloc, ClientAuthState>(
              bloc: _clientAuthBloc,
              buildWhen: (previous, current) => current is! ClientAuthFailure,
              builder: (context, state) {
                if (state is! ClientAuthChanged) return Container();

                return SettingWithTextField(
                  title: 'Client Secret',
                  value: state.clientCredentials.clientSecret,
                  onChangedValueSubmitted: (newClientSecret) {
                    _clientAuthBloc.add(ClientAuthChangeClientSecret(clientSecret: newClientSecret));
                  },
                );
              },
            ),
            BlocConsumer<AccountAuthBloc, AccountAuthState>(
              listener: (context, state) {
                if (state is AccountAuthFailure) {
                  if (state.failure is! AuthFailure) {
                    showSmallTextSnackBar(state.failure.toString(), context);
                  }
                }

                if (state is AccountAuthInvalidCredentialsFailure) {
                  showSmallTextSnackBar(state.failure.toString(), context);
                }
              },
              bloc: _accountAuthBloc,
              buildWhen: (previous, current) => current is! AccountAuthFailure,
              builder: (context, state) {
                if (state is AccountAuthFailure) return Container();

                return SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Expanded(
                        child: Builder(builder: (context) {
                          switch (state) {
                            case AccountAuthLoading():
                              return Text(S.of(context).accountInformationIsBeingLoaded, maxLines: 2);
                            case AccountAuthAuthorized():
                              return Row(
                                children: [
                                  ClipOval(
                                      child: SizedBox.fromSize(
                                          size: const Size.fromRadius(13),
                                          child: Image.network(state.profile.pictureUrl, fit: BoxFit.cover))),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(state.profile.name, maxLines: 2),
                                    ),
                                  )
                                ],
                              );
                            case AccountAuthNotAuthorized():
                              return Text(S.of(context).youAreNotLoggedInToYourAccount, maxLines: 2);
                            case AccountAuthFailure():
                              return Text(S.of(context).unknownError, maxLines: 2);
                            case AccountAuthNetworkFailure():
                              return Text(S.of(context).connectionError, maxLines: 2);
                            case AccountAuthInvalidCredentialsFailure():
                              return Text(S.of(context).couldntLogInToYourAccount, maxLines: 2);
                          }
                        }),
                      ),
                       Builder(builder: (context) {
                        if (state is AccountAuthLoading) {
                          return const Center(
                              child: SizedBox(
                                  width: 23,
                                  height: 23,
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                    strokeWidth: 3,
                                  )));
                        }

                        late final String buttonText;
                        late final void Function() onButtonClicked;

                        if (state is AccountAuthAuthorized || state is AccountAuthNetworkFailure) {
                          buttonText = S.of(context).logOut;
                          onButtonClicked = () => _accountAuthBloc.add(AccountAuthLogOut());
                        } else {
                          buttonText = S.of(context).logIn;
                          onButtonClicked = () => _accountAuthBloc.add(AccountAuthAuthorize());
                        }

                        return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryColor,
                              side: const BorderSide(width: 1, color: primaryColor),
                            ),
                            onPressed: onButtonClicked,
                            child: Text(
                              buttonText,
                              style: theme.textTheme.bodySmall?.copyWith(color: primaryColor),
                            ));
                      }),
                    ],
                  ),
                );
              },
            )
          ])),
    );
  }
}

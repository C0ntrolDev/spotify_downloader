import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/auth_settings/blocs/account_auth_status_bloc/account_auth_status_bloc.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/auth_settings/blocs/auth_settings_bloc/auth_settings_bloc.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/setting_with_text_field.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/settings_group.dart';

class AuthSettings extends StatefulWidget {
  const AuthSettings({super.key});

  @override
  State<AuthSettings> createState() => _AuthSettingsState();
}

class _AuthSettingsState extends State<AuthSettings> {
  final AuthSettingsBloc _mainAuthBloc = injector.get<AuthSettingsBloc>();
  final AccountAuthStatusBloc _accountAuthStatusBloc = injector.get<AccountAuthStatusBloc>();

  @override
  void initState() {
    _mainAuthBloc.add(AuthSettingsLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      child: BlocListener<AuthSettingsBloc, AuthSettingsState>(
          listener: (context, state) {
            if (state is AuthSettingsFailure) {
              showSmallTextSnackBar(state.failure.toString(), context);
            }

            if (state is AuthSettingsLoaded) {
              print(state.clientCredentials.refreshToken);
              _accountAuthStatusBloc
                  .add(AccountAuthStatusChangeCredentials(clientCredentials: state.clientCredentials));
            }
          },
          bloc: _mainAuthBloc,
          child: SettingsGroup(header: 'SpotifySDK и Аккаунт', settings: [
            BlocBuilder<AuthSettingsBloc, AuthSettingsState>(
              bloc: _mainAuthBloc,
              buildWhen: (previous, current) => current is! AuthSettingsFailure,
              builder: (context, state) {
                if (state is! AuthSettingsLoaded) return Container();

                return SettingWithTextField(
                  title: 'Client Id',
                  value: state.clientCredentials.clientId,
                  onValueSubmitted: (newClientId) {
                    _mainAuthBloc.add(AuthSettingsChangeClientId(newClientId: newClientId));
                  },
                );
              },
            ),
            BlocBuilder<AuthSettingsBloc, AuthSettingsState>(
              bloc: _mainAuthBloc,
              buildWhen: (previous, current) => current is! AuthSettingsFailure,
              builder: (context, state) {
                if (state is! AuthSettingsLoaded) return Container();

                return SettingWithTextField(
                  title: 'Client Secret',
                  value: state.clientCredentials.clientSecret,
                  onValueSubmitted: (newClientSecret) {
                    _mainAuthBloc.add(AuthSettingsChangeClientSecret(newClientSecret: newClientSecret));
                  },
                );
              },
            ),
            BlocConsumer<AccountAuthStatusBloc, AccountAuthStatusState>(
              listener: (context, state) {
                if (state is AccountAuthStatusFailure) {
                  showSmallTextSnackBar(state.failure.toString(), context);
                }
              },
              bloc: _accountAuthStatusBloc,
              builder: (context, state) {
                if (state is AccountAuthStatusLoading) {
                  return const Text('Информация об аккаунте загружается');
                }

                if (state is AccountAuthStatusNotAuthorized) {
                  return Row(
                    children: [
                      const Expanded(child: Text('Вы не вошли в аккаунт')),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryColor,
                            side: const BorderSide(width: 1, color: primaryColor),
                          ),
                          onPressed: () {
                            _mainAuthBloc.add(AuthSettingsAuthorize());
                          },
                          child: Text(
                            'Войти в аккаунт',
                            style: theme.textTheme.bodySmall?.copyWith(color: primaryColor),
                          ))
                    ],
                  );
                }

                return Container();
              },
            )
          ])),
    );
  }
}

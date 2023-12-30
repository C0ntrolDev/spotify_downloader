import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/core/di/injector.dart';
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


  @override
  void initState() {
    _mainAuthBloc.add(AuthSettingsLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocConsumer<AuthSettingsBloc, AuthSettingsState>(
        listener: (context, state) {
          if (state is AuthSettingsFailure) {
            showSmallTextSnackBar(state.failure.toString(), context);
          }
        },
        bloc: _mainAuthBloc,
        buildWhen: (previous, current) => current is! AuthSettingsFailure,
        builder: (context, state) {
          if (state is AuthSettingsLoaded) {
            return SettingsGroup(header: 'SpotifySDK и Аккаунт', settings: [
              SettingWithTextField(
                title: 'Client Id',
                value: state.clientCredentials.clientId,
                onValueSubmitted: (newClientId) {
                  _mainAuthBloc.add(AuthSettingsChangeClientId(newClientId: newClientId));
                },
              ),
              SettingWithTextField(
                title: 'Client Secret',
                value: state.clientCredentials.clientSecret,
                onValueSubmitted: (newClientSecret) {
                  _mainAuthBloc.add(AuthSettingsChangeClientSecret(newClientSecret: newClientSecret));
                },
              )
            ]);
          }

          return Container();
        },
      ),
    );
  }
}


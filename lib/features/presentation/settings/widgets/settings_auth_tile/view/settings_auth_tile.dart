import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/settings_auth_tile/bloc/settings_auth_tile_bloc.dart';

class SettingsAuthTile extends StatefulWidget {
  const SettingsAuthTile({super.key});

  @override
  State<SettingsAuthTile> createState() => _SettingsAuthTileState();
}

class _SettingsAuthTileState extends State<SettingsAuthTile> {
  final SettingsAuthTileBloc _bloc = injector.get<SettingsAuthTileBloc>();

  @override
  void initState() {
    _bloc.add(SettingsAuthTileLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          BlocBuilder<SettingsAuthTileBloc, SettingsAuthTileState>(
            bloc: _bloc,
            builder: (context, state) {
              if (state is SettingsAuthTileAuthorized) {
                return Text('Загружено ${state.clientCredentials.refreshToken} | ${state.clientCredentials.clientId}');
              }

              if (state is SettingsAuthTileNotAuthorized) {
                  return Text('${state.clientCredentials.clientId}');
              }

              if (state is SettingsAuthTileFailure) {
                return Text(state.failure.toString());
              }
      
              return Container();
            },
          ),
          ElevatedButton(
              onPressed: () {
                _bloc.add(SettingsAuthTileAuthorize());
              },
              child: Text('войти'))
        ],
      ),
    );
  }
}

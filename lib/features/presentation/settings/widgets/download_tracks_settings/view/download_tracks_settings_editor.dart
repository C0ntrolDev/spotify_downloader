import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/domain/settings/enitities/save_mode.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/download_tracks_settings/bloc/download_tracks_settings_bloc.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/setting_with_text_field.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/settings_group.dart';

class DownloadTracksSettingsEditor extends StatefulWidget {
  const DownloadTracksSettingsEditor({super.key});

  @override
  State<DownloadTracksSettingsEditor> createState() => _DownloadTracksSettingsEditorState();
}

class _DownloadTracksSettingsEditorState extends State<DownloadTracksSettingsEditor> {
  final DownloadTracksSettingsBloc _bloc = injector.get<DownloadTracksSettingsBloc>();

  bool isSwitchEnabled = false;

  @override
  void initState() {
    _bloc.add(DownloadTracksSettingsLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DownloadTracksSettingsBloc, DownloadTracksSettingsState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is DownloadTracksSettingsFailure) {
          showSmallTextSnackBar(state.failure.toString(), context);
        }
      },
      buildWhen: (previous, current) => current is DownloadTracksSettingsChanged,
      builder: (context, state) {
        if (state is! DownloadTracksSettingsChanged) return Container();
        return SettingsGroup(
          header: 'Загрузка',
          settings: [
            Row(
              children: [
                Expanded(
                    child: SettingWithTextField(
                  key: ObjectKey(state.downloadTracksSettings.savePath),
                  title: 'Место хранения',
                  value: state.downloadTracksSettings.savePath,
                  onChangedValueSubmitted: (newSavePath) {
                    _bloc.add(DownloadTracksSettingsChangeSavePath(savePath: newSavePath));
                  },
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    color: onBackgroundSecondaryColor,
                    icon: const Icon(Icons.folder),
                    onPressed: () async {
                      String? selectedDiredtoryPath = await FilePicker.platform.getDirectoryPath();
                      if (selectedDiredtoryPath != null) {
                        _bloc.add(DownloadTracksSettingsChangeSavePath(savePath: selectedDiredtoryPath));
                      }
                    },
                  ),
                ),
              ],
            ),
            SettingWithSwitch(
                value: state.downloadTracksSettings.saveMode == SaveMode.folderForAll,
                onValueChanged: (newValue) {
                  if (newValue) {
                    _bloc.add(const DownloadTracksSettingsChangeSaveMode(saveMode: SaveMode.folderForAll));
                  } else {
                    _bloc
                        .add(const DownloadTracksSettingsChangeSaveMode(saveMode: SaveMode.folderForTracksCollection));
                  }
                },
                title: 'Сохранять все в одной папке')
          ],
        );
      },
    );
  }
}

class SettingWithSwitch extends StatefulWidget {
  const SettingWithSwitch({super.key, required this.value, required this.onValueChanged, required this.title});

  final bool value;
  final String title;
  final void Function(bool) onValueChanged;

  @override
  State<SettingWithSwitch> createState() => _SettingWithSwitchState();
}

class _SettingWithSwitchState extends State<SettingWithSwitch> {
  bool value = false;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 5,
          ),
        ),
        const SizedBox(width: 10),
        Switch(
            value: value,
            onChanged: (newValue) {
              value = newValue;
              widget.onValueChanged.call(newValue);
              setState(() {});
            })
      ],
    );
  }
}

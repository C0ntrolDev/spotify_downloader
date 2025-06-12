import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/spotify_downloader_app.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/language_setting/bloc/language_setting_bloc.dart';
import 'package:spotify_downloader/features/presentation/shared/other/show_failure_snackbar.dart';
import 'package:spotify_downloader/generated/l10n.dart';

class LanguageSetting extends StatefulWidget {
  const LanguageSetting({super.key});

  @override
  State<LanguageSetting> createState() => _LanguageSettingState();
}

class _LanguageSettingState extends State<LanguageSetting> {
  final LanguageSettingBloc _bloc = injector.get<LanguageSettingBloc>();

  @override
  void initState() {
    _bloc.add(LanguageSettingLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer(
        bloc: _bloc,
        listener: (previous, current) {
          if (current is LanguageSettingFailure) {
            showFailureSnackBar(context, current.failure.toString());
          }
        },
        buildWhen: (previous, current) => current is LanguageSettingChanged,
        builder: (context, state) {
          if (state is! LanguageSettingChanged) return Container();
          return Row(
            children: [
              Expanded(child: Text(S.of(context).language)),
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  items: state.availableLanguages
                      .map((String language) => DropdownMenuItem<String>(
                            value: language,
                            child: Text(formatLanguage(language), style: theme.textTheme.bodyMedium),
                          ))
                      .toList(),
                  value: state.selectedLanguage,
                  onChanged: (String? newLanguage) {
                    setState(() {
                      if (newLanguage != null) {
                        _bloc.add(LanguageSettingChangeLanguage(language: newLanguage));
                        SpotifyDownloaderApp.setLanguage(context, newLanguage);
                      }
                    });
                  },
                  dropdownStyleData: const DropdownStyleData(
                      decoration:
                          BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.all(Radius.circular(5))),
                      elevation: 0),
                  buttonStyleData: ButtonStyleData(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    overlayColor: WidgetStateProperty.resolveWith((state) {
                      if (state.contains(WidgetState.pressed)) {
                        return onSurfaceSplashColor;
                      }

                      return null;
                    }),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    height: 40, 
                    width: 120,
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    overlayColor: WidgetStateProperty.resolveWith((state) {
                      if (state.contains(WidgetState.pressed)) {
                        return onSurfaceSplashColor;
                      }

                      return null;
                    }),
                    height: 40,
                  )
                ),
              ),
            ],
          );
        });
  }

  String formatLanguage(String language) {
    if (language == 'en') return 'English';
    if (language == 'ru') return 'Русский';
    return language;
  }
}

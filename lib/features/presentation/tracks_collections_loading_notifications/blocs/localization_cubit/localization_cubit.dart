import 'dart:async';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/use_cases/get_language_changed_stream.dart';
import 'package:spotify_downloader/features/data_domain/settings/settings.dart';
import 'package:spotify_downloader/l10n/app_localizations.dart';

part 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  final GetLanguage _getLanguage;
  final GetLanguageChangedStream _getLanguageChangedStream;

  StreamSubscription<String>? _languageChangedSubscription;
  static const String _deffaultLanguage = 'en';

  LocalizationCubit({
    required GetLanguage getLanguage,
    required GetLanguageChangedStream getLanguageChangedStream,
  })  : _getLanguage = getLanguage,
        _getLanguageChangedStream = getLanguageChangedStream,
        super(LocalizationInitial());

  @override
  Future<void> close() async {
    await _languageChangedSubscription?.cancel();
    return super.close();
  }

  Future<void> loadLanguage() async {
    final getLanguageResult = await _getLanguage.call(null);
    final language = getLanguageResult.isSuccessful ? getLanguageResult.result! : _deffaultLanguage;
    final localization = await AppLocalizations.delegate.load(Locale(language));

    emit(LocalizationLoaded(localization: localization));

    final getLanguageChangedStreamResult = await _getLanguageChangedStream.call(null);
    if (getLanguageChangedStreamResult.isSuccessful) {
      _languageChangedSubscription = getLanguageChangedStreamResult.result!.listen(_languageChanged);
    }
  }

  Future<void> _languageChanged(String newLanguage) async {
    final newLocalization = await AppLocalizations.delegate.load(Locale(newLanguage));
    emit(LocalizationLoaded(localization: newLocalization));
  }
}

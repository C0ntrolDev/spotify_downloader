import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/use_cases/get_language_changed_stream.dart';
import 'package:spotify_downloader/features/data_domain/settings/settings.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final GetLanguage _getLanguage;
  final GetLanguageChangedStream _getLanguageChangedStream;

  StreamSubscription<String>? _languageChangedSubscription;
  static const String _deffaultLanguage = 'en';

  LanguageCubit({
    required GetLanguage getLanguage,
    required GetLanguageChangedStream getLanguageChangedStream,
  })  : _getLanguage = getLanguage,
        _getLanguageChangedStream = getLanguageChangedStream,
        super(LanguageLoaded(language: _deffaultLanguage));

  @override
  Future<void> close() async {
    await _languageChangedSubscription?.cancel();
    return super.close();
  }

  Future<void> loadLanguage() async {
    final getLanguageResult = await _getLanguage.call(null);
    final language = getLanguageResult.isSuccessful ? getLanguageResult.result! : _deffaultLanguage;
    emit(LanguageLoaded(language: language));

    final getLanguageChangedStreamResult = await _getLanguageChangedStream.call(null);
    if (getLanguageChangedStreamResult.isSuccessful) {
      _languageChangedSubscription = getLanguageChangedStreamResult.result!.listen(_languageChanged);
    }
  }

  void _languageChanged(String newLanguage) {
    emit(LanguageLoaded(language: newLanguage));
  }
}

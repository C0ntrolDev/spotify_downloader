import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/use_cases/get_language_changed_stream.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final GetLanguage _getLanguage;
  final GetLanguageChangedStream _getLanguageChangedStream;

  StreamSubscription? _languageChangedStreamSubscription;

  LanguageCubit({required GetLanguage getLanguage, required GetLanguageChangedStream getLanguageChangedStream})
      : _getLanguage = getLanguage,
        _getLanguageChangedStream = getLanguageChangedStream,
        super(LanguageInitial());

  @override
  Future<void> close() async {
    await _languageChangedStreamSubscription?.cancel();
    return super.close();
  }

  Future<void> loadLanguage() async {
    final getLanguageResult = await _getLanguage.call(null);
    if (getLanguageResult.isSuccessful) {
      emit(LanguageLoaded(language: getLanguageResult.result!));
    }

    final getLanguageChangedStreamResult = await _getLanguageChangedStream.call(null);
    if (getLanguageChangedStreamResult.isSuccessful) {
      _languageChangedStreamSubscription = getLanguageChangedStreamResult.result!.listen(_onLanguageChanged);
    }
  }

  Future<void> _onLanguageChanged(String newLanguage) async {
    emit(LanguageLoaded(language: newLanguage));
  }
}

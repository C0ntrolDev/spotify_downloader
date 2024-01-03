part of 'language_setting_bloc.dart';

sealed class LanguageSettingEvent extends Equatable {
  const LanguageSettingEvent();

  @override
  List<Object?> get props => [];
}

final class LanguageSettingLoad extends LanguageSettingEvent {}

final class LanguageSettingChangeLanguage extends LanguageSettingEvent {
  const LanguageSettingChangeLanguage({required this.language});

  final String language;

  @override
  List<Object?> get props => [language];
}

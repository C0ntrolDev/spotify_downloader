part of 'language_setting_bloc.dart';

sealed class LanguageSettingState extends Equatable {
  const LanguageSettingState();

  @override
  List<Object?> get props => [];
}

final class LanguageSettingInitial extends LanguageSettingState {}

final class LanguageSettingChanged extends LanguageSettingState {
  const LanguageSettingChanged({required this.availableLanguages, required this.selectedLanguage});

  final List<String> availableLanguages;
  final String selectedLanguage;

  @override
  List<Object?> get props => [availableLanguages, selectedLanguage];
}

final class LanguageSettingFailure extends LanguageSettingState {
  final Failure? failure;

  const LanguageSettingFailure({required this.failure});
}

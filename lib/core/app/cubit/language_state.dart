part of 'language_cubit.dart';

sealed class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}

final class LanguageLoaded extends LanguageState {
  final String language;

  const LanguageLoaded({required this.language});

  @override
  List<Object> get props => [language];
}

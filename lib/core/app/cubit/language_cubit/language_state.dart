part of "language_cubit.dart";

sealed class LanguageState extends Equatable {
  @override
  List<Object> get props => [];
}

final class LanguageInitial extends LanguageState {}

final class LanguageLoaded extends LanguageState {
  final String language;

  LanguageLoaded({required this.language});

  @override
  List<Object> get props => [language];
}

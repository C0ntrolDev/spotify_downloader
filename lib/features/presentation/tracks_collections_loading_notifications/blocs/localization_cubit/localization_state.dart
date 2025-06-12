part of 'localization_cubit.dart';

sealed class LocalizationState extends Equatable {
  const LocalizationState();

  @override
  List<Object> get props => [];
}

final class LocalizationInitial extends LocalizationState { }

final class LocalizationLoaded extends LocalizationState {
  final AppLocalizations localization;

  const LocalizationLoaded({required this.localization});

  @override
  List<Object> get props => [localization];
}

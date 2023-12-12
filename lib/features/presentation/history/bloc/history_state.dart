part of 'history_bloc.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

final class HistoryBlocLoading extends HistoryState {}

final class HistoryBlocLoaded extends HistoryState {
  const HistoryBlocLoaded({required this.historyTracksCollections});

  final List<HistoryTracksCollection> historyTracksCollections;

  @override
  List<Object> get props => [historyTracksCollections];
}

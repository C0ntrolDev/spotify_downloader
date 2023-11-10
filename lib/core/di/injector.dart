import 'package:get_it/get_it.dart';
import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/core/db/local_db_impl.dart';
import 'package:spotify_downloader/features/home/data/data_sources/local_playlists_data_source.dart';
import 'package:spotify_downloader/features/home/data/repositories/history_playlists_repository_impl.dart';
import 'package:spotify_downloader/features/home/domain/repositories/history_playlists_repository.dart';
import 'package:spotify_downloader/features/home/domain/use_cases/add_playlist_to_history.dart';
import 'package:spotify_downloader/features/home/domain/use_cases/get_ordered_history.dart';
import 'package:spotify_downloader/features/home/presentation/bloc/home_bloc.dart';

final injector = GetIt.instance;

Future<void> initInjector() async {
  await _initCore();
  _provideDataSources();
  _provideRepositories();
  _provideUseCases();
  _provideBlocs();
}

Future<void> _initCore() async {
  injector.registerSingleton<LocalDb>(LocalDbImpl());
  await injector.get<LocalDb>().initDb();
}

void _provideDataSources() {
  injector.registerSingleton<LocalPlaylistsDataSource>(LocalPlaylistsDataSource(localDb: injector.get<LocalDb>()));
}

void _provideRepositories() {
  injector.registerSingleton<HistoryPlaylistsRepository>(
      HistoryPlaylistsRepositoryImpl(localPlaylistsDataSource: injector.get<LocalPlaylistsDataSource>()));
}

void _provideUseCases() {
  injector.registerFactory<AddPlaylistToHistory>(
      () => AddPlaylistToHistory(historyPlaylistsRepository: injector.get<HistoryPlaylistsRepository>()));
  injector.registerFactory<GetOrderedHistory>(
      () => GetOrderedHistory(historyPlaylistsRepository: injector.get<HistoryPlaylistsRepository>()));
}

void _provideBlocs() {
  injector.registerFactory<HomeBloc>(() => HomeBloc(
      getOrderedHistory: injector.get<GetOrderedHistory>(),
      addPlaylistToHistory: injector.get<AddPlaylistToHistory>()));
  
}

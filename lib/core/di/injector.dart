import 'package:get_it/get_it.dart';
import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/core/db/local_db_impl.dart';
import 'package:spotify_downloader/features/data/data_sources/local_tracks_collections_data_source.dart';
import 'package:spotify_downloader/features/data/repositories/history_tracks_collections_repository_impl.dart';
import 'package:spotify_downloader/features/domain/repositories/history_tracks_collections_repository.dart';
import 'package:spotify_downloader/features/domain/use_cases/add_tracks_collection_to_history.dart';
import 'package:spotify_downloader/features/domain/use_cases/get_ordered_history.dart';
import 'package:spotify_downloader/features/presentation/home/bloc/home_bloc.dart';

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
  injector.registerSingleton<LocalTracksCollectionsDataSource>(LocalTracksCollectionsDataSource(localDb: injector.get<LocalDb>()));
}

void _provideRepositories() {
  injector.registerSingleton<HistoryTracksCollectionsRepository>(
      HistoryTracksCollectionsRepositoryImpl(localTracksCollectionDataSource: injector.get<LocalTracksCollectionsDataSource>()));
}

void _provideUseCases() {
  injector.registerFactory<AddTracksCollectionToHistory>(
      () => AddTracksCollectionToHistory(historyPlaylistsRepository: injector.get<HistoryTracksCollectionsRepository>()));
  injector.registerFactory<GetOrderedHistory>(
      () => GetOrderedHistory(historyPlaylistsRepository: injector.get<HistoryTracksCollectionsRepository>()));
}

void _provideBlocs() {
  injector.registerFactory<HomeBloc>(() => HomeBloc(
      getOrderedHistory: injector.get<GetOrderedHistory>(),
      addPlaylistToHistory: injector.get<AddTracksCollectionToHistory>()));
  
}

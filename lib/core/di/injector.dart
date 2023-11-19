import 'package:get_it/get_it.dart';
import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/core/db/local_db_impl.dart';
import 'package:spotify_downloader/features/data/history_tracks_collectons/data_source/tracks_collectons_history_data_source.dart';
import 'package:spotify_downloader/features/data/history_tracks_collectons/repositories/tracks_collections_history_repository_impl.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/repositories/tracks_collections_history_repository.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/use_cases/add_tracks_collection_to_history.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/use_cases/get_ordered_history.dart';
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
  injector.registerSingleton<TracksCollectonsHistoryDataSource>(TracksCollectonsHistoryDataSource(localDb: injector.get<LocalDb>()));
}

void _provideRepositories() {
  injector.registerSingleton<TracksCollectionsHistoryRepository>(
      TracksCollectionsHistoryRepositoryImpl(dataSource : injector.get<TracksCollectonsHistoryDataSource>()));
}

void _provideUseCases() {
  injector.registerFactory<AddHistoryTracksCollectionToHistory>(
      () => AddHistoryTracksCollectionToHistory(historyPlaylistsRepository: injector.get<TracksCollectionsHistoryRepository>()));
  injector.registerFactory<GetOrderedHistory>(
      () => GetOrderedHistory(historyPlaylistsRepository: injector.get<TracksCollectionsHistoryRepository>()));
}

void _provideBlocs() {
  injector.registerFactory<HomeBloc>(() => HomeBloc(
      getOrderedHistory: injector.get<GetOrderedHistory>(),
      addTracksCollectionToHistory: injector.get<AddHistoryTracksCollectionToHistory>()));
  
}

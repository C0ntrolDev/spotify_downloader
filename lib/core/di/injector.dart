import 'package:get_it/get_it.dart';
import 'package:spotify_downloader/core/consts/spotify_client.dart';
import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/core/db/local_db_impl.dart';
import 'package:spotify_downloader/features/data/history_tracks_collectons/data_source/tracks_collectons_history_data_source.dart';
import 'package:spotify_downloader/features/data/history_tracks_collectons/repositories/tracks_collections_history_repository_impl.dart';
import 'package:spotify_downloader/features/data/dowload_tracks/data_sources/dowload_audio_from_youtube_data_source.dart';
import 'package:spotify_downloader/features/data/dowload_tracks/data_sources/services/audio_metadata_editor/audio_metadata_editor_impl.dart';
import 'package:spotify_downloader/features/data/dowload_tracks/data_sources/services/file_to_mp3_converter/ffmpeg_file_to_mp3_converter.dart';
import 'package:spotify_downloader/features/data/tracks_collections/data_source/tracks_collections_data_source.dart';
import 'package:spotify_downloader/features/data/tracks_collections/repositories/tracks_collections_repository_impl.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/repositories/tracks_collections_history_repository.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/use_cases/add_tracks_collection_to_history.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/use_cases/get_ordered_history.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/repositories/tracks_collections_repository.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/use_cases/get_tracks_collection_by_url.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/bloc/download_tracks_collection_bloc.dart';
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
  injector.registerSingleton<TracksCollectonsHistoryDataSource>(
      TracksCollectonsHistoryDataSource(localDb: injector.get<LocalDb>()));
  injector.registerSingleton<TracksCollectionsDataSource>(
      TracksCollectionsDataSource(clientId: clientId, clientSecret: clientSecret));
  injector.registerSingleton<DowloadAudioFromYoutubeDataSource>(DowloadAudioFromYoutubeDataSource(
      audioMetadataEditor: AudioMetadataEditorImpl(), fileToMp3Converter: FFmpegFileToMp3Converter()));
}

void _provideRepositories() {
  injector.registerSingleton<TracksCollectionsHistoryRepository>(
      TracksCollectionsHistoryRepositoryImpl(dataSource: injector.get<TracksCollectonsHistoryDataSource>()));
  injector.registerSingleton<TracksCollectionsRepository>(
      TracksCollectionsRepositoryImpl(dataSource: injector.get<TracksCollectionsDataSource>()));
}

void _provideUseCases() {
  injector.registerFactory<AddHistoryTracksCollectionToHistory>(() => AddHistoryTracksCollectionToHistory(
      historyPlaylistsRepository: injector.get<TracksCollectionsHistoryRepository>()));
  injector.registerFactory<GetOrderedHistory>(
      () => GetOrderedHistory(historyPlaylistsRepository: injector.get<TracksCollectionsHistoryRepository>()));
  injector.registerFactory<GetTracksCollectionByUrl>(
      () => GetTracksCollectionByUrl(repository: injector.get<TracksCollectionsRepository>()));
}

void _provideBlocs() {
  injector.registerFactory<HomeBloc>(() => HomeBloc(
      getOrderedHistory: injector.get<GetOrderedHistory>(),
      addTracksCollectionToHistory: injector.get<AddHistoryTracksCollectionToHistory>()));
  injector.registerFactory<DownloadTracksCollectionBloc>(
      () => DownloadTracksCollectionBloc(getTracksCollectionByUrl: injector.get<GetTracksCollectionByUrl>(), test: injector.get<DowloadAudioFromYoutubeDataSource>()));
}

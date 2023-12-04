import 'package:get_it/get_it.dart';
import 'package:spotify_downloader/core/consts/spotify_client.dart';
import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/core/db/local_db_impl.dart';
import 'package:spotify_downloader/features/data/history_tracks_collectons/data_source/tracks_collectons_history_data_source.dart';
import 'package:spotify_downloader/features/data/history_tracks_collectons/repositories/tracks_collections_history_repository_impl.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/data_sources/dowload_audio_from_youtube_data_source.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/data_sources/tools/audio_metadata_editor/audio_metadata_editor_impl.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/data_sources/tools/file_to_mp3_converter/ffmpeg_file_to_mp3_converter.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/repositories/dowload_tracks_repository_impl.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/data_sources/network_tracks_data_source.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/repositories/network_tracks_repository_impl.dart';
import 'package:spotify_downloader/features/data/tracks/search_videos_by_track/data_sources/search_video_on_youtube_data_source.dart';
import 'package:spotify_downloader/features/data/tracks/search_videos_by_track/repositories/search_videos_by_track_repository_impl.dart';
import 'package:spotify_downloader/features/data/tracks_collections/data_source/tracks_collections_data_source.dart';
import 'package:spotify_downloader/features/data/tracks_collections/repositories/tracks_collections_repository_impl.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/repositories/tracks_collections_history_repository.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/use_cases/add_tracks_collection_to_history.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/use_cases/get_ordered_history.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/repositories/dowload_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/use_cases/cancel_track_loading.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/repositories/network_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/search_videos_by_track/repositories/search_videos_by_track_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/tracks_service.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/tracks_service_impl.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/download_track.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/get_tracks_with_loading_observer_from_tracks_colleciton.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/get_tracks_with_loading_observer_from_tracks_colleciton_with_offset.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/repositories/tracks_collections_repository.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/use_cases/get_tracks_collection_by_url.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/bloc/download_tracks_collection_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/track_tile/bloc/track_tile_bloc.dart';
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
  injector.registerSingleton<NetworkTracksDataSource>(
      NetworkTracksDataSource(clientId: clientId, clientSecret: clientSecret));
  injector.registerSingleton<SearchVideoOnYoutubeDataSource>(SearchVideoOnYoutubeDataSource());
}

void _provideRepositories() {
  injector.registerSingleton<TracksCollectionsHistoryRepository>(
      TracksCollectionsHistoryRepositoryImpl(dataSource: injector.get<TracksCollectonsHistoryDataSource>()));
  injector.registerSingleton<TracksCollectionsRepository>(
      TracksCollectionsRepositoryImpl(dataSource: injector.get<TracksCollectionsDataSource>()));
  injector.registerSingleton<NetworkTracksRepository>(
      NetworkTracksRepositoryImpl(networkTracksDataSource: injector.get<NetworkTracksDataSource>()));
  injector.registerSingleton<DowloadTracksRepository>(DowloadTracksRepositoryImpl(
      dowloadAudioFromYoutubeDataSource: injector.get<DowloadAudioFromYoutubeDataSource>()));
  injector.registerSingleton<SearchVideosByTrackRepository>(SearchVideosByTrackRepositoryImpl(
      searchVideoOnYoutubeDataSource: injector.get<SearchVideoOnYoutubeDataSource>()));

  injector.registerSingleton<TracksService>(TracksServiceImpl(
      searchVideosByTrackRepository: injector.get<SearchVideosByTrackRepository>(),
      networkTracksRepository: injector.get<NetworkTracksRepository>(),
      dowloadTracksRepository: injector.get<DowloadTracksRepository>()));
}

void _provideUseCases() {
  injector.registerFactory<AddHistoryTracksCollectionToHistory>(() => AddHistoryTracksCollectionToHistory(
      historyPlaylistsRepository: injector.get<TracksCollectionsHistoryRepository>()));
  injector.registerFactory<GetOrderedHistory>(
      () => GetOrderedHistory(historyPlaylistsRepository: injector.get<TracksCollectionsHistoryRepository>()));
  injector.registerFactory<GetTracksCollectionByUrl>(
      () => GetTracksCollectionByUrl(repository: injector.get<TracksCollectionsRepository>()));
  injector.registerFactory<GetTracksWithLoadingObserverFromTracksColleciton>(
      () => GetTracksWithLoadingObserverFromTracksColleciton(tracksService: injector.get<TracksService>()));
  injector.registerFactory<GetTracksWithLoadingObserverFromTracksCollecitonWithOffset>(
      () => GetTracksWithLoadingObserverFromTracksCollecitonWithOffset(tracksService: injector.get<TracksService>()));
  injector.registerFactory<DownloadTrack>(() => DownloadTrack(tracksService: injector.get<TracksService>()));
  injector.registerFactory<CancelTrackLoading>(
      () => CancelTrackLoading(dowloadTracksRepository: injector.get<DowloadTracksRepository>()));
}

void _provideBlocs() {
  injector.registerFactory<HomeBloc>(
      () => HomeBloc(addTracksCollectionToHistory: injector.get<AddHistoryTracksCollectionToHistory>()));
  injector.registerFactory<DownloadTracksCollectionBloc>(() => DownloadTracksCollectionBloc(
      getFromTracksCollectionWithOffset: injector.get<GetTracksWithLoadingObserverFromTracksCollecitonWithOffset>(),
      getTracksCollectionByUrl: injector.get<GetTracksCollectionByUrl>(),
      getTracksFromTracksColleciton: injector.get<GetTracksWithLoadingObserverFromTracksColleciton>()));
  injector.registerFactoryParam<TrackTileBloc, TrackWithLoadingObserver, void>((trackwithLoadingObserver, _) =>
      TrackTileBloc(
          trackWithLoadingObserver: trackwithLoadingObserver,
          dowloadTrack: injector.get<DownloadTrack>(),
          cancelTrackLoading: injector.get<CancelTrackLoading>()));
}

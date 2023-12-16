import 'package:get_it/get_it.dart';
import 'package:spotify_downloader/core/consts/spotify_client.dart';
import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/core/db/local_db_impl.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/data_sources/local_tracks_data_source.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/repositories/local_tracks_repository_impl.dart';
import 'package:spotify_downloader/features/data/tracks_collections/history_tracks_collectons/data_source/tracks_collectons_history_data_source.dart';
import 'package:spotify_downloader/features/data/tracks_collections/history_tracks_collectons/repositories/tracks_collections_history_repository_impl.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/data_sources/dowload_audio_from_youtube_data_source.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/data_sources/tools/audio_metadata_editor/audio_metadata_editor_impl.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/data_sources/tools/file_to_mp3_converter/ffmpeg_file_to_mp3_converter.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/repositories/dowload_tracks_repository_impl.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/data_sources/network_tracks_data_source.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/repositories/network_tracks_repository_impl.dart';
import 'package:spotify_downloader/features/data/tracks/search_videos_by_track/data_sources/search_video_on_youtube_data_source.dart';
import 'package:spotify_downloader/features/data/tracks/search_videos_by_track/repositories/search_videos_by_track_repository_impl.dart';
import 'package:spotify_downloader/features/data/tracks_collections/network_tracks_collections/data_source/network_tracks_collections_data_source.dart';
import 'package:spotify_downloader/features/data/tracks_collections/network_tracks_collections/repositories/tracks_collections_repository_impl.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/repositories/local_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/history_tracks_collectons/repositories/tracks_collections_history_repository.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/history_tracks_collectons/use_cases/add_tracks_collection_to_history.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/history_tracks_collectons/use_cases/get_ordered_history.dart';
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
import 'package:spotify_downloader/features/domain/tracks_collections/network_tracks_collections/repositories/network_tracks_collections_repository.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/network_tracks_collections/use_cases/get_tracks_collection_by_history_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/network_tracks_collections/use_cases/get_tracks_collection_by_url.dart';
import 'package:spotify_downloader/features/presentation/download_track_info/bloc/download_track_info_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_track_info/widgets/download_track_info_status_tile/cubit/download_track_info_status_tile_cubit.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/bloc/download_tracks_collection_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/track_tile/bloc/track_tile_bloc.dart';
import 'package:spotify_downloader/features/presentation/history/bloc/history_bloc.dart';
import 'package:spotify_downloader/features/presentation/home/bloc/home_bloc.dart';

final injector = GetIt.instance;

Future<void> initInjector() async {
  await _initCore();
  await _provideDataSources();
  _provideRepositories();
  _provideUseCases();
  _provideBlocs();
}

Future<void> _initCore() async {
  injector.registerSingleton<LocalDb>(LocalDbImpl());
  await injector.get<LocalDb>().initDb();
}

Future<void> _provideDataSources() async {
  injector.registerSingleton<TracksCollectonsHistoryDataSource>(
      TracksCollectonsHistoryDataSource(localDb: injector.get<LocalDb>()));
  injector.registerSingleton<NetworkTracksCollectionsDataSource>(
      NetworkTracksCollectionsDataSource(clientId: clientId, clientSecret: clientSecret));
  injector.registerSingleton<DownloadAudioFromYoutubeDataSource>(DownloadAudioFromYoutubeDataSource(
      audioMetadataEditor: AudioMetadataEditorImpl(), fileToMp3Converter: FFmpegFileToMp3Converter()));
  await injector.get<DownloadAudioFromYoutubeDataSource>().init();
  injector.registerSingleton<NetworkTracksDataSource>(
      NetworkTracksDataSource(clientId: clientId, clientSecret: clientSecret));
  await injector.get<NetworkTracksDataSource>().init();
  injector.registerSingleton<SearchVideoOnYoutubeDataSource>(SearchVideoOnYoutubeDataSource());
  await injector.get<SearchVideoOnYoutubeDataSource>().init();
  injector.registerSingleton<LocalTracksDataSource>(LocalTracksDataSource(localDb: injector.get<LocalDb>()));
}

void _provideRepositories() {
  injector.registerSingleton<TracksCollectionsHistoryRepository>(
      TracksCollectionsHistoryRepositoryImpl(dataSource: injector.get<TracksCollectonsHistoryDataSource>()));
  injector.registerSingleton<NetworkTracksCollectionsRepository>(
      NetworkTracksCollectionsRepositoryImpl(dataSource: injector.get<NetworkTracksCollectionsDataSource>()));
  injector.registerSingleton<NetworkTracksRepository>(
      NetworkTracksRepositoryImpl(networkTracksDataSource: injector.get<NetworkTracksDataSource>()));
  injector.registerSingleton<DowloadTracksRepository>(DowloadTracksRepositoryImpl(
      dowloadAudioFromYoutubeDataSource: injector.get<DownloadAudioFromYoutubeDataSource>()));
  injector.registerSingleton<SearchVideosByTrackRepository>(SearchVideosByTrackRepositoryImpl(
      searchVideoOnYoutubeDataSource: injector.get<SearchVideoOnYoutubeDataSource>()));
  injector.registerSingleton<LocalTracksRepository>(
      LocalTracksRepositoryImpl(dataSource: injector.get<LocalTracksDataSource>()));

  injector.registerSingleton<TracksService>(TracksServiceImpl(
      searchVideosByTrackRepository: injector.get<SearchVideosByTrackRepository>(),
      networkTracksRepository: injector.get<NetworkTracksRepository>(),
      dowloadTracksRepository: injector.get<DowloadTracksRepository>(),
      localTracksRepository: injector.get<LocalTracksRepository>()));
}

void _provideUseCases() {
  injector.registerFactory<AddTracksCollectionToHistory>(() =>
      AddTracksCollectionToHistory(historyPlaylistsRepository: injector.get<TracksCollectionsHistoryRepository>()));
  injector.registerFactory<GetOrderedHistory>(
      () => GetOrderedHistory(historyPlaylistsRepository: injector.get<TracksCollectionsHistoryRepository>()));
  injector.registerFactory<GetTracksCollectionByUrl>(
      () => GetTracksCollectionByUrl(repository: injector.get<NetworkTracksCollectionsRepository>()));
  injector.registerFactory<GetTracksCollectionByTypeAndSpotifyId>(
      () => GetTracksCollectionByTypeAndSpotifyId(repository: injector.get<NetworkTracksCollectionsRepository>()));
  injector.registerFactory<GetTracksWithLoadingObserverFromTracksColleciton>(
      () => GetTracksWithLoadingObserverFromTracksColleciton(tracksService: injector.get<TracksService>()));
  injector.registerFactory<GetTracksWithLoadingObserverFromTracksCollecitonWithOffset>(
      () => GetTracksWithLoadingObserverFromTracksCollecitonWithOffset(tracksService: injector.get<TracksService>()));
  injector.registerFactory<DownloadTrack>(() => DownloadTrack(tracksService: injector.get<TracksService>()));
  injector.registerFactory<CancelTrackLoading>(
      () => CancelTrackLoading(dowloadTracksRepository: injector.get<DowloadTracksRepository>()));
}

void _provideBlocs() {
  injector.registerFactory<HomeBloc>(() => HomeBloc());
  injector.registerFactory<HistoryBloc>(() => HistoryBloc(getOrderedHistory: injector.get<GetOrderedHistory>()));
  injector.registerFactory<DownloadTracksCollectionBloc>(() => DownloadTracksCollectionBloc(
      getTracksCollectionByTypeAndSpotifyId: injector.get<GetTracksCollectionByTypeAndSpotifyId>(),
      addTracksCollectionToHistory: injector.get<AddTracksCollectionToHistory>(),
      getFromTracksCollectionWithOffset: injector.get<GetTracksWithLoadingObserverFromTracksCollecitonWithOffset>(),
      getTracksCollectionByUrl: injector.get<GetTracksCollectionByUrl>(),
      getTracksFromTracksColleciton: injector.get<GetTracksWithLoadingObserverFromTracksColleciton>()));
  injector.registerFactoryParam<TrackTileBloc, TrackWithLoadingObserver, void>((trackwithLoadingObserver, _) =>
      TrackTileBloc(
          trackWithLoadingObserver: trackwithLoadingObserver,
          downloadTrack: injector.get<DownloadTrack>(),
          cancelTrackLoading: injector.get<CancelTrackLoading>()));
  injector.registerFactoryParam<DownloadTrackInfoBloc, TrackWithLoadingObserver, void>((trackwithLoadingObserver, _) =>
      DownloadTrackInfoBloc(
          trackWithLoadingObserver: trackwithLoadingObserver,
          downloadTrack: injector.get<DownloadTrack>(),
          cancelTrackLoading: injector.get<CancelTrackLoading>()));
  injector.registerFactoryParam<DownloadTrackInfoStatusTileCubit, TrackWithLoadingObserver, void>(
      (trackwithLoadingObserver, _) => DownloadTrackInfoStatusTileCubit(trackwithLoadingObserver));
}

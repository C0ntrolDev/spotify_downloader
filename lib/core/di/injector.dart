import 'package:get_it/get_it.dart';
import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/core/db/local_db_impl.dart';
import 'package:spotify_downloader/features/data/auth/local_auth/data_source/local_auth_data_source.dart';
import 'package:spotify_downloader/features/data/auth/local_auth/repository/local_auth_repository_impl.dart';
import 'package:spotify_downloader/features/data/auth/network_auth/data_source/network_auth_data_source.dart';
import 'package:spotify_downloader/features/data/auth/network_auth/repository/network_auth_repository_impl.dart';
import 'package:spotify_downloader/features/data/settings/data_source/settings_data_source.dart';
import 'package:spotify_downloader/features/data/settings/repository/settings_repository.dart';
import 'package:spotify_downloader/features/data/spotify_profile/data_source/spotify_profile_data_source.dart';
import 'package:spotify_downloader/features/data/spotify_profile/repository/spotify_profile_repository_impl.dart';
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
import 'package:spotify_downloader/features/domain/auth/local_auth/repositories/local_client_auth_repository.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/repositories/local_full_auth_repository.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/repositories/local_user_auth_repository.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/use_cases/clear_user_credentials.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/use_cases/get_client_credentials.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/use_cases/save_client_credentials.dart';
import 'package:spotify_downloader/features/domain/auth/network_auth/repository/network_auth_repository.dart';
import 'package:spotify_downloader/features/domain/auth/service/service/auth_service.dart';
import 'package:spotify_downloader/features/domain/auth/service/service/auth_service_impl.dart';
import 'package:spotify_downloader/features/domain/auth/service/use_cases/authorize_user.dart';
import 'package:spotify_downloader/features/domain/settings/repository/download_tracks_settings_repository.dart';
import 'package:spotify_downloader/features/domain/settings/use_cases/get_download_tracks_settings.dart';
import 'package:spotify_downloader/features/domain/settings/use_cases/save_download_tracks_setting.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/repository/spotify_profile_repostitory.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/service/spotify_profile_service.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/service/spotify_profile_service_impl.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/use_cases/get_spotify_profile.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/repositories/local_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/entities/loading_tracks_collection/loading_tracks_collection_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/repository/observe_tracks_loading_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/repository/observe_tracks_loading_repository_impl.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/use_cases/get_loading_tracks_collections_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/search_videos_by_track/use_cases/find_10_videos_by_track.dart';
import 'package:spotify_downloader/features/domain/tracks/search_videos_by_track/use_cases/get_video_by_url.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/download_tracks_service/download_tracks_service.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/download_tracks_service/download_tracks_service_impl.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/download_tracks_from_getting_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/download_tracks_range.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/history_tracks_collectons/repositories/tracks_collections_history_repository.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/history_tracks_collectons/use_cases/add_tracks_collection_to_history.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/history_tracks_collectons/use_cases/get_ordered_history.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/repositories/dowload_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/use_cases/cancel_track_loading.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/repositories/network_tracks_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/search_videos_by_track/repositories/search_videos_by_track_repository.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/get_tracks_service/get_tracks_service.dart';
import 'package:spotify_downloader/features/domain/tracks/services/services/get_tracks_service/get_tracks_service_impl.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/download_track.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/get_tracks_with_loading_observer_from_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/get_tracks_with_loading_observer_from_tracks_collection_with_offset.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/network_tracks_collections/repositories/network_tracks_collections_repository.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/network_tracks_collections/service/network_tracks_collections_service.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/network_tracks_collections/service/network_tracks_collections_service_impl.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/network_tracks_collections/use_cases/get_tracks_collection_by_type_and_spotify_id.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/network_tracks_collections/use_cases/get_tracks_collection_by_url.dart';
import 'package:spotify_downloader/features/presentation/change_source_video/bloc/change_source_video_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/download_track_info/bloc/download_track_info_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/download_track_info/widgets/download_track_info_status_tile/cubit/download_track_info_status_tile_cubit.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/track_tile/bloc/track_tile_bloc.dart';
import 'package:spotify_downloader/features/presentation/history/bloc/history_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/filter_tracks/filter_tracks_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/get_and_download_tracks/get_and_download_tracks_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/get_tracks_collection/get_tracks_collection_by_history_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/get_tracks_collection/get_tracks_collection_by_url_bloc.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/loading_tracks_collections_list/bloc/loading_tracks_collections_list_bloc.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/loading_tracks_collections_list/widgets/loading_tracks_collection_tile/cubit/loading_tracks_collection_tile_cubit.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/auth_settings/blocs/account_auth/account_auth_bloc.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/auth_settings/blocs/client_auth/client_auth_bloc.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/download_tracks_settings/bloc/download_tracks_settings_bloc.dart';
import 'package:spotify_downloader/features/presentation/tracks_collections_loading_notification/bloc/tracks_collections_loading_notifications_bloc.dart';

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
  injector.registerSingleton<NetworkTracksCollectionsDataSource>(NetworkTracksCollectionsDataSource());
  injector.registerSingleton<DownloadAudioFromYoutubeDataSource>(DownloadAudioFromYoutubeDataSource(
      audioMetadataEditor: AudioMetadataEditorImpl(), fileToMp3Converter: FFmpegFileToMp3Converter()));
  await injector.get<DownloadAudioFromYoutubeDataSource>().init();
  injector.registerSingleton<NetworkTracksDataSource>(NetworkTracksDataSource());
  await injector.get<NetworkTracksDataSource>().init();
  injector.registerSingleton<SearchVideoOnYoutubeDataSource>(SearchVideoOnYoutubeDataSource());
  await injector.get<SearchVideoOnYoutubeDataSource>().init();
  injector.registerSingleton<LocalTracksDataSource>(LocalTracksDataSource(localDb: injector.get<LocalDb>()));
  injector.registerSingleton<LocalAuthDataSource>(LocalAuthDataSource());
  injector.registerSingleton<NetworkAuthDataSource>(NetworkAuthDataSource());
  injector.registerSingleton<SpotifyProfileDataSource>(SpotifyProfileDataSource());
  injector.registerSingleton<SettingsDataSource>(SettingsDataSource());
}

void _provideRepositories() {
  injector.registerSingleton<TracksCollectionsHistoryRepository>(
      TracksCollectionsHistoryRepositoryImpl(dataSource: injector.get<TracksCollectonsHistoryDataSource>()));
  injector.registerSingleton<NetworkTracksCollectionsRepository>(
      NetworkTracksCollectionsRepositoryImpl(dataSource: injector.get<NetworkTracksCollectionsDataSource>()));
  injector.registerSingleton<NetworkTracksRepository>(
      NetworkTracksRepositoryImpl(networkTracksDataSource: injector.get<NetworkTracksDataSource>()));
  injector.registerSingleton<DownloadTracksRepository>(DowloadTracksRepositoryImpl(
      dowloadAudioFromYoutubeDataSource: injector.get<DownloadAudioFromYoutubeDataSource>()));
  injector.registerSingleton<SearchVideosByTrackRepository>(SearchVideosByTrackRepositoryImpl(
      searchVideoOnYoutubeDataSource: injector.get<SearchVideoOnYoutubeDataSource>()));
  injector.registerSingleton<LocalTracksRepository>(
      LocalTracksRepositoryImpl(dataSource: injector.get<LocalTracksDataSource>()));
  injector.registerSingleton<ObserveTracksLoadingRepository>(ObserveTracksLoadingRepositoryImpl());
  injector.registerSingleton<NetworkAuthRepository>(
      NetworkAuthRepositoryImpl(dataSource: injector.get<NetworkAuthDataSource>()));
  injector.registerSingleton<SpotifyProfileRepository>(
      SpotifyProfileRepositoryImpl(dataSource: injector.get<SpotifyProfileDataSource>()));

  final localAuthRepository = LocalAuthRepositoryImpl(dataSource: injector.get<LocalAuthDataSource>());
  injector.registerSingleton<LocalUserAuthRepository>(localAuthRepository);
  injector.registerSingleton<LocalClientAuthRepository>(localAuthRepository);
  injector.registerSingleton<LocalFullAuthRepository>(localAuthRepository);

  final settingsRepository = SettingsRepository(settingsDataSource: injector.get<SettingsDataSource>());
  injector.registerSingleton<DownloadTracksSettingsRepository>(settingsRepository);

  injector.registerSingleton<NetworkTracksCollectionsService>(NetworkTracksCollectionsServiceImpl(
      networkTracksCollectionsRepository: injector.get<NetworkTracksCollectionsRepository>(),
      fullAuthRepository: injector.get<LocalFullAuthRepository>()));

  injector.registerSingleton<DownloadTracksService>(DownloadTracksServiceImpl(
      observeTracksLoadingRepository: injector.get<ObserveTracksLoadingRepository>(),
      dowloadTracksRepository: injector.get<DownloadTracksRepository>(),
      searchVideosByTrackRepository: injector.get<SearchVideosByTrackRepository>(),
      localTracksRepository: injector.get<LocalTracksRepository>()));

  injector.registerSingleton<GetTracksService>(GetTracksServiceImpl(
      networkTracksRepository: injector.get<NetworkTracksRepository>(),
      downloadTracksRepository: injector.get<DownloadTracksRepository>(),
      localTracksRepository: injector.get<LocalTracksRepository>(),
      authRepository: injector.get<LocalFullAuthRepository>()));

  injector.registerSingleton<SpotifyProfileService>(SpotifyProfileServiceImpl(
      localFullAuthRepository: injector.get<LocalFullAuthRepository>(),
      spotifyProfileRepository: injector.get<SpotifyProfileRepository>()));

  injector.registerSingleton<AuthService>(AuthServiceImpl(
      localUserAuthRepository: injector.get<LocalUserAuthRepository>(),
      localClientAuthRepository: injector.get<LocalClientAuthRepository>(),
      networkAuthRepository: injector.get<NetworkAuthRepository>()));
}

void _provideUseCases() {
  injector.registerFactory<AddTracksCollectionToHistory>(() =>
      AddTracksCollectionToHistory(historyPlaylistsRepository: injector.get<TracksCollectionsHistoryRepository>()));
  injector.registerFactory<GetOrderedHistory>(
      () => GetOrderedHistory(historyPlaylistsRepository: injector.get<TracksCollectionsHistoryRepository>()));
  injector.registerFactory<GetTracksCollectionByUrl>(
      () => GetTracksCollectionByUrl(service: injector.get<NetworkTracksCollectionsService>()));
  injector.registerFactory<GetTracksCollectionByTypeAndSpotifyId>(
      () => GetTracksCollectionByTypeAndSpotifyId(service: injector.get<NetworkTracksCollectionsService>()));
  injector.registerFactory<GetTracksWithLoadingObserverFromTracksCollection>(
      () => GetTracksWithLoadingObserverFromTracksCollection(getTracksService: injector.get<GetTracksService>()));
  injector.registerFactory<GetTracksWithLoadingObserverFromTracksCollectionWithOffset>(() =>
      GetTracksWithLoadingObserverFromTracksCollectionWithOffset(getTracksService: injector.get<GetTracksService>()));
  injector.registerFactory<Find10VideosByTrack>(
      () => Find10VideosByTrack(searchVideosByTrackRepository: injector.get<SearchVideosByTrackRepository>()));
  injector.registerFactory<GetVideoByUrl>(
      () => GetVideoByUrl(searchVideosByTrackRepository: injector.get<SearchVideosByTrackRepository>()));
  injector.registerFactory<CancelTrackLoading>(
      () => CancelTrackLoading(dowloadTracksRepository: injector.get<DownloadTracksRepository>()));
  injector.registerFactory<DownloadTrack>(
      () => DownloadTrack(downloadTracksService: injector.get<DownloadTracksService>()));
  injector.registerFactory<DownloadTracksRange>(
      () => DownloadTracksRange(downloadTracksService: injector.get<DownloadTracksService>()));
  injector.registerFactory<DownloadTracksFromGettingObserver>(
      () => DownloadTracksFromGettingObserver(downloadTracksService: injector.get<DownloadTracksService>()));
  injector.registerFactory<GetLoadingTracksCollectionsObserver>(
      () => GetLoadingTracksCollectionsObserver(repository: injector.get<ObserveTracksLoadingRepository>()));

  injector.registerFactory<GetClientCredentials>(
      () => GetClientCredentials(localClientAuthRepository: injector.get<LocalClientAuthRepository>()));
  injector.registerFactory<SaveClientCredentials>(
      () => SaveClientCredentials(localClientAuthRepository: injector.get<LocalClientAuthRepository>()));
  injector.registerFactory<AuthorizeUser>(() => AuthorizeUser(authService: injector.get<AuthService>()));
  injector.registerFactory<GetSpotifyProfile>(
      () => GetSpotifyProfile(spotifyProfileService: injector.get<SpotifyProfileService>()));
  injector.registerFactory<ClearUserCredentials>(
      () => ClearUserCredentials(localUserAuthRepository: injector.get<LocalUserAuthRepository>()));

  injector.registerFactory<GetDownloadTracksSettings>(() =>
      GetDownloadTracksSettings(downloadTracksSettingsRepository: injector.get<DownloadTracksSettingsRepository>()));
  injector.registerFactory<SaveDownloadTracksSettings>(() =>
      SaveDownloadTracksSettings(downloadTracksSettingsRepository: injector.get<DownloadTracksSettingsRepository>()));
}

void _provideBlocs() {
  injector.registerFactory<LoadingTracksCollectionsListBloc>(
      () => LoadingTracksCollectionsListBloc(injector.get<GetLoadingTracksCollectionsObserver>()));
  injector.registerFactoryParam<LoadingTracksCollectionTileCubit, LoadingTracksCollectionObserver, void>(
      (loadingTracksCollection, _) => LoadingTracksCollectionTileCubit(loadingTracksCollection));

  injector.registerFactory<HistoryBloc>(() => HistoryBloc(getOrderedHistory: injector.get<GetOrderedHistory>()));

  injector.registerFactoryParam<GetTracksCollectionByUrlBloc, String, void>((url, _) => GetTracksCollectionByUrlBloc(
      addTracksCollectionToHistory: injector.get<AddTracksCollectionToHistory>(),
      getTracksCollection: injector.get<GetTracksCollectionByUrl>(),
      url: url));
  injector.registerFactoryParam<GetTracksCollectionByHistoryBloc, HistoryTracksCollection, void>(
      (historyCollection, _) => GetTracksCollectionByHistoryBloc(
          addTracksCollectionToHistory: injector.get<AddTracksCollectionToHistory>(),
          getTracksCollection: injector.get<GetTracksCollectionByTypeAndSpotifyId>(),
          historyTracksCollection: historyCollection));
  injector.registerFactory<GetAndDownloadTracksBloc>(() => GetAndDownloadTracksBloc(
      downloadTracksRange: injector.get<DownloadTracksRange>(),
      downloadTracksFromGettingObserver: injector.get<DownloadTracksFromGettingObserver>(),
      getTracksFromTracksCollection: injector.get<GetTracksWithLoadingObserverFromTracksCollection>(),
      getTracksWithOffset: injector.get<GetTracksWithLoadingObserverFromTracksCollectionWithOffset>()));
  injector.registerFactory<FilterTracksBloc>(() => FilterTracksBloc());

  injector.registerFactoryParam<TrackTileBloc, TrackWithLoadingObserver, void>((trackwithLoadingObserver, _) =>
      TrackTileBloc(
          trackWithLoadingObserver: trackwithLoadingObserver,
          downloadTrack: injector.get<DownloadTrack>(),
          cancelTrackLoading: injector.get<CancelTrackLoading>()));
  injector.registerFactoryParam<DownloadTrackInfoBloc, TrackWithLoadingObserver, void>((trackwithLoadingObserver, _) =>
      DownloadTrackInfoBloc(
          trackWithLoadingObserver: trackwithLoadingObserver, cancelTrackLoading: injector.get<CancelTrackLoading>()));
  injector.registerFactoryParam<DownloadTrackInfoStatusTileCubit, TrackWithLoadingObserver, void>(
      (trackwithLoadingObserver, _) => DownloadTrackInfoStatusTileCubit(trackwithLoadingObserver));
  injector.registerFactoryParam<ChangeSourceVideoBloc, Track, void>((track, _) => ChangeSourceVideoBloc(
      sourceTrack: track,
      find10VideosByTrack: injector.get<Find10VideosByTrack>(),
      getVideoByUrl: injector.get<GetVideoByUrl>()));
  injector.registerFactory<TracksCollectionsLoadingNotificationsBloc>(
      () => TracksCollectionsLoadingNotificationsBloc(injector.get<GetLoadingTracksCollectionsObserver>()));

  injector.registerFactory<ClientAuthBloc>(() => ClientAuthBloc(
      getClientCredentials: injector.get<GetClientCredentials>(),
      saveClientCredentials: injector.get<SaveClientCredentials>()));

  injector.registerFactory<AccountAuthBloc>(() => AccountAuthBloc(
      authorizeUser: injector.get<AuthorizeUser>(),
      deleteUserCredentials: injector.get<ClearUserCredentials>(),
      getSpotifyProfile: injector.get<GetSpotifyProfile>()));

  injector.registerFactory<DownloadTracksSettingsBloc>(() => DownloadTracksSettingsBloc(
      getDownloadTracksSettings: injector.get<GetDownloadTracksSettings>(),
      saveDownloadTracksSetting: injector.get<SaveDownloadTracksSettings>()));
}

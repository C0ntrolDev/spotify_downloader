import 'package:get_it/get_it.dart';
import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/core/db/local_db_impl.dart';
import 'package:spotify_downloader/core/permissions/permissions_manager.dart';
import 'package:spotify_downloader/core/permissions/requiring_permission_services_initializer.dart';
import 'package:spotify_downloader/features/data_domain/auth/local_auth/local_auth.dart';
import 'package:spotify_downloader/features/data_domain/auth/network_auth/network_auth.dart';
import 'package:spotify_downloader/features/data_domain/auth/service/service.dart';
import 'package:spotify_downloader/features/data_domain/settings/settings.dart';
import 'package:spotify_downloader/features/data_domain/spotify_profile/spotify_profile.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/data/data_sources/tools/audio_metadata_editor/audio_metadata_editor_impl.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/data/data_sources/tools/file_to_mp3_converter/ffmpeg_file_to_mp3_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/download_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/local_tracks/local_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/network_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/observe_tracks_loading/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks/search_videos_by_track/search_videos_by_track.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/track.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/history_tracks_collections/history_tracks_collections.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/network_tracks_collections/network_tracks_collections.dart';
import 'package:spotify_downloader/features/presentation/change_source_video/bloc/change_source_video_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/filter_tracks/filter_tracks_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/get_and_download_tracks/get_and_download_tracks_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/get_tracks_collection/get_tracks_collection_by_history_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/get_tracks_collection/get_tracks_collection_by_url_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/download_track_info/bloc/download_track_info_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/download_track_info/widgets/download_track_info_status_tile/cubit/download_track_info_status_tile_cubit.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/track_tile/bloc/track_tile_bloc.dart';
import 'package:spotify_downloader/features/presentation/history/bloc/history_bloc.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/loading_tracks_collections_list/bloc/loading_tracks_collections_list_bloc.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/loading_tracks_collections_list/widgets/loading_tracks_collection_tile/cubit/loading_tracks_collection_tile_cubit.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/auth_settings/blocs/account_auth/account_auth_bloc.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/auth_settings/blocs/client_auth/client_auth_bloc.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/download_tracks_settings/bloc/download_tracks_settings_bloc.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/language_setting/bloc/language_setting_bloc.dart';
import 'package:spotify_downloader/features/presentation/tracks_collections_loading_notifications/bloc/tracks_collections_loading_notifications_bloc.dart';


final injector = GetIt.instance;

Future<void> initInjector() async {
  await _initCore();
  await _provideDataSources();
  _provideRepositories();
  _provideUseCases();
  _provideBlocs();
  await _initLateCore();
}

Future<void> _initLateCore() async {
    await injector.get<RequiringPermissionServicesInitializer>().init();
}

Future<void> _initCore() async {
  injector.registerSingleton<LocalDb>(LocalDbImpl());
  await injector.get<LocalDb>().initDb();
  injector.registerSingleton<PermissionsManager>(PermissionsManager());
  injector.registerSingleton<RequiringPermissionServicesInitializer>(
      RequiringPermissionServicesInitializer(permissionsManager: injector.get<PermissionsManager>()));
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

  final settingsRepository = SettingsRepositoryImpl(settingsDataSource: injector.get<SettingsDataSource>());
  injector.registerSingleton<DownloadTracksSettingsRepository>(settingsRepository);
  injector.registerSingleton<LanguageSettingsRepository>(settingsRepository);

  injector.registerSingleton<NetworkTracksCollectionsService>(NetworkTracksCollectionsServiceImpl(
      networkTracksCollectionsRepository: injector.get<NetworkTracksCollectionsRepository>(),
      fullAuthRepository: injector.get<LocalFullAuthRepository>()));

  injector.registerSingleton<DownloadTracksService>(DownloadTracksServiceImpl(
      observeTracksLoadingRepository: injector.get<ObserveTracksLoadingRepository>(),
      dowloadTracksRepository: injector.get<DownloadTracksRepository>(),
      searchVideosByTrackRepository: injector.get<SearchVideosByTrackRepository>(),
      localTracksRepository: injector.get<LocalTracksRepository>(),
      downloadTracksSettingsRepository: injector.get<DownloadTracksSettingsRepository>()));

  injector.registerSingleton<GetTracksService>(GetTracksServiceImpl(
      networkTracksRepository: injector.get<NetworkTracksRepository>(),
      downloadTracksRepository: injector.get<DownloadTracksRepository>(),
      localTracksRepository: injector.get<LocalTracksRepository>(),
      authRepository: injector.get<LocalFullAuthRepository>(),
      downloadTracksSettingsRepository: injector.get<DownloadTracksSettingsRepository>()));

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
      () => CancelTrackLoading(dowloadTracksService: injector.get<DownloadTracksService>()));
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

  injector.registerFactory<GetLanguage>(
      () => GetLanguage(languageSettingsRepository: injector.get<LanguageSettingsRepository>()));
  injector.registerFactory<GetAvailableLanguages>(
      () => GetAvailableLanguages(languageSettingsRepository: injector.get<LanguageSettingsRepository>()));
  injector.registerFactory<SaveLanguage>(
      () => SaveLanguage(languageSettingsRepository: injector.get<LanguageSettingsRepository>()));
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

  injector.registerFactory<LanguageSettingBloc>(() => LanguageSettingBloc(
      getLanguage: injector.get<GetLanguage>(),
      saveLanguage: injector.get<SaveLanguage>(),
      getAvailableLanguages: injector.get<GetAvailableLanguages>()));
}

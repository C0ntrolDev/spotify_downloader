import 'package:get_it/get_it.dart';
import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/core/db/local_db_impl.dart';
import 'package:spotify_downloader/core/permissions/permissions_manager.dart';
import 'package:spotify_downloader/core/permissions/requiring_permission_services_initializer.dart';
import 'package:spotify_downloader/features/data_domain/spotify_profile/data/data_source/spotify_profile_data_source.dart';
import 'package:spotify_downloader/features/data_domain/spotify_profile/data/repository/spotify_profile_repository_impl.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/local_tracks/data_sources/local_tracks_data_source.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/local_tracks/repositories/local_tracks_repository_impl.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/data/history_tracks_collectons/data_source/tracks_collectons_history_data_source.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/data/history_tracks_collectons/repositories/tracks_collections_history_repository_impl.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/dowload_tracks/data_sources/dowload_audio_from_youtube_data_source.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/dowload_tracks/data_sources/tools/audio_metadata_editor/audio_metadata_editor_impl.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/dowload_tracks/data_sources/tools/file_to_mp3_converter/ffmpeg_file_to_mp3_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/dowload_tracks/repositories/dowload_tracks_repository_impl.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/network_tracks/data_sources/network_tracks_data_source.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/network_tracks/repositories/network_tracks_repository_impl.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/search_videos_by_track/data_sources/search_video_on_youtube_data_source.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/search_videos_by_track/repositories/search_videos_by_track_repository_impl.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/data/network_tracks_collections/data_source/network_tracks_collections_data_source.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/data/network_tracks_collections/repositories/tracks_collections_repository_impl.dart';
import 'package:spotify_downloader/features/data_domain/auth/auth.dart';
import 'package:spotify_downloader/features/data_domain/spotify_profile/domain/repository/spotify_profile_repostitory.dart';
import 'package:spotify_downloader/features/data_domain/spotify_profile/domain/service/spotify_profile_service.dart';
import 'package:spotify_downloader/features/data_domain/spotify_profile/domain/service/spotify_profile_service_impl.dart';
import 'package:spotify_downloader/features/data_domain/spotify_profile/domain/use_cases/get_spotify_profile.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/local_tracks/repositories/local_tracks_repository.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/observe_tracks_loading/entities/loading_tracks_collection/loading_tracks_collection_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/observe_tracks_loading/repository/observe_tracks_loading_repository.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/observe_tracks_loading/repository/observe_tracks_loading_repository_impl.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/observe_tracks_loading/use_cases/get_loading_tracks_collections_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/search_videos_by_track/use_cases/find_10_videos_by_track.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/search_videos_by_track/use_cases/get_video_by_url.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/services/download_tracks_service/download_tracks_service.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/services/download_tracks_service/download_tracks_service_impl.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/use_cases/download_tracks_from_getting_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/use_cases/download_tracks_range.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/track.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/history_tracks_collectons/repositories/tracks_collections_history_repository.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/history_tracks_collectons/use_cases/add_tracks_collection_to_history.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/history_tracks_collectons/use_cases/get_ordered_history.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/repositories/dowload_tracks_repository.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/use_cases/cancel_track_loading.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/network_tracks/repositories/network_tracks_repository.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/search_videos_by_track/repositories/search_videos_by_track_repository.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/services/get_tracks_service/get_tracks_service.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/services/get_tracks_service/get_tracks_service_impl.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/use_cases/download_track.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/use_cases/get_tracks_with_loading_observer_from_tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/use_cases/get_tracks_with_loading_observer_from_tracks_collection_with_offset.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/network_tracks_collections/repositories/network_tracks_collections_repository.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/network_tracks_collections/service/network_tracks_collections_service.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/network_tracks_collections/service/network_tracks_collections_service_impl.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/network_tracks_collections/use_cases/get_tracks_collection_by_type_and_spotify_id.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/network_tracks_collections/use_cases/get_tracks_collection_by_url.dart';
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
import 'package:spotify_downloader/features/presentation/settings/widgets/language_setting/bloc/language_setting_bloc.dart';
import 'package:spotify_downloader/features/presentation/tracks_collections_loading_notifications/bloc/tracks_collections_loading_notifications_bloc.dart';

import '../../features/data_domain/settings/settings.dart';

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

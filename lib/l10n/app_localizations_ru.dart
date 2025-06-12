// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get downloadFromLink => 'Скачать по ссылке';

  @override
  String get downloadFromLinkTextFieldHintText =>
      'Ссылка на трек, плейлист или альбом';

  @override
  String get incorrectLink => 'Неправильная ссылка';

  @override
  String get downloadLikedTracks => 'Скачать любимые треки';

  @override
  String get likedTracksTitle => 'Любимые треки';

  @override
  String get activeDownloads => 'Активные загрузки';

  @override
  String errorOccurredWhileLoadingActiveDownloads(Object failure) {
    return 'Ошибка загрузки активных треков: $failure';
  }

  @override
  String get tracksDontLoad => 'Ничего не загружается   ^_^';

  @override
  String get aboutApp => 'О приложении';

  @override
  String get specialThanks => 'Благодарности';

  @override
  String get changeTheDownloadSource => 'Изменить источник загрузки';

  @override
  String get theresSomethingWrongWithConnection =>
      'С соединением что-то не так';

  @override
  String get tryAgain => 'Попробовать снова';

  @override
  String nView(Object views) {
    return '$views просмотров';
  }

  @override
  String nThousands(Object value) {
    return '$value тыс';
  }

  @override
  String nMillions(Object value) {
    return '$value млн';
  }

  @override
  String get nothingWasFoundAtThisUrl =>
      'По данному url не было ничего найдено';

  @override
  String get toAccessYouNeedToLogIn => 'Для доступа необходимо авторизоваться';

  @override
  String get urlCopied => 'Url скопирован!';

  @override
  String get linkToTheSource => 'Ссылка на источник';

  @override
  String get urlNotSelected => 'Url не выбран';

  @override
  String get changeTheSource => 'Изменить источник';

  @override
  String get theTrackIsNotLoaded => 'Трек не загружен';

  @override
  String theTrackIsLoading(Object percent) {
    return 'Трек загружается: $percent%';
  }

  @override
  String get theTrackIsLoaded => 'Трек загружен';

  @override
  String downloadError(Object message) {
    return 'Ошибка загрузки: $message';
  }

  @override
  String get noConnection => 'отсутствует соединение';

  @override
  String get searchByName => 'Поиск по названию';

  @override
  String get downloadAll => 'Скачать все';

  @override
  String get searchHistory => 'История поиска';

  @override
  String get main => 'Главная';

  @override
  String get history => 'История';

  @override
  String get grantPermissions => 'Предоставьте разрешения';

  @override
  String get storagePermissionText =>
      'Для сохранения музыки в любое место на вашем телефоне, приложению нужно разрешение на работу с хранилищем';

  @override
  String get notificationsPermissionText =>
      'Для уведомления вас о загрузки, приложению нужен доступ к отправке уведомлений';

  @override
  String get grant => 'Предоставить доступ';

  @override
  String get refuse => 'Отказать';

  @override
  String get spotifySDKAndAccount => 'SpotifySDK и Аккаунт';

  @override
  String get accountInformationIsBeingLoaded =>
      'Информация об аккаунте загружается';

  @override
  String get youAreNotLoggedInToYourAccount => 'Вы не вошли в аккаунт';

  @override
  String get unknownError => 'Неизвестная ошибка';

  @override
  String get connectionError => 'Ошибка соединения';

  @override
  String get couldntLogInToYourAccount => 'Не удалось войти в аккаунт';

  @override
  String get logIn => 'Войти';

  @override
  String get logOut => 'Выйти';

  @override
  String get download => 'Загрузка';

  @override
  String get storagePath => 'Место хранения';

  @override
  String get saveAllInOneFolder => 'Сохранять все в одной папке';

  @override
  String get settings => 'Настройки';

  @override
  String get other => 'Иное';

  @override
  String get tracksAreBeingLoaded => 'Идет загрузка треков';

  @override
  String get allTracksAreLoaded => 'Все треки загружены';

  @override
  String tracksAreBeingLoadedBody(
      Object failure, Object loaded, Object percent, Object total) {
    return 'Всего: $total | Загружено: $loaded | Ошибка: $failure | $percent%';
  }

  @override
  String allTracksAreLoadedBody(Object failured, Object loaded) {
    return 'Загружено: $loaded | Ошибка: $failured';
  }

  @override
  String get developed => 'Разработано';

  @override
  String get language => 'Язык';

  @override
  String get packagesLicenses => 'Лицензии пакетов';

  @override
  String get appInfo => 'Информация о приложении';

  @override
  String appName(Object appName) {
    return 'Название: $appName';
  }

  @override
  String packageName(Object packageName) {
    return 'Пакет: $packageName';
  }

  @override
  String appVersion(Object appVersion) {
    return 'Версия: $appVersion';
  }

  @override
  String buildNumber(Object buildNumber) {
    return 'Номер сборки: $buildNumber';
  }

  @override
  String get developedByC0ntrolDev => 'Разработано C0ntrolDev';

  @override
  String get failureCopied => 'Ошибка скопирована!';
}

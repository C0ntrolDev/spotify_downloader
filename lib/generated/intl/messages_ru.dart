// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(loaded, failured) =>
      "Загружено: ${loaded} | Ошибка: ${failured}";

  static String m1(appName) => "Название: ${appName}";

  static String m2(appVersion) => "Версия: ${appVersion}";

  static String m3(buildNumber) => "Номер сборки: ${buildNumber}";

  static String m4(message) => "Ошибка загрузки: ${message}";

  static String m5(failure) => "Ошибка загрузки активных треков: ${failure}";

  static String m6(value) => "${value} млн";

  static String m7(value) => "${value} тыс";

  static String m8(views) => "${views} просмотров";

  static String m9(packageName) => "Пакет: ${packageName}";

  static String m10(percent) => "Трек загружается: ${percent}%";

  static String m11(total, loaded, failure, percent) =>
      "Всего: ${total} | Загружено: ${loaded} | Ошибка: ${failure} | ${percent}%";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutApp": MessageLookupByLibrary.simpleMessage("О приложении"),
        "accountInformationIsBeingLoaded": MessageLookupByLibrary.simpleMessage(
            "Информация об аккаунте загружается"),
        "activeDownloads":
            MessageLookupByLibrary.simpleMessage("Активные загрузки"),
        "allTracksAreLoaded":
            MessageLookupByLibrary.simpleMessage("Все треки загружены"),
        "allTracksAreLoadedBody": m0,
        "appInfo":
            MessageLookupByLibrary.simpleMessage("Информация о приложении"),
        "appName": m1,
        "appVersion": m2,
        "buildNumber": m3,
        "changeTheDownloadSource":
            MessageLookupByLibrary.simpleMessage("Изменить источник загрузки"),
        "changeTheSource":
            MessageLookupByLibrary.simpleMessage("Изменить источник"),
        "connectionError":
            MessageLookupByLibrary.simpleMessage("Ошибка соединения"),
        "couldntLogInToYourAccount":
            MessageLookupByLibrary.simpleMessage("Не удалось войти в аккаунт"),
        "developed": MessageLookupByLibrary.simpleMessage("Разработано"),
        "developedByC0ntrolDev":
            MessageLookupByLibrary.simpleMessage("Разработано C0ntroldev"),
        "download": MessageLookupByLibrary.simpleMessage("Загрузка"),
        "downloadAll": MessageLookupByLibrary.simpleMessage("Скачать все"),
        "downloadError": m4,
        "downloadFromLink":
            MessageLookupByLibrary.simpleMessage("Скачать по ссылке"),
        "downloadFromLinkTextFieldHintText":
            MessageLookupByLibrary.simpleMessage(
                "Ссылка на трек, плейлист или альбом"),
        "downloadLikedTracks":
            MessageLookupByLibrary.simpleMessage("Скачать любимые треки"),
        "errorOccurredWhileLoadingActiveDownloads": m5,
        "failureCopied":
            MessageLookupByLibrary.simpleMessage("Ошибка скопирована!"),
        "grant": MessageLookupByLibrary.simpleMessage("Предоставить доступ"),
        "grantPermissions":
            MessageLookupByLibrary.simpleMessage("Предоставьте разрешения"),
        "history": MessageLookupByLibrary.simpleMessage("История"),
        "incorrectLink":
            MessageLookupByLibrary.simpleMessage("Неправильная ссылка"),
        "language": MessageLookupByLibrary.simpleMessage("Язык"),
        "likedTracksTitle":
            MessageLookupByLibrary.simpleMessage("Любимые треки"),
        "linkToTheSource":
            MessageLookupByLibrary.simpleMessage("Ссылка на источник"),
        "logIn": MessageLookupByLibrary.simpleMessage("Войти"),
        "logOut": MessageLookupByLibrary.simpleMessage("Выйти"),
        "main": MessageLookupByLibrary.simpleMessage("Главная"),
        "nMillions": m6,
        "nThousands": m7,
        "nView": m8,
        "noConnection":
            MessageLookupByLibrary.simpleMessage("отсутствует соединение"),
        "nothingWasFoundAtThisUrl": MessageLookupByLibrary.simpleMessage(
            "По данному url не было ничего найдено"),
        "notificationsPermissionText": MessageLookupByLibrary.simpleMessage(
            "Для уведомления вас о загрузки, приложению нужен доступ к отправке уведомлений"),
        "other": MessageLookupByLibrary.simpleMessage("Иное"),
        "packageName": m9,
        "packagesLicenses":
            MessageLookupByLibrary.simpleMessage("Лицензии пакетов"),
        "refuse": MessageLookupByLibrary.simpleMessage("Отказать"),
        "saveAllInOneFolder":
            MessageLookupByLibrary.simpleMessage("Сохранять все в одной папке"),
        "searchByName":
            MessageLookupByLibrary.simpleMessage("Поиск по названию"),
        "searchHistory": MessageLookupByLibrary.simpleMessage("История поиска"),
        "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
        "specialThanks": MessageLookupByLibrary.simpleMessage("Благодарности"),
        "spotifySDKAndAccount":
            MessageLookupByLibrary.simpleMessage("SpotifySDK и Аккаунт"),
        "storagePath": MessageLookupByLibrary.simpleMessage("Место хранения"),
        "storagePermissionText": MessageLookupByLibrary.simpleMessage(
            "Для сохранения музыки в любое место на вашем телефоне, приложению нужно разрешение на работу с хранилищем"),
        "theTrackIsLoaded":
            MessageLookupByLibrary.simpleMessage("Трек загружен"),
        "theTrackIsLoading": m10,
        "theTrackIsNotLoaded":
            MessageLookupByLibrary.simpleMessage("Трек не загружен"),
        "theresSomethingWrongWithConnection":
            MessageLookupByLibrary.simpleMessage("С соединением что-то не так"),
        "toAccessYouNeedToLogIn": MessageLookupByLibrary.simpleMessage(
            "Для доступа необходимо авторизоваться"),
        "tracksAreBeingLoaded":
            MessageLookupByLibrary.simpleMessage("Идет загрузка треков"),
        "tracksAreBeingLoadedBody": m11,
        "tracksDontLoad":
            MessageLookupByLibrary.simpleMessage("Ничего не загружается   ^_^"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Попробовать снова"),
        "unknownError":
            MessageLookupByLibrary.simpleMessage("Неизвестная ошибка"),
        "urlCopied": MessageLookupByLibrary.simpleMessage("Url скопирован!"),
        "urlNotSelected": MessageLookupByLibrary.simpleMessage("Url не выбран"),
        "youAreNotLoggedInToYourAccount":
            MessageLookupByLibrary.simpleMessage("Вы не вошли в аккаунт"),
        "youCanCloseTheAppAndTheDownloadWillContinue":
            MessageLookupByLibrary.simpleMessage(
                "Вы можете закрыть приложение и загрузка продолжится !"),
        "youCanDeleteThisMessage": MessageLookupByLibrary.simpleMessage(
            "(вы можете удалить это сообщение)")
      };
}

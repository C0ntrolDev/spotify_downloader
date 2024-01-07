// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Download from link`
  String get downloadFromLink {
    return Intl.message(
      'Download from link',
      name: 'downloadFromLink',
      desc: '',
      args: [],
    );
  }

  /// `Link to a track, playlist, or album`
  String get downloadFromLinkTextFieldHintText {
    return Intl.message(
      'Link to a track, playlist, or album',
      name: 'downloadFromLinkTextFieldHintText',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect link`
  String get incorrectLink {
    return Intl.message(
      'Incorrect link',
      name: 'incorrectLink',
      desc: '',
      args: [],
    );
  }

  /// `Download liked tracks`
  String get downloadLikedTracks {
    return Intl.message(
      'Download liked tracks',
      name: 'downloadLikedTracks',
      desc: '',
      args: [],
    );
  }

  /// `Liked tracks`
  String get likedTracksTitle {
    return Intl.message(
      'Liked tracks',
      name: 'likedTracksTitle',
      desc: '',
      args: [],
    );
  }

  /// `Active downloads`
  String get activeDownloads {
    return Intl.message(
      'Active downloads',
      name: 'activeDownloads',
      desc: '',
      args: [],
    );
  }

  /// `Error occurred while loading active downloads: {failure}`
  String errorOccurredWhileLoadingActiveDownloads(Object failure) {
    return Intl.message(
      'Error occurred while loading active downloads: $failure',
      name: 'errorOccurredWhileLoadingActiveDownloads',
      desc: '',
      args: [failure],
    );
  }

  /// `Tracks don't load   ^_^`
  String get tracksDontLoad {
    return Intl.message(
      'Tracks don\'t load   ^_^',
      name: 'tracksDontLoad',
      desc: '',
      args: [],
    );
  }

  /// `About app`
  String get aboutApp {
    return Intl.message(
      'About app',
      name: 'aboutApp',
      desc: '',
      args: [],
    );
  }

  /// `Special thanks`
  String get specialThanks {
    return Intl.message(
      'Special thanks',
      name: 'specialThanks',
      desc: '',
      args: [],
    );
  }

  /// `Change the download source`
  String get changeTheDownloadSource {
    return Intl.message(
      'Change the download source',
      name: 'changeTheDownloadSource',
      desc: '',
      args: [],
    );
  }

  /// `There's something wrong with connection`
  String get theresSomethingWrongWithConnection {
    return Intl.message(
      'There\'s something wrong with connection',
      name: 'theresSomethingWrongWithConnection',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get tryAgain {
    return Intl.message(
      'Try again',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `{views} views`
  String nView(Object views) {
    return Intl.message(
      '$views views',
      name: 'nView',
      desc: '',
      args: [views],
    );
  }

  /// `{value}K`
  String nThousands(Object value) {
    return Intl.message(
      '${value}K',
      name: 'nThousands',
      desc: '',
      args: [value],
    );
  }

  /// `{value}M`
  String nMillions(Object value) {
    return Intl.message(
      '${value}M',
      name: 'nMillions',
      desc: '',
      args: [value],
    );
  }

  /// `Nothing was found at this url`
  String get nothingWasFoundAtThisUrl {
    return Intl.message(
      'Nothing was found at this url',
      name: 'nothingWasFoundAtThisUrl',
      desc: '',
      args: [],
    );
  }

  /// `To access you need to Log In`
  String get toAccessYouNeedToLogIn {
    return Intl.message(
      'To access you need to Log In',
      name: 'toAccessYouNeedToLogIn',
      desc: '',
      args: [],
    );
  }

  /// `Url copied!`
  String get urlCopied {
    return Intl.message(
      'Url copied!',
      name: 'urlCopied',
      desc: '',
      args: [],
    );
  }

  /// `Link to the source`
  String get linkToTheSource {
    return Intl.message(
      'Link to the source',
      name: 'linkToTheSource',
      desc: '',
      args: [],
    );
  }

  /// `Url not selected`
  String get urlNotSelected {
    return Intl.message(
      'Url not selected',
      name: 'urlNotSelected',
      desc: '',
      args: [],
    );
  }

  /// `Change the source`
  String get changeTheSource {
    return Intl.message(
      'Change the source',
      name: 'changeTheSource',
      desc: '',
      args: [],
    );
  }

  /// `Track isn't loaded`
  String get theTrackIsNotLoaded {
    return Intl.message(
      'Track isn\'t loaded',
      name: 'theTrackIsNotLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Track is loading: {percent}%`
  String theTrackIsLoading(Object percent) {
    return Intl.message(
      'Track is loading: $percent%',
      name: 'theTrackIsLoading',
      desc: '',
      args: [percent],
    );
  }

  /// `Track is loaded`
  String get theTrackIsLoaded {
    return Intl.message(
      'Track is loaded',
      name: 'theTrackIsLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Download error: {message}`
  String downloadError(Object message) {
    return Intl.message(
      'Download error: $message',
      name: 'downloadError',
      desc: '',
      args: [message],
    );
  }

  /// `no connection`
  String get noConnection {
    return Intl.message(
      'no connection',
      name: 'noConnection',
      desc: '',
      args: [],
    );
  }

  /// `Search by name`
  String get searchByName {
    return Intl.message(
      'Search by name',
      name: 'searchByName',
      desc: '',
      args: [],
    );
  }

  /// `Download all`
  String get downloadAll {
    return Intl.message(
      'Download all',
      name: 'downloadAll',
      desc: '',
      args: [],
    );
  }

  /// `Search history`
  String get searchHistory {
    return Intl.message(
      'Search history',
      name: 'searchHistory',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get main {
    return Intl.message(
      'Home',
      name: 'main',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Grant permissions`
  String get grantPermissions {
    return Intl.message(
      'Grant permissions',
      name: 'grantPermissions',
      desc: '',
      args: [],
    );
  }

  /// `To save music to any location on your phone, the app needs permission to work with the storage`
  String get storagePermissionText {
    return Intl.message(
      'To save music to any location on your phone, the app needs permission to work with the storage',
      name: 'storagePermissionText',
      desc: '',
      args: [],
    );
  }

  /// `To notify you of the download, the app needs access to send notifications`
  String get notificationsPermissionText {
    return Intl.message(
      'To notify you of the download, the app needs access to send notifications',
      name: 'notificationsPermissionText',
      desc: '',
      args: [],
    );
  }

  /// `Grant`
  String get grant {
    return Intl.message(
      'Grant',
      name: 'grant',
      desc: '',
      args: [],
    );
  }

  /// `Refuse`
  String get refuse {
    return Intl.message(
      'Refuse',
      name: 'refuse',
      desc: '',
      args: [],
    );
  }

  /// `SpotifySDK and Account`
  String get spotifySDKAndAccount {
    return Intl.message(
      'SpotifySDK and Account',
      name: 'spotifySDKAndAccount',
      desc: '',
      args: [],
    );
  }

  /// `Account information is being loaded`
  String get accountInformationIsBeingLoaded {
    return Intl.message(
      'Account information is being loaded',
      name: 'accountInformationIsBeingLoaded',
      desc: '',
      args: [],
    );
  }

  /// `You are not logged in to your account`
  String get youAreNotLoggedInToYourAccount {
    return Intl.message(
      'You are not logged in to your account',
      name: 'youAreNotLoggedInToYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error`
  String get unknownError {
    return Intl.message(
      'Unknown error',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Connection error`
  String get connectionError {
    return Intl.message(
      'Connection error',
      name: 'connectionError',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't log in to your account`
  String get couldntLogInToYourAccount {
    return Intl.message(
      'Couldn\'t log in to your account',
      name: 'couldntLogInToYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get logIn {
    return Intl.message(
      'Log in',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message(
      'Log out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Storage path`
  String get storagePath {
    return Intl.message(
      'Storage path',
      name: 'storagePath',
      desc: '',
      args: [],
    );
  }

  /// `Save all in one folder`
  String get saveAllInOneFolder {
    return Intl.message(
      'Save all in one folder',
      name: 'saveAllInOneFolder',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Tracks are being loaded`
  String get tracksAreBeingLoaded {
    return Intl.message(
      'Tracks are being loaded',
      name: 'tracksAreBeingLoaded',
      desc: '',
      args: [],
    );
  }

  /// `All tracks are loaded`
  String get allTracksAreLoaded {
    return Intl.message(
      'All tracks are loaded',
      name: 'allTracksAreLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Total: {total} | Loaded: {loaded} | Failured: {failure} | {percent}%`
  String tracksAreBeingLoadedBody(
      Object total, Object loaded, Object failure, Object percent) {
    return Intl.message(
      'Total: $total | Loaded: $loaded | Failured: $failure | $percent%',
      name: 'tracksAreBeingLoadedBody',
      desc: '',
      args: [total, loaded, failure, percent],
    );
  }

  /// `Loaded: {loaded} | Failured: {failured}`
  String allTracksAreLoadedBody(Object loaded, Object failured) {
    return Intl.message(
      'Loaded: $loaded | Failured: $failured',
      name: 'allTracksAreLoadedBody',
      desc: '',
      args: [loaded, failured],
    );
  }

  /// `Developed`
  String get developed {
    return Intl.message(
      'Developed',
      name: 'developed',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `You can close the app and the download will continue !`
  String get youCanCloseTheAppAndTheDownloadWillContinue {
    return Intl.message(
      'You can close the app and the download will continue !',
      name: 'youCanCloseTheAppAndTheDownloadWillContinue',
      desc: '',
      args: [],
    );
  }

  /// `(you can delete this message)`
  String get youCanDeleteThisMessage {
    return Intl.message(
      '(you can delete this message)',
      name: 'youCanDeleteThisMessage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

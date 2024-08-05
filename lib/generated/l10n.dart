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

  /// `Download from Link`
  String get downloadFromLink {
    return Intl.message(
      'Download from Link',
      name: 'downloadFromLink',
      desc: '',
      args: [],
    );
  }

  /// `What you want to download?`
  String get downloadFromLinkTextFieldHintText {
    return Intl.message(
      'What you want to download?',
      name: 'downloadFromLinkTextFieldHintText',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Link`
  String get incorrectLink {
    return Intl.message(
      'Invalid Link',
      name: 'incorrectLink',
      desc: '',
      args: [],
    );
  }

  /// `Download Liked Tracks`
  String get downloadLikedTracks {
    return Intl.message(
      'Download Liked Tracks',
      name: 'downloadLikedTracks',
      desc: '',
      args: [],
    );
  }

  /// `Liked Tracks`
  String get likedTracksTitle {
    return Intl.message(
      'Liked Tracks',
      name: 'likedTracksTitle',
      desc: '',
      args: [],
    );
  }

  /// `Active Downloads`
  String get activeDownloads {
    return Intl.message(
      'Active Downloads',
      name: 'activeDownloads',
      desc: '',
      args: [],
    );
  }

  /// `Error loading active downloads: {failure}`
  String errorOccurredWhileLoadingActiveDownloads(Object failure) {
    return Intl.message(
      'Error loading active downloads: $failure',
      name: 'errorOccurredWhileLoadingActiveDownloads',
      desc: '',
      args: [failure],
    );
  }

  /// `Nothing is loading ^_^`
  String get tracksDontLoad {
    return Intl.message(
      'Nothing is loading ^_^',
      name: 'tracksDontLoad',
      desc: '',
      args: [],
    );
  }

  /// `About the App`
  String get aboutApp {
    return Intl.message(
      'About the App',
      name: 'aboutApp',
      desc: '',
      args: [],
    );
  }

  /// `Special Thanks`
  String get specialThanks {
    return Intl.message(
      'Special Thanks',
      name: 'specialThanks',
      desc: '',
      args: [],
    );
  }

  /// `Change Download Source`
  String get changeTheDownloadSource {
    return Intl.message(
      'Change Download Source',
      name: 'changeTheDownloadSource',
      desc: '',
      args: [],
    );
  }

  /// `Connection Issue`
  String get theresSomethingWrongWithConnection {
    return Intl.message(
      'Connection Issue',
      name: 'theresSomethingWrongWithConnection',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message(
      'Try Again',
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

  /// `No results found for this URL`
  String get nothingWasFoundAtThisUrl {
    return Intl.message(
      'No results found for this URL',
      name: 'nothingWasFoundAtThisUrl',
      desc: '',
      args: [],
    );
  }

  /// `You need to log in to access`
  String get toAccessYouNeedToLogIn {
    return Intl.message(
      'You need to log in to access',
      name: 'toAccessYouNeedToLogIn',
      desc: '',
      args: [],
    );
  }

  /// `URL copied!`
  String get urlCopied {
    return Intl.message(
      'URL copied!',
      name: 'urlCopied',
      desc: '',
      args: [],
    );
  }

  /// `Source Link`
  String get linkToTheSource {
    return Intl.message(
      'Source Link',
      name: 'linkToTheSource',
      desc: '',
      args: [],
    );
  }

  /// `URL not selected`
  String get urlNotSelected {
    return Intl.message(
      'URL not selected',
      name: 'urlNotSelected',
      desc: '',
      args: [],
    );
  }

  /// `Change Source`
  String get changeTheSource {
    return Intl.message(
      'Change Source',
      name: 'changeTheSource',
      desc: '',
      args: [],
    );
  }

  /// `Track not loaded`
  String get theTrackIsNotLoaded {
    return Intl.message(
      'Track not loaded',
      name: 'theTrackIsNotLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Track loading: {percent}%`
  String theTrackIsLoading(Object percent) {
    return Intl.message(
      'Track loading: $percent%',
      name: 'theTrackIsLoading',
      desc: '',
      args: [percent],
    );
  }

  /// `Track loaded`
  String get theTrackIsLoaded {
    return Intl.message(
      'Track loaded',
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

  /// `No connection`
  String get noConnection {
    return Intl.message(
      'No connection',
      name: 'noConnection',
      desc: '',
      args: [],
    );
  }

  /// `Search by Name`
  String get searchByName {
    return Intl.message(
      'Search by Name',
      name: 'searchByName',
      desc: '',
      args: [],
    );
  }

  /// `Download All`
  String get downloadAll {
    return Intl.message(
      'Download All',
      name: 'downloadAll',
      desc: '',
      args: [],
    );
  }

  /// `Search History`
  String get searchHistory {
    return Intl.message(
      'Search History',
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

  /// `Grant Permissions`
  String get grantPermissions {
    return Intl.message(
      'Grant Permissions',
      name: 'grantPermissions',
      desc: '',
      args: [],
    );
  }

  /// `The app needs permission to access storage to save music anywhere on your phone`
  String get storagePermissionText {
    return Intl.message(
      'The app needs permission to access storage to save music anywhere on your phone',
      name: 'storagePermissionText',
      desc: '',
      args: [],
    );
  }

  /// `The app needs notification access to notify you of downloads`
  String get notificationsPermissionText {
    return Intl.message(
      'The app needs notification access to notify you of downloads',
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

  /// `Spotify SDK and Account`
  String get spotifySDKAndAccount {
    return Intl.message(
      'Spotify SDK and Account',
      name: 'spotifySDKAndAccount',
      desc: '',
      args: [],
    );
  }

  /// `Loading account information`
  String get accountInformationIsBeingLoaded {
    return Intl.message(
      'Loading account information',
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

  /// `Unknown Error`
  String get unknownError {
    return Intl.message(
      'Unknown Error',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Connection Error`
  String get connectionError {
    return Intl.message(
      'Connection Error',
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

  /// `Log In`
  String get logIn {
    return Intl.message(
      'Log In',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logOut {
    return Intl.message(
      'Log Out',
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

  /// `Storage Path`
  String get storagePath {
    return Intl.message(
      'Storage Path',
      name: 'storagePath',
      desc: '',
      args: [],
    );
  }

  /// `Save All in One Folder`
  String get saveAllInOneFolder {
    return Intl.message(
      'Save All in One Folder',
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

  /// `All tracks loaded`
  String get allTracksAreLoaded {
    return Intl.message(
      'All tracks loaded',
      name: 'allTracksAreLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Total: {total} | Loaded: {loaded} | Errors: {failure} | {percent}%`
  String tracksAreBeingLoadedBody(
      Object total, Object loaded, Object failure, Object percent) {
    return Intl.message(
      'Total: $total | Loaded: $loaded | Errors: $failure | $percent%',
      name: 'tracksAreBeingLoadedBody',
      desc: '',
      args: [total, loaded, failure, percent],
    );
  }

  /// `Loaded: {loaded} | Errors: {failured}`
  String allTracksAreLoadedBody(Object loaded, Object failured) {
    return Intl.message(
      'Loaded: $loaded | Errors: $failured',
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

  /// `You can close the app and the download will continue!`
  String get youCanCloseTheAppAndTheDownloadWillContinue {
    return Intl.message(
      'You can close the app and the download will continue!',
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

  /// `Error copied!`
  String get errorCopied {
    return Intl.message(
      'Error copied!',
      name: 'errorCopied',
      desc: '',
      args: [],
    );
  }

  /// `Licenses of Packages`
  String get packagesLicenses {
    return Intl.message(
      'Licenses of Packages',
      name: 'packagesLicenses',
      desc: '',
      args: [],
    );
  }

  /// `App Info`
  String get appInfo {
    return Intl.message(
      'App Info',
      name: 'appInfo',
      desc: '',
      args: [],
    );
  }

  /// `Name: {appName}`
  String appName(Object appName) {
    return Intl.message(
      'Name: $appName',
      name: 'appName',
      desc: '',
      args: [appName],
    );
  }

  /// `Package: {packageName}`
  String packageName(Object packageName) {
    return Intl.message(
      'Package: $packageName',
      name: 'packageName',
      desc: '',
      args: [packageName],
    );
  }

  /// `Version: {appVersion}`
  String appVersion(Object appVersion) {
    return Intl.message(
      'Version: $appVersion',
      name: 'appVersion',
      desc: '',
      args: [appVersion],
    );
  }

  /// `BuildNumber: {buildNumber}`
  String buildNumber(Object buildNumber) {
    return Intl.message(
      'BuildNumber: $buildNumber',
      name: 'buildNumber',
      desc: '',
      args: [buildNumber],
    );
  }

  /// `Developed by C0ntroldev`
  String get developedByC0ntrolDev {
    return Intl.message(
      'Developed by C0ntroldev',
      name: 'developedByC0ntrolDev',
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

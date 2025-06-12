// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get downloadFromLink => 'Download from Link';

  @override
  String get downloadFromLinkTextFieldHintText => 'What you want to download?';

  @override
  String get incorrectLink => 'Invalid Link';

  @override
  String get downloadLikedTracks => 'Download Liked Tracks';

  @override
  String get likedTracksTitle => 'Liked Tracks';

  @override
  String get activeDownloads => 'Active Downloads';

  @override
  String errorOccurredWhileLoadingActiveDownloads(Object failure) {
    return 'Error loading active downloads: $failure';
  }

  @override
  String get tracksDontLoad => 'Nothing is loading ^_^';

  @override
  String get aboutApp => 'About the App';

  @override
  String get specialThanks => 'Special Thanks';

  @override
  String get changeTheDownloadSource => 'Change Download Source';

  @override
  String get theresSomethingWrongWithConnection => 'Connection Issue';

  @override
  String get tryAgain => 'Try Again';

  @override
  String nView(Object views) {
    return '$views views';
  }

  @override
  String nThousands(Object value) {
    return '${value}K';
  }

  @override
  String nMillions(Object value) {
    return '${value}M';
  }

  @override
  String get nothingWasFoundAtThisUrl => 'No results found for this URL';

  @override
  String get toAccessYouNeedToLogIn => 'You need to log in to access';

  @override
  String get urlCopied => 'URL copied!';

  @override
  String get linkToTheSource => 'Source Link';

  @override
  String get urlNotSelected => 'URL not selected';

  @override
  String get changeTheSource => 'Change Source';

  @override
  String get theTrackIsNotLoaded => 'Track not loaded';

  @override
  String theTrackIsLoading(Object percent) {
    return 'Track loading: $percent%';
  }

  @override
  String get theTrackIsLoaded => 'Track loaded';

  @override
  String downloadError(Object message) {
    return 'Download error: $message';
  }

  @override
  String get noConnection => 'No connection';

  @override
  String get searchByName => 'Search by Name';

  @override
  String get downloadAll => 'Download All';

  @override
  String get searchHistory => 'Search History';

  @override
  String get main => 'Home';

  @override
  String get history => 'History';

  @override
  String get grantPermissions => 'Grant Permissions';

  @override
  String get storagePermissionText =>
      'The app needs permission to access storage to save music anywhere on your phone';

  @override
  String get notificationsPermissionText =>
      'The app needs notification access to notify you of downloads';

  @override
  String get grant => 'Grant';

  @override
  String get refuse => 'Refuse';

  @override
  String get spotifySDKAndAccount => 'Spotify SDK and Account';

  @override
  String get accountInformationIsBeingLoaded => 'Loading account information';

  @override
  String get youAreNotLoggedInToYourAccount =>
      'You are not logged in to your account';

  @override
  String get unknownError => 'Unknown Error';

  @override
  String get connectionError => 'Connection Error';

  @override
  String get couldntLogInToYourAccount => 'Couldn\'t log in to your account';

  @override
  String get logIn => 'Log In';

  @override
  String get logOut => 'Log Out';

  @override
  String get download => 'Download';

  @override
  String get storagePath => 'Storage Path';

  @override
  String get saveAllInOneFolder => 'Save All in One Folder';

  @override
  String get settings => 'Settings';

  @override
  String get other => 'Other';

  @override
  String get tracksAreBeingLoaded => 'Tracks are being loaded';

  @override
  String get allTracksAreLoaded => 'All tracks loaded';

  @override
  String tracksAreBeingLoadedBody(
      Object failure, Object loaded, Object percent, Object total) {
    return 'Total: $total | Loaded: $loaded | Errors: $failure | $percent%';
  }

  @override
  String allTracksAreLoadedBody(Object failured, Object loaded) {
    return 'Loaded: $loaded | Errors: $failured';
  }

  @override
  String get developed => 'Developed';

  @override
  String get language => 'Language';

  @override
  String get packagesLicenses => 'Licenses of Packages';

  @override
  String get appInfo => 'App Info';

  @override
  String appName(Object appName) {
    return 'Name: $appName';
  }

  @override
  String packageName(Object packageName) {
    return 'Package: $packageName';
  }

  @override
  String appVersion(Object appVersion) {
    return 'Version: $appVersion';
  }

  @override
  String buildNumber(Object buildNumber) {
    return 'BuildNumber: $buildNumber';
  }

  @override
  String get developedByC0ntrolDev => 'Developed by C0ntrolDev';

  @override
  String get failureCopied => 'Failure copied!';
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @downloadFromLink.
  ///
  /// In en, this message translates to:
  /// **'Download from Link'**
  String get downloadFromLink;

  /// No description provided for @downloadFromLinkTextFieldHintText.
  ///
  /// In en, this message translates to:
  /// **'What you want to download?'**
  String get downloadFromLinkTextFieldHintText;

  /// No description provided for @incorrectLink.
  ///
  /// In en, this message translates to:
  /// **'Invalid Link'**
  String get incorrectLink;

  /// No description provided for @downloadLikedTracks.
  ///
  /// In en, this message translates to:
  /// **'Download Liked Tracks'**
  String get downloadLikedTracks;

  /// No description provided for @likedTracksTitle.
  ///
  /// In en, this message translates to:
  /// **'Liked Tracks'**
  String get likedTracksTitle;

  /// No description provided for @activeDownloads.
  ///
  /// In en, this message translates to:
  /// **'Active Downloads'**
  String get activeDownloads;

  /// No description provided for @errorOccurredWhileLoadingActiveDownloads.
  ///
  /// In en, this message translates to:
  /// **'Error loading active downloads: {failure}'**
  String errorOccurredWhileLoadingActiveDownloads(Object failure);

  /// No description provided for @tracksDontLoad.
  ///
  /// In en, this message translates to:
  /// **'Nothing is loading ^_^'**
  String get tracksDontLoad;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About the App'**
  String get aboutApp;

  /// No description provided for @specialThanks.
  ///
  /// In en, this message translates to:
  /// **'Special Thanks'**
  String get specialThanks;

  /// No description provided for @changeTheDownloadSource.
  ///
  /// In en, this message translates to:
  /// **'Change Download Source'**
  String get changeTheDownloadSource;

  /// No description provided for @theresSomethingWrongWithConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection Issue'**
  String get theresSomethingWrongWithConnection;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @nView.
  ///
  /// In en, this message translates to:
  /// **'{views} views'**
  String nView(Object views);

  /// No description provided for @nThousands.
  ///
  /// In en, this message translates to:
  /// **'{value}K'**
  String nThousands(Object value);

  /// No description provided for @nMillions.
  ///
  /// In en, this message translates to:
  /// **'{value}M'**
  String nMillions(Object value);

  /// No description provided for @nothingWasFoundAtThisUrl.
  ///
  /// In en, this message translates to:
  /// **'No results found for this URL'**
  String get nothingWasFoundAtThisUrl;

  /// No description provided for @toAccessYouNeedToLogIn.
  ///
  /// In en, this message translates to:
  /// **'You need to log in to access'**
  String get toAccessYouNeedToLogIn;

  /// No description provided for @urlCopied.
  ///
  /// In en, this message translates to:
  /// **'URL copied!'**
  String get urlCopied;

  /// No description provided for @linkToTheSource.
  ///
  /// In en, this message translates to:
  /// **'Source Link'**
  String get linkToTheSource;

  /// No description provided for @urlNotSelected.
  ///
  /// In en, this message translates to:
  /// **'URL not selected'**
  String get urlNotSelected;

  /// No description provided for @changeTheSource.
  ///
  /// In en, this message translates to:
  /// **'Change Source'**
  String get changeTheSource;

  /// No description provided for @theTrackIsNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Track not loaded'**
  String get theTrackIsNotLoaded;

  /// No description provided for @theTrackIsLoading.
  ///
  /// In en, this message translates to:
  /// **'Track loading: {percent}%'**
  String theTrackIsLoading(Object percent);

  /// No description provided for @theTrackIsLoaded.
  ///
  /// In en, this message translates to:
  /// **'Track loaded'**
  String get theTrackIsLoaded;

  /// No description provided for @downloadError.
  ///
  /// In en, this message translates to:
  /// **'Download error: {message}'**
  String downloadError(Object message);

  /// No description provided for @noConnection.
  ///
  /// In en, this message translates to:
  /// **'No connection'**
  String get noConnection;

  /// No description provided for @searchByName.
  ///
  /// In en, this message translates to:
  /// **'Search by Name'**
  String get searchByName;

  /// No description provided for @downloadAll.
  ///
  /// In en, this message translates to:
  /// **'Download All'**
  String get downloadAll;

  /// No description provided for @searchHistory.
  ///
  /// In en, this message translates to:
  /// **'Search History'**
  String get searchHistory;

  /// No description provided for @main.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get main;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @grantPermissions.
  ///
  /// In en, this message translates to:
  /// **'Grant Permissions'**
  String get grantPermissions;

  /// No description provided for @storagePermissionText.
  ///
  /// In en, this message translates to:
  /// **'The app needs permission to access storage to save music anywhere on your phone'**
  String get storagePermissionText;

  /// No description provided for @notificationsPermissionText.
  ///
  /// In en, this message translates to:
  /// **'The app needs notification access to notify you of downloads'**
  String get notificationsPermissionText;

  /// No description provided for @grant.
  ///
  /// In en, this message translates to:
  /// **'Grant'**
  String get grant;

  /// No description provided for @refuse.
  ///
  /// In en, this message translates to:
  /// **'Refuse'**
  String get refuse;

  /// No description provided for @spotifySDKAndAccount.
  ///
  /// In en, this message translates to:
  /// **'Spotify SDK and Account'**
  String get spotifySDKAndAccount;

  /// No description provided for @accountInformationIsBeingLoaded.
  ///
  /// In en, this message translates to:
  /// **'Loading account information'**
  String get accountInformationIsBeingLoaded;

  /// No description provided for @youAreNotLoggedInToYourAccount.
  ///
  /// In en, this message translates to:
  /// **'You are not logged in to your account'**
  String get youAreNotLoggedInToYourAccount;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown Error'**
  String get unknownError;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// No description provided for @couldntLogInToYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t log in to your account'**
  String get couldntLogInToYourAccount;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @storagePath.
  ///
  /// In en, this message translates to:
  /// **'Storage Path'**
  String get storagePath;

  /// No description provided for @saveAllInOneFolder.
  ///
  /// In en, this message translates to:
  /// **'Save All in One Folder'**
  String get saveAllInOneFolder;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @tracksAreBeingLoaded.
  ///
  /// In en, this message translates to:
  /// **'Tracks are being loaded'**
  String get tracksAreBeingLoaded;

  /// No description provided for @allTracksAreLoaded.
  ///
  /// In en, this message translates to:
  /// **'All tracks loaded'**
  String get allTracksAreLoaded;

  /// No description provided for @tracksAreBeingLoadedBody.
  ///
  /// In en, this message translates to:
  /// **'Total: {total} | Loaded: {loaded} | Errors: {failure} | {percent}%'**
  String tracksAreBeingLoadedBody(
      Object failure, Object loaded, Object percent, Object total);

  /// No description provided for @allTracksAreLoadedBody.
  ///
  /// In en, this message translates to:
  /// **'Loaded: {loaded} | Errors: {failured}'**
  String allTracksAreLoadedBody(Object failured, Object loaded);

  /// No description provided for @developed.
  ///
  /// In en, this message translates to:
  /// **'Developed'**
  String get developed;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @packagesLicenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses of Packages'**
  String get packagesLicenses;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App Info'**
  String get appInfo;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Name: {appName}'**
  String appName(Object appName);

  /// No description provided for @packageName.
  ///
  /// In en, this message translates to:
  /// **'Package: {packageName}'**
  String packageName(Object packageName);

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version: {appVersion}'**
  String appVersion(Object appVersion);

  /// No description provided for @buildNumber.
  ///
  /// In en, this message translates to:
  /// **'BuildNumber: {buildNumber}'**
  String buildNumber(Object buildNumber);

  /// No description provided for @developedByC0ntrolDev.
  ///
  /// In en, this message translates to:
  /// **'Developed by C0ntrolDev'**
  String get developedByC0ntrolDev;

  /// No description provided for @failureCopied.
  ///
  /// In en, this message translates to:
  /// **'Failure copied!'**
  String get failureCopied;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

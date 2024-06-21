// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(loaded, failured) =>
      "Loaded: ${loaded} | Errors: ${failured}";

  static String m1(message) => "Download error: ${message}";

  static String m2(failure) => "Error loading active downloads: ${failure}";

  static String m3(value) => "${value}M";

  static String m4(value) => "${value}K";

  static String m5(views) => "${views} views";

  static String m6(percent) => "Track loading: ${percent}%";

  static String m7(total, loaded, failure, percent) =>
      "Total: ${total} | Loaded: ${loaded} | Errors: ${failure} | ${percent}%";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutApp": MessageLookupByLibrary.simpleMessage("About the App"),
        "accountInformationIsBeingLoaded":
            MessageLookupByLibrary.simpleMessage("Loading account information"),
        "activeDownloads":
            MessageLookupByLibrary.simpleMessage("Active Downloads"),
        "allTracksAreLoaded":
            MessageLookupByLibrary.simpleMessage("All tracks loaded"),
        "allTracksAreLoadedBody": m0,
        "changeTheDownloadSource":
            MessageLookupByLibrary.simpleMessage("Change Download Source"),
        "changeTheSource":
            MessageLookupByLibrary.simpleMessage("Change Source"),
        "connectionError":
            MessageLookupByLibrary.simpleMessage("Connection Error"),
        "couldntLogInToYourAccount": MessageLookupByLibrary.simpleMessage(
            "Couldn\'t log in to your account"),
        "developed": MessageLookupByLibrary.simpleMessage("Developed"),
        "download": MessageLookupByLibrary.simpleMessage("Download"),
        "downloadAll": MessageLookupByLibrary.simpleMessage("Download All"),
        "downloadError": m1,
        "downloadFromLink":
            MessageLookupByLibrary.simpleMessage("Download from Link"),
        "downloadFromLinkTextFieldHintText":
            MessageLookupByLibrary.simpleMessage("What you want to download?"),
        "downloadLikedTracks":
            MessageLookupByLibrary.simpleMessage("Download Liked Tracks"),
        "errorOccurredWhileLoadingActiveDownloads": m2,
        "grant": MessageLookupByLibrary.simpleMessage("Grant"),
        "grantPermissions":
            MessageLookupByLibrary.simpleMessage("Grant Permissions"),
        "history": MessageLookupByLibrary.simpleMessage("History"),
        "incorrectLink": MessageLookupByLibrary.simpleMessage("Invalid Link"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "likedTracksTitle":
            MessageLookupByLibrary.simpleMessage("Liked Tracks"),
        "linkToTheSource": MessageLookupByLibrary.simpleMessage("Source Link"),
        "logIn": MessageLookupByLibrary.simpleMessage("Log In"),
        "logOut": MessageLookupByLibrary.simpleMessage("Log Out"),
        "main": MessageLookupByLibrary.simpleMessage("Home"),
        "nMillions": m3,
        "nThousands": m4,
        "nView": m5,
        "noConnection": MessageLookupByLibrary.simpleMessage("No connection"),
        "nothingWasFoundAtThisUrl": MessageLookupByLibrary.simpleMessage(
            "No results found for this URL"),
        "notificationsPermissionText": MessageLookupByLibrary.simpleMessage(
            "The app needs notification access to notify you of downloads"),
        "other": MessageLookupByLibrary.simpleMessage("Other"),
        "refuse": MessageLookupByLibrary.simpleMessage("Refuse"),
        "saveAllInOneFolder":
            MessageLookupByLibrary.simpleMessage("Save All in One Folder"),
        "searchByName": MessageLookupByLibrary.simpleMessage("Search by Name"),
        "searchHistory": MessageLookupByLibrary.simpleMessage("Search History"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "specialThanks": MessageLookupByLibrary.simpleMessage("Special Thanks"),
        "spotifySDKAndAccount":
            MessageLookupByLibrary.simpleMessage("Spotify SDK and Account"),
        "storagePath": MessageLookupByLibrary.simpleMessage("Storage Path"),
        "storagePermissionText": MessageLookupByLibrary.simpleMessage(
            "The app needs permission to access storage to save music anywhere on your phone"),
        "theTrackIsLoaded":
            MessageLookupByLibrary.simpleMessage("Track loaded"),
        "theTrackIsLoading": m6,
        "theTrackIsNotLoaded":
            MessageLookupByLibrary.simpleMessage("Track not loaded"),
        "theresSomethingWrongWithConnection":
            MessageLookupByLibrary.simpleMessage("Connection Issue"),
        "toAccessYouNeedToLogIn": MessageLookupByLibrary.simpleMessage(
            "You need to log in to access"),
        "tracksAreBeingLoaded":
            MessageLookupByLibrary.simpleMessage("Tracks are being loaded"),
        "tracksAreBeingLoadedBody": m7,
        "tracksDontLoad":
            MessageLookupByLibrary.simpleMessage("Nothing is loading ^_^"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Try Again"),
        "unknownError": MessageLookupByLibrary.simpleMessage("Unknown Error"),
        "urlCopied": MessageLookupByLibrary.simpleMessage("URL copied!"),
        "urlNotSelected":
            MessageLookupByLibrary.simpleMessage("URL not selected"),
        "youAreNotLoggedInToYourAccount": MessageLookupByLibrary.simpleMessage(
            "You are not logged in to your account"),
        "youCanCloseTheAppAndTheDownloadWillContinue":
            MessageLookupByLibrary.simpleMessage(
                "You can close the app and the download will continue!"),
        "youCanDeleteThisMessage": MessageLookupByLibrary.simpleMessage(
            "(you can delete this message)")
      };
}

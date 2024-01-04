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
      "Loaded: ${loaded} | Failured: ${failured}";

  static String m1(message) => "Download error: ${message}";

  static String m2(failure) =>
      "Error occurred while loading active downloads: ${failure}";

  static String m3(value) => "${value}M";

  static String m4(value) => "${value}K";

  static String m5(views) => "${views} views";

  static String m6(percent) => "Track is loading: ${percent}%";

  static String m7(total, loaded, failure, percent) =>
      "Total: ${total} | Loaded: ${loaded} | Failured: ${failure} | ${percent}%";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutApp": MessageLookupByLibrary.simpleMessage("About app"),
        "accountInformationIsBeingLoaded": MessageLookupByLibrary.simpleMessage(
            "Account information is being loaded"),
        "activeDownloads":
            MessageLookupByLibrary.simpleMessage("Active downloads"),
        "allTracksAreLoaded":
            MessageLookupByLibrary.simpleMessage("All tracks are loaded"),
        "allTracksAreLoadedBody": m0,
        "changeTheDownloadSource":
            MessageLookupByLibrary.simpleMessage("Change the download source"),
        "changeTheSource":
            MessageLookupByLibrary.simpleMessage("Change the source"),
        "connectionError":
            MessageLookupByLibrary.simpleMessage("Connection error"),
        "couldntLogInToYourAccount": MessageLookupByLibrary.simpleMessage(
            "Couldn\'t log in to your account"),
        "developed": MessageLookupByLibrary.simpleMessage("Developed"),
        "download": MessageLookupByLibrary.simpleMessage("Download"),
        "downloadAll": MessageLookupByLibrary.simpleMessage("Download all"),
        "downloadError": m1,
        "downloadFromLink":
            MessageLookupByLibrary.simpleMessage("Download from link"),
        "downloadFromLinkTextFieldHintText":
            MessageLookupByLibrary.simpleMessage(
                "Link to a track, playlist, or album"),
        "downloadLikedTracks":
            MessageLookupByLibrary.simpleMessage("Download liked tracks"),
        "errorOccurredWhileLoadingActiveDownloads": m2,
        "grant": MessageLookupByLibrary.simpleMessage("Grant"),
        "grantPermissions":
            MessageLookupByLibrary.simpleMessage("Grant permissions"),
        "history": MessageLookupByLibrary.simpleMessage("History"),
        "incorrectLink": MessageLookupByLibrary.simpleMessage("Incorrect link"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "likedTracksTitle":
            MessageLookupByLibrary.simpleMessage("Liked tracks"),
        "linkToTheSource":
            MessageLookupByLibrary.simpleMessage("Link to the source"),
        "logIn": MessageLookupByLibrary.simpleMessage("Log in"),
        "logOut": MessageLookupByLibrary.simpleMessage("Log out"),
        "main": MessageLookupByLibrary.simpleMessage("Home"),
        "nMillions": m3,
        "nThousands": m4,
        "nView": m5,
        "noConnection": MessageLookupByLibrary.simpleMessage("no connection"),
        "nothingWasFoundAtThisUrl": MessageLookupByLibrary.simpleMessage(
            "Nothing was found at this url"),
        "notificationsPermissionText": MessageLookupByLibrary.simpleMessage(
            "To notify you of the download, the app needs access to send notifications"),
        "other": MessageLookupByLibrary.simpleMessage("Other"),
        "refuse": MessageLookupByLibrary.simpleMessage("Refuse"),
        "saveAllInOneFolder":
            MessageLookupByLibrary.simpleMessage("Save all in one folder"),
        "searchByName": MessageLookupByLibrary.simpleMessage("Search by name"),
        "searchHistory": MessageLookupByLibrary.simpleMessage("Search history"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "specialThanks": MessageLookupByLibrary.simpleMessage("Special thanks"),
        "spotifySDKAndAccount":
            MessageLookupByLibrary.simpleMessage("SpotifySDK and Account"),
        "storagePath": MessageLookupByLibrary.simpleMessage("Storage path"),
        "storagePermissionText": MessageLookupByLibrary.simpleMessage(
            "To save music to any location on your phone, the app needs permission to work with the storage"),
        "theTrackIsLoaded":
            MessageLookupByLibrary.simpleMessage("Track is loaded"),
        "theTrackIsLoading": m6,
        "theTrackIsNotLoaded":
            MessageLookupByLibrary.simpleMessage("Track isn\'t loaded"),
        "theresSomethingWrongWithConnection":
            MessageLookupByLibrary.simpleMessage(
                "There\'s something wrong with connection"),
        "toAccessYouNeedToLogIn": MessageLookupByLibrary.simpleMessage(
            "To access you need to Log In"),
        "tracksAreBeingLoaded":
            MessageLookupByLibrary.simpleMessage("Tracks are being loaded"),
        "tracksAreBeingLoadedBody": m7,
        "tracksDontLoad":
            MessageLookupByLibrary.simpleMessage("Tracks don\'t load   ^_^"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Try again"),
        "unknownError": MessageLookupByLibrary.simpleMessage("Unknown error"),
        "urlCopied": MessageLookupByLibrary.simpleMessage("Url copied!"),
        "urlNotSelected":
            MessageLookupByLibrary.simpleMessage("Url not selected"),
        "youAreNotLoggedInToYourAccount": MessageLookupByLibrary.simpleMessage(
            "You are not logged in to your account")
      };
}

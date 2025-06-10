// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [AboutAppScreen]
class AboutAppRoute extends PageRouteInfo<void> {
  const AboutAppRoute({List<PageRouteInfo>? children})
      : super(AboutAppRoute.name, initialChildren: children);

  static const String name = 'AboutAppRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AboutAppScreen();
    },
  );
}

/// generated route for
/// [ChangeSourceVideoScreen]
class ChangeSourceVideoRoute extends PageRouteInfo<ChangeSourceVideoRouteArgs> {
  ChangeSourceVideoRoute({
    Key? key,
    required Track track,
    String? oldYoutubeUrl,
    List<PageRouteInfo>? children,
  }) : super(
          ChangeSourceVideoRoute.name,
          args: ChangeSourceVideoRouteArgs(
            key: key,
            track: track,
            oldYoutubeUrl: oldYoutubeUrl,
          ),
          initialChildren: children,
        );

  static const String name = 'ChangeSourceVideoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChangeSourceVideoRouteArgs>();
      return ChangeSourceVideoScreen(
        key: args.key,
        track: args.track,
        oldYoutubeUrl: args.oldYoutubeUrl,
      );
    },
  );
}

class ChangeSourceVideoRouteArgs {
  const ChangeSourceVideoRouteArgs({
    this.key,
    required this.track,
    this.oldYoutubeUrl,
  });

  final Key? key;

  final Track track;

  final String? oldYoutubeUrl;

  @override
  String toString() {
    return 'ChangeSourceVideoRouteArgs{key: $key, track: $track, oldYoutubeUrl: $oldYoutubeUrl}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChangeSourceVideoRouteArgs) return false;
    return key == other.key &&
        track == other.track &&
        oldYoutubeUrl == other.oldYoutubeUrl;
  }

  @override
  int get hashCode => key.hashCode ^ track.hashCode ^ oldYoutubeUrl.hashCode;
}

/// generated route for
/// [DownloadTracksCollectionScreenWithHistoryTracksCollection]
class DownloadTracksCollectionRouteWithHistoryTracksCollection
    extends PageRouteInfo<
        DownloadTracksCollectionRouteWithHistoryTracksCollectionArgs> {
  DownloadTracksCollectionRouteWithHistoryTracksCollection({
    Key? key,
    required HistoryTracksCollection historyTracksCollection,
    List<PageRouteInfo>? children,
  }) : super(
          DownloadTracksCollectionRouteWithHistoryTracksCollection.name,
          args: DownloadTracksCollectionRouteWithHistoryTracksCollectionArgs(
            key: key,
            historyTracksCollection: historyTracksCollection,
          ),
          initialChildren: children,
        );

  static const String name =
      'DownloadTracksCollectionRouteWithHistoryTracksCollection';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<
          DownloadTracksCollectionRouteWithHistoryTracksCollectionArgs>();
      return DownloadTracksCollectionScreenWithHistoryTracksCollection(
        key: args.key,
        historyTracksCollection: args.historyTracksCollection,
      );
    },
  );
}

class DownloadTracksCollectionRouteWithHistoryTracksCollectionArgs {
  const DownloadTracksCollectionRouteWithHistoryTracksCollectionArgs({
    this.key,
    required this.historyTracksCollection,
  });

  final Key? key;

  final HistoryTracksCollection historyTracksCollection;

  @override
  String toString() {
    return 'DownloadTracksCollectionRouteWithHistoryTracksCollectionArgs{key: $key, historyTracksCollection: $historyTracksCollection}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DownloadTracksCollectionRouteWithHistoryTracksCollectionArgs)
      return false;
    return key == other.key &&
        historyTracksCollection == other.historyTracksCollection;
  }

  @override
  int get hashCode => key.hashCode ^ historyTracksCollection.hashCode;
}

/// generated route for
/// [DownloadTracksCollectionScreenWithUrl]
class DownloadTracksCollectionRouteWithUrl
    extends PageRouteInfo<DownloadTracksCollectionRouteWithUrlArgs> {
  DownloadTracksCollectionRouteWithUrl({
    Key? key,
    required String url,
    List<PageRouteInfo>? children,
  }) : super(
          DownloadTracksCollectionRouteWithUrl.name,
          args: DownloadTracksCollectionRouteWithUrlArgs(key: key, url: url),
          initialChildren: children,
        );

  static const String name = 'DownloadTracksCollectionRouteWithUrl';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DownloadTracksCollectionRouteWithUrlArgs>();
      return DownloadTracksCollectionScreenWithUrl(
        key: args.key,
        url: args.url,
      );
    },
  );
}

class DownloadTracksCollectionRouteWithUrlArgs {
  const DownloadTracksCollectionRouteWithUrlArgs({this.key, required this.url});

  final Key? key;

  final String url;

  @override
  String toString() {
    return 'DownloadTracksCollectionRouteWithUrlArgs{key: $key, url: $url}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DownloadTracksCollectionRouteWithUrlArgs) return false;
    return key == other.key && url == other.url;
  }

  @override
  int get hashCode => key.hashCode ^ url.hashCode;
}

/// generated route for
/// [HistoryScreen]
class HistoryRoute extends PageRouteInfo<void> {
  const HistoryRoute({List<PageRouteInfo>? children})
      : super(HistoryRoute.name, initialChildren: children);

  static const String name = 'HistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HistoryScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [MainScreen]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainScreen();
    },
  );
}

/// generated route for
/// [PackagesInfoScreen]
class PackagesInfoRoute extends PageRouteInfo<void> {
  const PackagesInfoRoute({List<PageRouteInfo>? children})
      : super(PackagesInfoRoute.name, initialChildren: children);

  static const String name = 'PackagesInfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PackagesInfoScreen();
    },
  );
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}

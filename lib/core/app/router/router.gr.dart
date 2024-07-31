// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AboutAppRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AboutAppScreen(),
      );
    },
    ChangeSourceVideoRoute.name: (routeData) {
      final args = routeData.argsAs<ChangeSourceVideoRouteArgs>();
      return AutoRoutePage<String?>(
        routeData: routeData,
        child: ChangeSourceVideoScreen(
          key: args.key,
          track: args.track,
          oldYoutubeUrl: args.selectedYoutubeUrl,
        ),
      );
    },
    DownloadTracksCollectionRouteWithHistoryTracksCollection.name: (routeData) {
      final args = routeData.argsAs<
          DownloadTracksCollectionRouteWithHistoryTracksCollectionArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DownloadTracksCollectionScreenWithHistoryTracksCollection(
          key: args.key,
          historyTracksCollection: args.historyTracksCollection,
        ),
      );
    },
    DownloadTracksCollectionRouteWithUrl.name: (routeData) {
      final args = routeData.argsAs<DownloadTracksCollectionRouteWithUrlArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DownloadTracksCollectionScreenWithUrl(
          key: args.key,
          url: args.url,
        ),
      );
    },
    HistoryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HistoryScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    MainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsScreen(),
      );
    },
  };
}

/// generated route for
/// [AboutAppScreen]
class AboutAppRoute extends PageRouteInfo<void> {
  const AboutAppRoute({List<PageRouteInfo>? children})
      : super(
          AboutAppRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutAppRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
            selectedYoutubeUrl: oldYoutubeUrl,
          ),
          initialChildren: children,
        );

  static const String name = 'ChangeSourceVideoRoute';

  static const PageInfo<ChangeSourceVideoRouteArgs> page =
      PageInfo<ChangeSourceVideoRouteArgs>(name);
}

class ChangeSourceVideoRouteArgs {
  const ChangeSourceVideoRouteArgs({
    this.key,
    required this.track,
    this.selectedYoutubeUrl,
  });

  final Key? key;

  final Track track;

  final String? selectedYoutubeUrl;

  @override
  String toString() {
    return 'ChangeSourceVideoRouteArgs{key: $key, track: $track, selectedYoutubeUrl: $selectedYoutubeUrl}';
  }
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

  static const PageInfo<
          DownloadTracksCollectionRouteWithHistoryTracksCollectionArgs> page =
      PageInfo<DownloadTracksCollectionRouteWithHistoryTracksCollectionArgs>(
          name);
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
          args: DownloadTracksCollectionRouteWithUrlArgs(
            key: key,
            url: url,
          ),
          initialChildren: children,
        );

  static const String name = 'DownloadTracksCollectionRouteWithUrl';

  static const PageInfo<DownloadTracksCollectionRouteWithUrlArgs> page =
      PageInfo<DownloadTracksCollectionRouteWithUrlArgs>(name);
}

class DownloadTracksCollectionRouteWithUrlArgs {
  const DownloadTracksCollectionRouteWithUrlArgs({
    this.key,
    required this.url,
  });

  final Key? key;

  final String url;

  @override
  String toString() {
    return 'DownloadTracksCollectionRouteWithUrlArgs{key: $key, url: $url}';
  }
}

/// generated route for
/// [HistoryScreen]
class HistoryRoute extends PageRouteInfo<void> {
  const HistoryRoute({List<PageRouteInfo>? children})
      : super(
          HistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'HistoryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainScreen]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

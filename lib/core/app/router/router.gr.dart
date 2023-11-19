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
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
  };
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

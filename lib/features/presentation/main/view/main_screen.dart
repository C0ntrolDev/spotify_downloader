import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/core/permissions/permission_services_initializer/permission_services_initializer_class.dart';
import 'package:spotify_downloader/core/permissions/permissions_manager/permissions_manager_class.dart';
import 'package:spotify_downloader/features/presentation/main/tools/bottom_navigation_bar_observer.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/ftoasts/ftoast_initializer.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/orientated_navigation_bar/orientated_navigation_bar.dart';
import 'package:spotify_downloader/features/presentation/permissions_dialog/view/permissions_dialog.dart';
import 'package:spotify_downloader/generated/l10n.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PermissionsManager _permissionsManager = injector.get<PermissionsManager>();
  final PermissionServicesInitializer _permissionServicesInitializer =
      injector.get<PermissionServicesInitializer>();

  final List<PageRouteInfo> _bottomNavigationBarRoutes = [const HomeRoute(), const HistoryRoute()];

  int _currentIndexField = 0;
  int get _currentIndex => _currentIndexField;
  set _currentIndex(int newIndex) {
    _currentIndexField = newIndex;
    _currentIndexStreamController.add(newIndex);
  }

  final StreamController<int> _currentIndexStreamController = StreamController.broadcast();

  late final BottomNavigationBarObserver _routeObserver;

  @override
  void initState() {
    super.initState();
    _routeObserver = BottomNavigationBarObserver(onRouteChanged: _onRouteChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future(() async {
        if (!(await _permissionsManager.isPermissionsGranted()) && context.mounted) {
          //check context.mounted in previous line
          // ignore: use_build_context_synchronously
          showPermissonsDialog(context, () async {
            final isPermissionsGranted = await _permissionsManager.requestPermissions();
            await _permissionServicesInitializer.init();
            return isPermissionsGranted;
          });
        }
      });
    });
  }

  void _onRouteChanged(Route? newRoute) {
    if (newRoute == null || newRoute.data == null) return;
    final indexOfRoute =
        _bottomNavigationBarRoutes.indexWhere((PageRouteInfo route) => route.routeName == newRoute.data!.name);
    if (indexOfRoute != -1) {
      if (_currentIndex != indexOfRoute) {
        _currentIndex = indexOfRoute;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
          initialData: 0,
          stream: _currentIndexStreamController.stream,
          builder: (context, value) {
            return OrientatedNavigationBar(
                expandBody: true,
                horizontalNavigationBarTheme: HorizontalNavigationBarTheme(
                  width: 200,
                  itemContentHeight: 55,
                  contentPadding: const EdgeInsets.only(left: horizontalPadding, top: 10),
                  backgroundDecorations: const BoxDecoration(color: horizontalNavigationBarColor),
                  labelFontSize: Theme.of(context).textTheme.labelMedium!.fontSize!,
                  iconSize: const Size(25, 25),
                  selectedItemColor: onBackgroundPrimaryColor,
                  unselectedItemColor: onBackgroundSecondaryColor,
                  selectingItemColor: onBackgroundThirdRateColor,
                  selectingSize: 0.9,
                  animationDuration: const Duration(milliseconds: 100),
                ),
                verticalNavigationBarTheme: VerticalNavigationBarTheme(
                  contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 17, bottom: 7),
                  backgroundDecorations: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color.fromARGB(0, 0, 0, 0), Color.fromARGB(230, 0, 0, 0)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  labelFontSize: Theme.of(context).textTheme.labelSmall!.fontSize!,
                  iconSize: const Size(25, 25),
                  selectedItemColor: onBackgroundPrimaryColor,
                  unselectedItemColor: onBackgroundSecondaryColor,
                  selectingItemColor: onBackgroundThirdRateColor,
                  selectingSize: 0.9,
                  animationDuration: const Duration(milliseconds: 50),
                ),
                currentIndex: value.data!,
                onTap: (index) {
                  if (AutoRouter.of(context).topRoute.name != _bottomNavigationBarRoutes[index].routeName) {
                    AutoRouter.of(context).push(_bottomNavigationBarRoutes[index]);
                    _currentIndex = index;
                  }
                },
                items: [
                  OrientatedNavigationBarItem(
                      svgIconPath: 'resources/images/svg/bottom_bar/home_icon.svg',
                      svgActiveIconPath: 'resources/images/svg/bottom_bar/home_icon_active.svg',
                      label: S.of(context).main),
                  OrientatedNavigationBarItem(
                      svgIconPath: 'resources/images/svg/bottom_bar/history_icon.svg',
                      svgActiveIconPath: 'resources/images/svg/bottom_bar/history_icon_active.svg',
                      label: S.of(context).history)
                ],
                child: FtoastInitializer(
                  child: AutoRouter(
                    navigatorObservers: () => [_routeObserver],
                  ),
                ));
          }),
    );
  }
}

